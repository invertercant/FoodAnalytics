//
//  NetworkErrors.swift
//  iziTravel
//
//  Created by Alexander Savchenko on 14.09.2021.
//

import Foundation
//import FirebaseCrashlytics

enum IZRequestErrors: Error{
    
    case buildRequestError
    case parseError(String)
    case unknownError
    case unauthorized
    case maxAttemptsExceeded
    case connectionOffline
    case requestTimeout
    case serverErrorMessage(USDAServerErrorResponseModel)
    case serverError400(USDAServerError400)
    case custom(String)
    
    var uiTitle: String{
        var result: String = ""
        switch self{
        case .buildRequestError:
            result = "Build request error"
        case .custom:
            result = "Error"
        case .unknownError:
            result = "Unknown error"
        case .connectionOffline:
            result = "Connection offline"
        case .maxAttemptsExceeded:
            result = "Max Attempt exceeded"
        case .serverErrorMessage, .serverError400:
            result = "Server Error"
        case .parseError:
            result = "Decode error"
        case .unauthorized:
            result = "Unauthorized"
        case .requestTimeout:
            result = "Request timeout"
        }
        return result
    }
    
    var uiDescription: String{
        var result: String = ""
        switch self{
        case .parseError(let value):
            result = value
        case .serverErrorMessage(let value):
            var errorStrings: [String] = []
            errorStrings.append(value.error.code)
            errorStrings.append(value.error.message)
            result = errorStrings.joined(separator: " ")
        case .serverError400(let value):
            result = value.message
        case .custom(let value):
            result = value
        default:
            result = ""
        }
        return result
    }
    
}

class NetworkErrorsMapper{
    
    let error: Error
    
    init(error: Error){
        self.error = error
    }
    
    func mapErorrs() -> IZRequestErrors{

        let nsError = (error as NSError)
        if nsError.domain == "NSURLErrorDomain" && nsError.code == -1009{
            return IZRequestErrors.connectionOffline
        }
        else if nsError.domain == "NSURLErrorDomain" && nsError.code == -1001{
            return IZRequestErrors.requestTimeout
        }
        else if let decodingError = nsError as? DecodingError{
            //Crashlytics.crashlytics().record(error: decodingError)
            var description:String = ""
            switch decodingError {
            case .dataCorrupted(let context), .keyNotFound(_, let context), .typeMismatch(_, let context), .valueNotFound(_, let context):
                description = context.debugDescription
            @unknown default:
                print("unknown decoding error")
            }
            return IZRequestErrors.parseError(description)
        }
        else if let error = nsError as? IZRequestErrors{
            return error
        }
        else{
            return IZRequestErrors.unknownError
        }

    }
    
}
