//
//  USDAServerErrorResponseModel.swift
//  EatingApp
//
//  Created by Александр Савченко on 24.09.2024.
//

import Foundation

struct USDAServerErrorResponseModel: Codable {
    let error: ServerErrorModel
}

// MARK: - Error
struct ServerErrorModel: Codable {
    let code: String
    let message: String
}

struct USDAServerError400: Codable {
    let timestamp: String
    let status: Int
    let error: String
    let message: String
    let path: String
}
