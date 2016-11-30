//
//  MoleculeFragment.swift
//  MoleculeFragment_model
//
//  Created by Matt Houser on 12/16/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Foundation

open class MoleculeFragment {
    open let bonds: Set<Bond>
    
    public init() {
        self.bonds = []
    }
    
    init(_ fromBonds: [Bond]) {
        self.bonds = Set(fromBonds)
    }
    
    init(_ fromBonds: Set<Bond>) {
        self.bonds = fromBonds
    }
    
    open var atoms : Set<Atom> {
        let bonds = self.bonds
        return bonds.reduce(Set<Atom>()) {
            (set: Set<Atom>, bond: Bond) -> Set<Atom> in
            return set.union([bond.atoms.0, bond.atoms.1])
        }
    }
    open func add(_ bond: Bond) -> MoleculeFragment {
        return MoleculeFragment(self.bonds.union([bond]))
    }
    open func replaceAtom(_ atom: Atom, withAtom: Atom) -> MoleculeFragment {
        let bondsToReplace = self.bonds.filter({$0.contains(atom)})
        let bondsToKeep = self.bonds.subtracting(bondsToReplace)
        let replacementBonds = bondsToReplace.map({
            return Bond.replace(atom, withAtom: withAtom, inBond: $0)})
        return MoleculeFragment(bondsToKeep.union(replacementBonds))
    }
    open func append(_ frag: MoleculeFragment, byReplacingAtom replaceAtom: Atom, withAtom: Atom ) -> MoleculeFragment {
        if (withAtom.element == Element.EMPTY) {
            if let newWithAtom = frag.bonds.filter({$0.contains(withAtom)}).first?.otherAtom(withAtom) {
                let newFrag = MoleculeFragment(frag.bonds.filter({!($0.contains(withAtom))}))
                return append(newFrag, byReplacingAtom: replaceAtom, withAtom: newWithAtom)
            } else { return self }
        } else {
            return self.replaceAtom(replaceAtom, withAtom: withAtom) + frag
        }

    }
}

public func ==(lhs: MoleculeFragment , rhs: MoleculeFragment) -> Bool {
    return lhs.bonds == rhs.bonds
}
public func +(lhs: MoleculeFragment, rhs: MoleculeFragment) -> MoleculeFragment {
    return MoleculeFragment(lhs.bonds.union(rhs.bonds))
}

