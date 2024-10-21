//
//  SearchScreenSectionTableModels.swift
//  EatingApp
//
//  Created Александр Савченко on 24.09.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

enum SearchScreenSectionTableModels{
    case searchResult(FoodItemVM)
}

extension SearchScreenSectionTableModels: Equatable{
    
}

struct SearchScreenExampleVM: Equatable{
    var id: Int
    var content: String
}



