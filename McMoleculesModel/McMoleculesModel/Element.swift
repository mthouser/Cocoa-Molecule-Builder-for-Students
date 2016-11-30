//
//  Element.swift
//  molecule_model
//
//  Created by Matt Houser on 12/15/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Foundation

//Enumeration of the valid elements supported by this library
public enum Element : String {
    case HYDROGEN = "H"
    case CARBON = "C"
    case NITROGEN = "N"
    case OXYGEN = "O"
    case FLUORINE = "F"
    case SILICON = "Si"
    case PHOSPHORUS = "P"
    case SULFUR = "S"
    case CHLORINE = "Cl"
    case BROMINE = "Br"
    case IODINE = "I"
    case EMPTY = ""
    
    public struct ElementInfo {
        let number: Int     //atomic number
        let symbol: String  //element symbol
        
        
        //Each enum must have a corresponding entry in atomicNumbers
        static let atomicNumbers: [Element: Int] = [
            .HYDROGEN: 1, .CARBON: 6, .NITROGEN: 7,
            .OXYGEN: 8, .FLUORINE: 9, .SILICON: 14,
            .PHOSPHORUS: 15, .SULFUR: 16, .CHLORINE: 17,
            .BROMINE: 35, .IODINE: 53, .EMPTY: 0]
        
        fileprivate init(forElement element: Element) {
            self.number = ElementInfo.atomicNumbers[element]!
            self.symbol = element.rawValue
        }
    }
    
    static func getInfo(forElement element: Element) -> ElementInfo {
        return ElementInfo(forElement: element)
    }
    static func get(fromSymbol symbol: String) -> Element? {
        return Element(rawValue: symbol)
    }
    
    //Instance helper function for syntax conciseness
    func getInfo() -> ElementInfo {
        return Element.getInfo(forElement: self)
    }
}
