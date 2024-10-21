//
//  Publisher +decodeApiResponse.swift
//  tmatic
//
//  Created by Александр Савченко on 14.09.2022.
//

import Foundation
import Combine
import OSLog

extension Publisher where Output == (data: Data, response: URLResponse) {
    
    func decodeAPIResponse<T: Decodable>() -> AnyPublisher<T, IZRequestErrors>{
        
        return self
            .tryCompactMap{ response -> T? in
                let data = response.data
                var result: T?
                let decoder = JSONDecoder()
                if let value = try? decoder.decode(T.self, from: data){
                    //print("decode success: \(String(describing: response.response.url))")
                    result = value
                } 
                else if let errorMessage = try? decoder.decode(USDAServerErrorResponseModel.self, from: data){
                    throw IZRequestErrors.serverErrorMessage(errorMessage)
                } else if let error = try? decoder.decode(USDAServerError400.self, from: data){
                    throw IZRequestErrors.serverError400(error)
                }
                else{
                    //print("decode error: \(String(describing: response.response.url))")
                    //throw decode error
                    _ = try decoder.decode(T.self, from: data)
                }
                return result
            }
            .mapError({ error in
                NetworkErrorsMapper(error: error).mapErorrs()
            })
            .eraseToAnyPublisher()
        
    }
    
}
