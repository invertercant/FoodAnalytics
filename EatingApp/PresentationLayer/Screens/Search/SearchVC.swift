//
//  SearchVC.swift
//  EatingApp
//
//  Created Александр Савченко on 24.09.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import NSObject_Rx
import RxGesture

class SearchVC: UIViewController{

	var viewModel: SearchViewModelType
    var tvDataSource: RxTableViewSectionedAnimatedDataSource<SearchScreenSection>!
    var tableFooterBehavior: PaginationFooterBehavior?
    //var tableLoadingView = TableLoadingView()
    
    lazy var tableView: UITableView = {
        let result = UITableView(frame: .zero, style: .grouped)
        result.delegate = self
        result.separatorStyle = .none
        result.backgroundColor = AppColors.mainBackground
        result.rowHeight = UITableView.automaticDimension
        result.tableHeaderView = UIView()
        result.register(cellType: SearchResultCell.self)
        return result
    }()
    
    let searchField = SearchField()
    
	override func viewDidLoad() {
        super.viewDidLoad()
        title = AppStrings.mainTitle
        view.backgroundColor = AppColors.mainBackground
        initLayout()
        setBehavior()
        viewModel.inputActions().onNext(.viewDidLoad)
        bindData()
    }
    
    func initLayout(){
        
        view.addSubview(searchField)
        view.addSubview(tableView)
        
        searchField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        tableView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(searchField.snp.bottom).offset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        UIView.exerciseAmbiguity(tableView)
//    }
    
    func bindData(){
        
        let configurationCellClosure = SearchConfigureCellFactory().makeConfigureCellClosure()
        tvDataSource = RxTableViewSectionedAnimatedDataSource<SearchScreenSection>(configureCell: configurationCellClosure)
        
        tvDataSource.decideViewTransition = { (ds, tv, changeSet) in
            if tv.visibleCells.count == 0{
                return RxDataSources.ViewTransition.reload
            } else{
                return RxDataSources.ViewTransition.animated
            }
        }
        
        tvDataSource.animationConfiguration = AnimationConfiguration(
            insertAnimation: .fade,
            reloadAnimation: .fade,
            deleteAnimation: .fade
        )
        
        viewModel.outputState().map{$0.sections}.distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: tvDataSource))
            .disposed(by: rx.disposeBag)
        
        viewModel.outputState().map{$0.searchFieldVM}.take(1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { vm in
                self.searchField.vm = vm
            })
            .disposed(by: rx.disposeBag)
        
        //tableFooter
        self.tableFooterBehavior = PaginationFooterBehavior(
            tableView: self.tableView,
            controlSequence: viewModel.outputState().map{$0.footerOptions},
            supportSequence: viewModel.outputState().map{$0.pageRetryVM}
        )
        
        //tableLoading
        let tableLoadingSequence: Observable<(Bool, Bool, Bool)> = viewModel.outputState().map{($0.isLoading, $0.sections.isEmptyItems(), $0.error != nil)}
        
        tableLoadingSequence.distinctUntilChanged{
            $0.0 == $1.0 && $0.1 == $1.1 && $0.2 == $1.2
        }
        //tableLoadingSequence
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] (isLoading: Bool, isEmptyItems: Bool, hasError: Bool) in
            guard let self = self else {return}
            if hasError && !isLoading && isEmptyItems || hasError && isLoading && isEmptyItems{
                let child = RetryVC()
                self.addChild(child)
                self.view.addSubview(child.view)
                child.view.frame = self.tableView.frame
                child.didMove(toParent: self)
            } else{
                guard let child = self.children.first(where: {$0 is RetryVC}) else {return}
                child.willMove(toParent: nil)
                UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    child.view.removeFromSuperview()
                },
                completion: nil
                )
                child.removeFromParent()
            }
        })
        .disposed(by: rx.disposeBag)
        
        
    }
    
    func setBehavior(){
        
        view.rx.tapGesture { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        }.subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).disposed(by: rx.disposeBag)
        
    }
    
    init(viewModel: SearchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.inputActions().onNext(.elementWillDisplay(index: indexPath.row))
    }
    
}

