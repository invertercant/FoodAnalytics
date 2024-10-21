//
//  SearchDataSource.swift
//  EatingApp
//
//  Created by Александр Савченко on 24.09.2024.
//

import Foundation
import Combine

struct SearchRequestModel: Codable {
    var query: String = ""
    var dataType: [String] = []
    var pageSize: Int = 0
    var pageNumber: Int = 0
//    let sortBy: String
//    let sortOrder: String
//    let brandOwner: String
//    let tradeChannel: [String]
//    let startDate: String
//    let endDate: String

}

protocol SearchDataSourceType{
    func search(requestModel: SearchRequestModel) -> AnyPublisher<FoodSearchResult, IZRequestErrors>
}

struct SearchRemoteDataSource: SearchDataSourceType{
    
    typealias Response = FoodSearchResult
    typealias Error = IZRequestErrors
    
    var session: URLSession
    var environment: NetworkEnvironment
    
    func search(requestModel: SearchRequestModel) -> AnyPublisher<FoodSearchResult, IZRequestErrors> {
        var result: AnyPublisher<Response, Error> = Fail<Response, Error>(error: IZRequestErrors.buildRequestError).eraseToAnyPublisher()
        
        var urlRequestComponents = URLRequestComponents(
            environment: environment,
            recourseHash: USDAResources.search.hashValue,
            method: .post
        )
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "api_key", value: "sJdhNNbCzxXnfPhUcN50cSkOaxt8SKYX8yhTZjOF"))
        urlRequestComponents.queryItems = queryItems
        
        urlRequestComponents.headers["Content-Type"] = "application/json"
        
        guard var request = try? urlRequestComponents.asURLRequest() else{ return result }
        request.httpBody = try? JSONEncoder().encode(requestModel)
        let curl = convertURLRequestToCurlCommand(request)
        print(curl)
        
        result = session.dataTaskPublisher(for: request).decodeAPIResponse()
        
        return result
    }
    
    
}
