//
//  SearchCoordinator.swift
//  EatingApp
//
//  Created Александр Савченко on 24.09.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol SearchCoordinatable: AnyObject{
    func handle(event: SearchNavigationEvents)
}

extension SearchCoordinatable{
    
    var navigationEventsBinder: Binder<SearchNavigationEvents>{
        return Binder(self) { (target, navigationEvent) in
            target.handle(event: navigationEvent)
        }
    }
    
}

class SearchCoordinator: NavigationCoordinator{
    
    override func start() {
        let vc = SearchFactory().makeSearch(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
}

extension SearchCoordinator: SearchCoordinatable{
    
    func handle(event: SearchNavigationEvents) {
        switch event {

    	}
    }
    
}



