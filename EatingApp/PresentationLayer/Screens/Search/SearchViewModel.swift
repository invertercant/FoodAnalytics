//
//  SearchViewModel.swift
//  EatingApp
//
//  Created Александр Савченко on 24.09.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxSwiftExt
import RxCombine

struct PaginationState{
    var offset: Int = 0
    var lastPortionWasLoaded: Bool = false
    var requestInProgress: Bool = false
}

struct PaginationSettings{
    var limit: Int = 20
    var prefetchWindow: Int = 10
}

enum SearchCategory: String{
    case foundation = "Foundation"
    case legacy = "SR Legacy"
    case branded = "Branded"
}

class SearchViewModel {

    var disposeBag = DisposeBag()
    
    enum Action{
        case viewDidLoad
        case retrySearch
        case retryNewPage
        case search(String)
        case elementWillDisplay(index: Int)
    }
    
    enum Mutation{
        //case setIsLoading(Bool)
        case setSearchString(String)
        case didEndSearchSuccess(FoodSearchResult)
        case didEndSearchFailure(Error)
        case didEndFetchPageSuccess(FoodSearchResult)
        case didEndFetchPageFailure(Error)
        case setPaginationRequestInProgress(Bool)
        case clearError
    }
    
    struct State {
        var searchString: String = ""
        var searchFieldVM: TextFieldVM = TextFieldVM(placeholder: "search here")
        var error: UIErrors?
        var isLoading: Bool{
            paginationState.requestInProgress
        }
        var sections: [SearchScreenSection] = []
        var paginationState = PaginationState()
        var paginationSettings = PaginationSettings()
        var pageRetryVM = RetryFooterVM(title: "Loading error", retry: "Retry")
        var searchRetryEvents: PublishSubject<Void> = PublishSubject()
        var hasError: Bool{
            error != nil
        }
        var footerOptions: PaginationFooterControlVM{
            let showRetry = !isLoading && hasError && !sections.isEmpty
            let showLoading = isLoading && !hasError
            return PaginationFooterControlVM(showRetry: showRetry, showLoading: showLoading)
        }
    }
    
    let interactor: SearchInteractorType
    let actionsSubject: PublishSubject<Action> = PublishSubject()
    let stateSubject: BehaviorSubject = BehaviorSubject(value: State())
    let navigationEventsSubject: PublishSubject<SearchNavigationEvents> = PublishSubject()

    init(interactor: SearchInteractorType) {
        self.interactor = interactor
        setReaction()
    }
    
    func setReaction(){
        
        actionsSubject
        .flatMap { [unowned self] action -> Observable<Mutation> in
            self.mutate(action: action)
        }
        .withLatestFrom(stateSubject){(mutation: $0, state:$1)}
        .subscribe ( onNext: { [weak self] mutation, state in
            guard let self = self else {return}
            let newState = self.reduce(state: state, mutation: mutation)
            self.stateSubject.onNext(newState)
        }).disposed(by: disposeBag)
        
        if let state = try? stateSubject.value(){
            subscribeStableStateEvents(state: state)
        }
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {

        var mutations: [Observable<Mutation>] = []

        switch action {
        case .viewDidLoad:
            mutations.append(Observable.just(Mutation.setPaginationRequestInProgress(true)))
            mutations.append(setEndNewSearchMutation())
        case .retrySearch:
            break
        case .retryNewPage:
            mutations.append(Observable.just(Mutation.clearError))
            mutations.append(Observable.just(Mutation.setPaginationRequestInProgress(true)))
            mutations.append(setFetchNewPageMutation())
        case .search(let value):
            mutations.append(Observable.just(Mutation.setSearchString(value)))
            mutations.append(Observable.just(Mutation.setPaginationRequestInProgress(true)))
            mutations.append(setEndNewSearchMutation())
            print("search: \(value)")
        case .elementWillDisplay(let index):
            guard let state = try? stateSubject.value() else {break}
            guard let section = state.sections.first else {break}
            guard state.paginationState.lastPortionWasLoaded == false else {break}
            if index > section.items.count - state.paginationSettings.prefetchWindow && !state.paginationState.requestInProgress && state.error == nil{
                mutations.append(Observable.just(Mutation.setPaginationRequestInProgress(true)))
                mutations.append(setFetchNewPageMutation())
            }
            print("elementWillDisplay: index \(index)")
        }
        
        return Observable.concat(mutations)

    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .didEndSearchSuccess(let response):
            let sections = buildSections(input: response)
            newState.sections = sections
            newState.error = nil
            if response.foods.count < state.paginationSettings.limit{
                newState.paginationState.lastPortionWasLoaded = true
            }
        case .didEndSearchFailure(let error):
            var uiError: UIErrors = .serverError
            newState.error = uiError
        case .setSearchString(let value):
            newState.searchString = value
            newState.sections = []
            newState.paginationState.lastPortionWasLoaded = false
        case .didEndFetchPageSuccess(let pageData):
            newState.sections = appendItems(sections: state.sections, newData: pageData)
            newState.error = nil
            if pageData.foods.count < state.paginationSettings.limit{
                newState.paginationState.lastPortionWasLoaded = true
            }
        case .didEndFetchPageFailure(_):
            newState.error = .serverError
        case .setPaginationRequestInProgress(let value):
            newState.paginationState.requestInProgress = value
        case .clearError:
            newState.error = nil
        }
        
        return newState
    }
    
