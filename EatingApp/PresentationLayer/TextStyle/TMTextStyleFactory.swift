//
//  TMTextStyleFactory.swift
//  iziTravel
//
//  Created by Alexander Savchenko on 03.11.2021.
//

import Foundation
import UIKit

protocol ITMTextStyleFactory{
    func make(option: TMTextStyleOptions) -> TMTextStyle
}

struct TMTextStyleFactory: ITMTextStyleFactory{
    
    static let shared: TMTextStyleFactory = TMTextStyleFactory()
    
    func make(option: TMTextStyleOptions) -> TMTextStyle {
        var result = TMTextStyle()
        switch option {
        case .header4:
            result = TMTextStyle(kerning: -0.4, fontName: AppFonts.SFProRounded.rawValue, fontSize: 18, lineHeight: 20,
                                 systemFontWeight: UIFont.Weight.medium.rawValue)
        case .body3:
            result = TMTextStyle(kerning: -0.1, fontName: AppFonts.SFProRounded.rawValue, fontSize: 14, lineHeight: 16,
                                 systemFontWeight: UIFont.Weight.regular.rawValue)
        case .body2:
            result = TMTextStyle(kerning: -0.32, fontName: AppFonts.SFProRounded.rawValue, fontSize: 14, lineHeight: 16,
                                 systemFontWeight: UIFont.Weight.regular.rawValue)
        case .body1Semibold:
            result = TMTextStyle(kerning: -0.32, fontName: AppFonts.SFProRounded.rawValue, fontSize: 20, lineHeight: 28,
                                 systemFontWeight: UIFont.Weight.semibold.rawValue)
        }
        return result
    }
    
}
