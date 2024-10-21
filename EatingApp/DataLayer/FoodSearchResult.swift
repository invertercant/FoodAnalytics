//
//  FoodList.swift
//  EatingApp
//
//  Created by Александр Савченко on 24.09.2024.
//

import Foundation

struct FoodSearchResult: Codable {
    let totalHits: Int
    let currentPage: Int
    let totalPages: Int
    let pageList: [Int]
    //let foodSearchCriteria: FoodSearchCriteria
    let foods: [Food]
    //let aggregations: Aggregations
}

// MARK: - Aggregations
struct Aggregations: Codable {
    let dataType: DataType
    let nutrients: Nutrients
}

// MARK: - DataType
struct DataType: Codable {
    let branded: Int
    let surveyFNDDS: Int
    let srLegacy: Int
    let foundation: Int
    let experimental: Int
}

// MARK: - Nutrients
struct Nutrients: Codable {
}

// MARK: - FoodSearchCriteria
struct FoodSearchCriteria: Codable {
    let dataType: [DataTypeElement]
    let query: String
    let generalSearchInput: String
    let pageNumber: Int
    let numberOfResultsPerPage: Int
    let pageSize: Int
    let requireAllWords: Bool
    let foodTypes: [DataTypeElement]
}

enum DataTypeElement: String, Codable {
    case branded = "Branded"
    case foundation = "Foundation"
}

// MARK: - Food
struct Food: Codable {
    let fdcId: Int
    let description: String
    let dataType: DataTypeElement
//    let gtinUpc: String?
//    let publishedDate: String
    let brandOwner: String?
//    let ingredients: String?
//    let marketCountry: MarketCountry?
//    let foodCategory: String
//    let modifiedDate: String?
//    let dataSource: DataSource?
//    let servingSizeUnit: ServingSizeUnit?
//    let servingSize: Double?
//    let householdServingFullText: String?
//    let tradeChannels: [TradeChannel]?
//    let allHighlightFields: String
//    let score: Double
    let foodNutrients: [FoodNutrient]
//    let foodAttributes: [FoodAttribute]
//    let foodAttributeTypes: [FoodAttributeType]
//    let brandName: String?
//    let packageWeight: String?
//    let subbrandName: String?
//    let shortDescription: String?
//    let commonNames: String?
//    let additionalDescriptions: String?
//    let ndbNumber: Int?
//    let mostRecentAcquisitionDate: String?
}

enum DataSource: String, Codable {
    case li = "LI"
}

// MARK: - FoodAttributeType
struct FoodAttributeType: Codable {
    let name: String
    let description: String
    let id: Int
    let foodAttributes: [FoodAttribute]
}

// MARK: - FoodAttribute
struct FoodAttribute: Codable {
    let value: String
    let name: String
    let id: Int
}

// MARK: - FoodNutrient
struct FoodNutrient: Codable {
    let nutrientId: Int?
    let nutrientName: String?
    let nutrientNumber: String?
    let unitName: String?
    let derivationCode: String?
    let derivationDescription: String?
    let derivationId: Int?
    let value: Float?
//    let foodNutrientSourceId: Int?
//    let foodNutrientSourceCode: String?
//    let foodNutrientSourceDescription: String?
//    let rank: Int?
//    let indentLevel: Int?
//    let foodNutrientId: Int?
//    let percentDailyValue: Int?
//    let dataPoints: Int?
//    let min: Double?
//    let max: Double?
//    let median: Double?
}

enum MarketCountry: String, Codable {
    case unitedStates = "United States"
}

enum ServingSizeUnit: String, Codable {
    case g = "g"
    case grm = "GRM"
    case ml = "ml"
}

enum TradeChannel: String, Codable {
    case noTradeChannel = "NO_TRADE_CHANNEL"
}
