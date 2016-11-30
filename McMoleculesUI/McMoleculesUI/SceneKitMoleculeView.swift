//
//  MoleculeView.swift
//  McMoleculesUI
//
//  Created by Matt Houser on 1/4/16.
//  Copyright © 2016 Matt Houser. All rights reserved.
//

import Cocoa
import SceneKit
import McMoleculesModel

open class SceneKitMoleculeView: SCNView {
    fileprivate var mol : MoleculeFragment? = nil
    open var moleculeFragment : MoleculeFragment?
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
