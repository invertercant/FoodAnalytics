//
//  TextStyleTextAttributesConvertibleAdapter.swift
//  EatingApp
//
//  Created by Александр Савченко on 09.10.2024.
//
import UIKit

protocol TextAttributesConvertible{
    func makeAttributes() -> [NSAttributedString.Key: Any]
}

struct TextStyleTextAttributesConvertibleAdapter: TextAttributesConvertible {
    
    let textStyle: TMTextStyle
    
    func makeAttributes() -> [NSAttributedString.Key: Any] {
        var result: [NSAttributedString.Key: Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineSpacing = textStyle.lineHeight - textStyle.font.lineHeight
        result[.font] = textStyle.font
        result[.kern] = textStyle.kerning
        result[.paragraphStyle] = paragraphStyle
        return result
    }
  
}
