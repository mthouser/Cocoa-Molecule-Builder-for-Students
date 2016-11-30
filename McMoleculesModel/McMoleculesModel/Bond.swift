//
//  Bond.swift
//  molecule_model
//
//  Created by Matt Houser on 12/16/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Foundation

open class Bond : Hashable {
    
    public enum BondType {
        case single
        case double
        case triple
        case hybrid
    }
    
    open var atoms: (Atom, Atom) {
        get { return _atoms }
    }
    
    let _atoms: (Atom, Atom)
    open let type: Bond.BondType
    
    init(fromAtom atom1: Atom, andAtom atom2: Atom, andBondType type: BondType) {
        self._atoms = (atom1, atom2)
        self.type = type
    }
    init(_ bond: Bond) {
        self._atoms = bond.atoms
        self.type = bond.type
    }
    
    open var hashValue: Int {
        //todo : think of better hash value
        return (atoms.0.hashValue & atoms.1.hashValue).hashValue
    }
    
    static func does(bond: Bond, containAtom atom: Atom) -> Bool {
        return (atom === bond.atoms.0 || atom === bond.atoms.1)     }
    
    static func does(bond: Bond, containElement element: Element) -> Bool {
        return (bond.atoms.0.element == element || bond.atoms.1.element == element)
    }
    
    static func replace(_ atom: Atom, withAtom: Atom, inBond: Bond) -> Bond {
        switch inBond.atoms {
        case (atom, let atom2): return Bond(fromAtom: withAtom, andAtom: atom2 , andBondType: inBond.type)
        case (let atom2, atom) : return Bond(fromAtom: atom2, andAtom: withAtom, andBondType: inBond.type)
        default: return inBond
        }
    }
    
    //Instance method for syntax conciseness
    open func contains(_ atom: Atom) -> Bool {
        return Bond.does(bond: self, containAtom: atom)
    }
    open func contains(_ element: Element) -> Bool {
        return Bond.does(bond: self, containElement: element)
    }
    open func otherAtom(_ atom: Atom) -> Atom {
        if (self.atoms.0 == atom) { return self.atoms.1 }
        else { return self.atoms.0 }
    }
}

public func ==(lhs: Bond , rhs: Bond) -> Bool {
    if (lhs.type == rhs.type) {
        return (lhs.contains(rhs.atoms.0) && lhs.contains(rhs.atoms.1))
    } else { return false }
}
