//
//  SearchScreenSection.swift
//  EatingApp
//
//  Created Александр Савченко on 24.09.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxDataSources

struct SearchScreenSection{
    var header: String = ""
    var shouldShowHeader: Bool = false
    var items: [Item] = []
}

extension Array where Element: SectionModelType{
    
    func isEmptyItems() -> Bool{
        return self.flatMap{$0.items}.isEmpty
    }
    
}

extension SearchScreenSection: AnimatableSectionModelType{
    
    typealias Item = SearchScreenSectionTableModels
    typealias Identity = String
    
    var identity: String {
        return header
    }
    
    init(original: SearchScreenSection, items: [SearchScreenSectionTableModels]) {
        self = original
        self.items = items
    }
    
}

extension SearchScreenSection: Equatable{
    
}

extension SearchScreenSectionTableModels: IdentifiableType{
    
    var identity: Int {
        var hasher = Hasher()
        switch self {
        case .searchResult(let vm):
            hasher.combine(vm.id)
        }
        return hasher.finalize()
    }
    
    typealias Identity = Int
    
}

//extension SearchScreenSectionTableModels: Equatable{
//
//}

//extension SearchScreenSectionTableModels: Equatable{
//    
//    static func == (lhs: SearchScreenSectionTableModels, rhs: SearchScreenSectionTableModels) -> Bool {
//        switch (lhs, rhs){
//        case (.searchResult(let lhsData), .searchResult(let rhsData)):
//            return lhsData == rhsData
//        default:
//            return false
//        }
//    }
//    
//}



