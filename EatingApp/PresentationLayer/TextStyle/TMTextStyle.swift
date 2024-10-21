//
//  TMTextStyle.swift
//  iziTravel
//
//  Created by Alexander Savchenko on 03.11.2021.
//

import Foundation
import UIKit

enum AppFonts: String{
    case SFProRounded = "SF Pro Rounded"
}

struct TMTextStyle{
    var kerning: CGFloat = 0
    var fontName: String = ""
    var fontSize: CGFloat = 14
    var lineHeight: CGFloat = 14
    var systemFontWeight: CGFloat = 0
    var font: UIFont{
        if fontName == "SF Pro Rounded"{
            return FontKit.roundedFont(ofSize: fontSize, weight: UIFont.Weight(systemFontWeight))
        } else{
            return UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    static func make(option: TMTextStyleOptions) -> TMTextStyle{
        TMTextStyleFactory.shared.make(option: option)
    }
}

class FontKit {
    
    static func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let font: UIFont
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: fontSize)
        } else {
            font = systemFont
        }
        
        return font
    }
    
}
