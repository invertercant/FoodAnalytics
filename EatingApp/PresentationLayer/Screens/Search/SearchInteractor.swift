//
//  SearchInteractor.swift
//  EatingApp
//
//  Created Александр Савченко on 24.09.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import Combine

protocol SearchInteractorType{
    func page(category: SearchCategory?, query: String, offset: Int, limit: Int) -> AnyPublisher<FoodSearchResult, IZRequestErrors>
}

class SearchInteractor: SearchInteractorType{
    
    let dataSource: SearchDataSourceType
    
    init(dataSource: SearchDataSourceType) {
        self.dataSource = dataSource
    }
    
    func page(category: SearchCategory?, query: String, offset: Int, limit: Int) -> AnyPublisher<FoodSearchResult, IZRequestErrors>{
        var requestModel = SearchRequestModel()
        requestModel.query = query
        if let category = category{
            requestModel.dataType = [category.rawValue]
        }
        requestModel.pageSize = limit
        //нумерация страниц начинается с 1. с 0 и 1 одинаковые выдачи
        requestModel.pageNumber = offset/limit + 1
        return dataSource.search(requestModel: requestModel).eraseToAnyPublisher()
    }
    
}








