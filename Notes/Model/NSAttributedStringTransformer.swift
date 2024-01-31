//
//  NSAttributedStringTransformer.swift
//  Notes
//
//  Created by Евгений Борисов on 29.01.2024.
//

import Foundation

class NSAttributedStringTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let attributedString = value as? NSAttributedString else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: attributedString, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
        
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            let data = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: data)
            return data
        } catch {
            return nil
        }
    }
}