    func buildSections(input: FoodSearchResult) -> [SearchScreenSection]{
        
        var section = SearchScreenSection()
        section.items = items(input: input)
        return [section]
    }
    
    func appendItems(sections: [SearchScreenSection], newData: FoodSearchResult) -> [SearchScreenSection]{
        
        var result = sections
        guard result.count > 0 else {return result}
        result[0].items.append(contentsOf: items(input: newData))
        return result
        
    }
    
    func items(input: FoodSearchResult) -> [SearchScreenSectionTableModels]{
        
        let items = input.foods.map {
            let vm = FoodElementFoodItemConvertibleAdapter(adaptee: $0).foodItemVM()
            let item = SearchScreenSectionTableModels.searchResult(vm)
            return item
        }
        
        return items
        
    }
    
    func subscribeStableStateEvents(state: State){
        
        state.searchFieldVM.textEvents
            .distinctUntilChanged()
            .filter{$0.count > 1}
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self]text in
                self?.actionsSubject.onNext(.search(text))
            })
            .disposed(by: disposeBag)
        
        state.pageRetryVM.tapEvents.subscribe(onNext: { [weak self] in
            self?.actionsSubject.onNext(.retryNewPage)
        })
        .disposed(by: disposeBag)
        
    }
    
    func setEndNewSearchMutation() -> Observable<Mutation>{
        
        Observable.deferred { [weak self] in
            
            let error: Observable<Mutation> = Observable.error(NSError(domain: "", code: 1))
            guard let self = self else {return error}
            guard let state = try? stateSubject.value() else {return error}
            
            return interactor.page(category: .branded, query: state.searchString, offset: 0, limit: state.paginationSettings.limit).asObservable().materialize()
                .map{ event  -> Mutation? in
                    switch event{
                    case .error(let error):
                        return Mutation.didEndSearchFailure(error)
                    case .next(let element):
                        return Mutation.didEndSearchSuccess(element)
                    case .completed:
                        return nil
                    }
                }
                .unwrap()
                .take(1)
                .concat(Observable.just(Mutation.setPaginationRequestInProgress(false)))
            
        }
        
    }
    
    func setFetchNewPageMutation() -> Observable<Mutation>{
        
        Observable.deferred { [weak self] in
            
            let error: Observable<Mutation> = Observable.error(NSError(domain: "", code: 1))
            guard let self = self else {return error}
            guard let state = try? self.stateSubject.value() else {return error}
            guard let offset = state.sections.first?.items.count else {return error}
            
            return self.interactor.page(category: .branded, query: state.searchString, offset: offset, limit: state.paginationSettings.limit).asObservable().materialize()
                .map{ event  -> Mutation? in
                    switch event{
                    case .error(let error):
                        return Mutation.didEndFetchPageFailure(error)
                    case .next(let element):
                        return Mutation.didEndFetchPageSuccess(element)
                    case .completed:
                        return nil
                    }
                }
                .unwrap()
                .take(1)
                .concat(Observable.just(Mutation.setPaginationRequestInProgress(false)))
            
        }
        
    }

}

extension SearchViewModel: SearchViewModelType{

    func inputActions() -> PublishSubject<SearchViewModel.Action>{
        return actionsSubject
    }
    
    func outputState() -> Observable<SearchViewModel.State>{
        return stateSubject
    }
    
    func outputNavigationEvents() -> Observable<SearchNavigationEvents> {
        return navigationEventsSubject.asObservable()
    }

}


