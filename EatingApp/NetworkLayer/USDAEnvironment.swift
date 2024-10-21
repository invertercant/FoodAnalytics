//
//  USDAEnvironment.swift
//  EatingApp
//
//  Created by Александр Савченко on 24.09.2024.
//

import Foundation

struct USDAEnvironment: NetworkEnvironment{
    
    var scheme = "https"
    var host = "api.nal.usda.gov"
    var port: Int?
    var baseApiPath: String = "/fdc/v1/"
    var resourcePaths: [Int: String] = {
        var result: [Int: String] = [:]
        result[USDAResources.search.hashValue] = "foods/search"
        return result
    }()
    
}

enum USDAResources: Int{
    case search
}

extension USDAResources: Hashable{
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
        hasher.combine(String(describing: type(of: self)))
    }
    
}

