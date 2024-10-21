//
//  UIErrors.swift
//  iziTravel
//
//  Created by Alexander Savchenko on 14.09.2021.
//

import Foundation

enum UIErrors{
    
    case serverError
    case internetConnectionLost
    
    func errorText() -> String{
        switch self {
        case .serverError:
            return AppStrings.errorsServerError
        case .internetConnectionLost:
            return "Нет связи. Проверьте интернет соединение"
        }
    }
    
}
