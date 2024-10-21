//
//  NetworkEnvironment.swift
//  iziTravel
//
//  Created by Alexander Savchenko on 22.09.2021.
//

import Foundation

protocol NetworkEnvironment{
    
    var scheme: String {get}
    var host : String {get}
    var port: Int? {get}
    var baseApiPath: String {get}
    var resourcePaths: [Int: String] {get}
    
    func baseURL() -> String
    
}

extension NetworkEnvironment{
    
    func baseURL() -> String{
        
        let template: String = "{scheme}://{host}{port}"
        var result = template.replacingOccurrences(of: "{scheme}", with: scheme)
        result = result.replacingOccurrences(of: "{host}", with: host)
        var portString: String = ""
        if let port = port{
            portString = ":\(String(port))"
        }
        result = result.replacingOccurrences(of: "{port}", with: portString)
        
        return result
        
    }
    
}
