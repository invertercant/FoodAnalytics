//
//  SearchContract.swift
//  EatingApp
//
//  Created Александр Савченко on 24.09.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

enum SearchTableModels{

}

enum SearchNavigationEvents{

}

protocol SearchViewModelType {
    func inputActions() -> PublishSubject<SearchViewModel.Action>
    func outputState() -> Observable<SearchViewModel.State>
    func outputNavigationEvents() -> Observable<SearchNavigationEvents>
}






