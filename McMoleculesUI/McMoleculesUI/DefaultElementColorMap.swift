//
//  ElementColorMapper.swift
//  McMoleculesUI
//
//  Created by Matt Houser on 1/1/16.
//  Copyright © 2016 Matt Houser. All rights reserved.
//

import Foundation
import McMoleculesModel
public typealias ChemColor = NSColor

open class DefaultElementColorMap {
    open static func getElementColor(_ element : Element) -> ChemColor {
        let colorMap: [Element: ChemColor] = [
            Element.CARBON: ChemColor.darkGray,
            Element.HYDROGEN: ChemColor.white,
            Element.CHLORINE: ChemColor.blue,
            Element.EMPTY: ChemColor.yellow]
        let color : ChemColor? = colorMap[element]
        switch (color) {
        case .some(let c): return c
        default: return ChemColor.red
        }
    }
}
