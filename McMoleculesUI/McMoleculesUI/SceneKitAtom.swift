//
//  SceneKitAtomRenderer.swift
//  McMoleculesUI
//
//  Created by Matt Houser on 1/1/16.
//  Copyright © 2016 Matt Houser. All rights reserved.
//

import Foundation
import SceneKit
import McMoleculesModel

open class AtomNode: SCNNode {
    open let atom: Atom
    
    public init(atom: Atom, geo: SCNGeometry) {
        self.atom = atom
        super.init()
        self.geometry = geo
    }
    public init(atom: Atom) {
        self.atom = atom
        super.init()
    }
    public required init?(coder decoder: NSCoder) {
        self.atom = Atom(fromElement: Element.EMPTY, andChemVector3: ChemVector3Make(0,0,0))
        super.init(coder: decoder)
    }
}
