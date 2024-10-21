//
//  FoodElementFoodItemConvertibleAdapter.swift
//  EatingApp
//
//  Created by Александр Савченко on 24.09.2024.
//

import Foundation

struct FoodElementFoodItemConvertibleAdapter: FoodItemVMConvertible{
    
    let adaptee: Food
    
    func foodItemVM() -> FoodItemVM {
        
        var result = FoodItemVM()
        result.id = adaptee.fdcId
        result.brand = adaptee.brandOwner
        result.title = adaptee.description.trimmingCharacters(in: .whitespacesAndNewlines)
        result.energy = adaptee.foodNutrients.first(where: {
            $0.nutrientName == "Energy"
        })?.value
         
        return result
        
    }
    
}
