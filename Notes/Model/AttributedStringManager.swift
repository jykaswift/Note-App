//
//  AttributeManager.swift
//  Notes
//
//  Created by Евгений Борисов on 28.01.2024.
//

import Foundation
import UIKit

struct AttributedStringManager {
    
    /// Creating an attribute dictionary based on clicked buttons in the text formatting menu
    /// - Parameter textAttributes: TextAttributes object
    /// - Returns: Attribute dictionary
    func generateAttributesWith(textAttributes: TextAttributes) -> [NSAttributedString.Key: Any] {
        var attributes = [NSAttributedString.Key: Any]()
        let font = getFontAttribute(textAttributes: textAttributes)
        let underline = getUnderlineAttribute(isUnderline: textAttributes.isUnderline)
        attributes[.font] = font
        attributes[.underlineStyle] = underline
        
        return attributes
    }
    
    
    private func getFontAttribute(textAttributes: TextAttributes) -> UIFont {
        var font = UIFont.systemFont(ofSize: textAttributes.fontSize)
        
        switch (textAttributes.isBold, textAttributes.isItalic) {
        case (true, true):
            font = font.withTraits([.traitBold, .traitItalic])
        case (true, false):
            font = font.withTraits([.traitBold])
        case (false, true):
            font = font.withTraits([.traitItalic])
        default:
            break
        }
        
        return font
    }
    
    private func getUnderlineAttribute(isUnderline: Bool) -> Int? {

        if isUnderline {
            return NSUnderlineStyle.single.rawValue
        } else {
            return nil
        }
    }
    
    /// Convert textview typing attributes dictionary to TextAttributes
    /// This is necessary to update the appearance of the text formatting menu
    /// - Parameter typingAttributes: [NSAttributedString.Key: Any] value, textview typing attributes
    /// - Returns: TextAttributes Object
    func getTextAttributes(typingAttributes: [NSAttributedString.Key: Any]) -> TextAttributes {
        var textAttributes = TextAttributes()
        
        guard let font = typingAttributes[.font] as? UIFont else {
           return TextAttributes()
        }
        
        switch font.fontName {
        case ".SFUI-Semibold":
            textAttributes.isBold = true
        case ".SFUI-SemiboldItalic":
            textAttributes.isBold = true
            textAttributes.isItalic = true
        case ".SFUI-RegularItalic":
            textAttributes.isItalic = true
        default:
            break
        }
        
        if typingAttributes[.underlineStyle] != nil {
            textAttributes.isUnderline = true
        }
        
        textAttributes.fontSize = font.pointSize
        
        return textAttributes
    }
    
   
}

// MARK: Font traits
extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
