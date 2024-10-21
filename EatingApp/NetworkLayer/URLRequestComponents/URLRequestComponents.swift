//
//  URLRequestComponents.swift
//  tmatic
//
//  Created by Александр Савченко on 15.02.2023.
//

import Foundation
import Alamofire

struct URLRequestComponents: URLRequestConvertible{
    
    init(environment: NetworkEnvironment, recourseHash: Int, method: HTTPMethod?) {
        self.environment = environment
        self.resourceHash = recourseHash
        self.method = method ?? .get
    }
    
    var environment: NetworkEnvironment
    var resourceHash : Int
    var path : String { return environment.resourcePaths[self.resourceHash] ?? "" }
    var queryItems: [URLQueryItem] = []
    var method: HTTPMethod = .get
    var urlParams: [String: String] = [:]
    var headers: [String: String] = [:]
    
    func buildPath(originPath: String, urlParameters: [String: String]) -> String{
        
        var result = originPath
        
        urlParameters.forEach { (key: String, value: String) in
            result = result.replacingOccurrences(of: "{" + key + "}", with: value)
        }
        
        return result

    }
    
    func asURLRequest() throws -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = environment.scheme
        urlComponents.host = environment.host
        urlComponents.port = environment.port
        urlComponents.path = environment.baseApiPath + buildPath(originPath: self.path, urlParameters: self.urlParams)
        urlComponents.queryItems = queryItems
        
        let request = try! URLRequest(url: urlComponents.url!, method: method, headers: headers)
        
        return request
        
    }
    
}

extension URLRequest {
    /// Creates an instance with the specified `method`, `urlString` and `headers`.
    ///
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The new `URLRequest` instance.
    public init(url: URLConvertible, method: HTTPMethod, headers: [String: String]? = nil) throws {
        let url = try url.asURL()

        self.init(url: url)

        httpMethod = method.rawValue

        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }

}
