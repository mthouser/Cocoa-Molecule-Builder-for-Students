//
//  Atom.swift
//  molecule_model
//
//  Created by Matt Houser on 12/15/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Foundation

open class Atom : NSObject {
    open let element: Element
    open let location : ChemVector3

    public init(fromElement element: Element, andChemVector3 point: ChemVector3) {
        self.location = point
        self.element = element
    }
    
    init (_ fromElement: Element) {
        self.element = fromElement
        self.location = ChemVector3Make(0,0,0)
    }
    
    init (_ fromAtom: Atom) {
        self.element = fromAtom.element
        self.location = fromAtom.location
    }
}
public func ==(lhs: Atom , rhs: Atom) -> Bool {
    return lhs === rhs
}
