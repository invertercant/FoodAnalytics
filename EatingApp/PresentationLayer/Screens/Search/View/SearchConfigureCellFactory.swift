//
//  ISearchAnimatedDSFactory.swift
//  EatingApp
//
//  Created by Александр Савченко on 24.09.2024.
//

import Foundation
import RxDataSources

protocol ConfigureCellFactory{
    associatedtype T: SectionModelType
    func makeConfigureCellClosure() -> TableViewSectionedDataSource<T>.ConfigureCell
}

struct SearchConfigureCellFactory: ConfigureCellFactory{
    
    typealias T = SearchScreenSection
    
    func makeConfigureCellClosure() -> TableViewSectionedDataSource<T>.ConfigureCell {
        let result = { (ds: TableViewSectionedDataSource<T>, tv: UITableView, ip: IndexPath, item: T.Item) -> UITableViewCell in
            var result: UITableViewCell?
            switch item{
            case .searchResult(let vm):
                let cell = SearchResultCell()
                cell.setup(vm: vm)
                cell.selectionStyle = .none
                result = cell
            }
            return result ?? UITableViewCell()
        }
        return result
    }
    
}


