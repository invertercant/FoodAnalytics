//
//  SearchFactory.swift
//  EatingApp
//
//  Created Александр Савченко on 24.09.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift

protocol ISearchFactory{
    func makeSearch(coordinator: SearchCoordinatable) -> UIViewController
}

struct SearchFactory: ISearchFactory{
    func makeSearch(coordinator: SearchCoordinatable) -> UIViewController{
        
        let interactor: SearchInteractorType = SearchInteractor(
            dataSource: SearchRemoteDataSource(session: URLSession.shared, environment: USDAEnvironment())
        )
        let viewModel = SearchViewModel(interactor: interactor)
        let view = SearchVC(viewModel: viewModel)
        
        viewModel.outputNavigationEvents()
            .bind(to: coordinator.navigationEventsBinder)
            .disposed(by: viewModel.disposeBag)
        
        return view
    }
}
