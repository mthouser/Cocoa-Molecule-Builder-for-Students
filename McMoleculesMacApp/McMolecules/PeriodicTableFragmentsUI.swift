//
//  PeriodicTableFragmentsUI.swift
//  McMolecules
//
//  Created by Matt Houser on 12/26/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Cocoa
import McMoleculesModel
import SceneKit
import McMoleculesUI


class PeriodicTableFragmentsUI: NSViewController, PeriodicTableSelectionListener {
    @IBOutlet weak var fragmentsView: NSView!
    
    @IBOutlet weak var frag1View: SCNView!
    @IBOutlet weak var frag2View: SCNView!
    @IBOutlet weak var frag3View: SCNView!
    @IBOutlet weak var frag4View: SCNView!

    @IBOutlet weak var frag1Button: NSButton!
    @IBOutlet weak var frag2Button: NSButton!
    @IBOutlet weak var frag3Button: NSButton!
    @IBOutlet weak var frag4Button: NSButton!

    @IBAction func sp3Clicked(_ sender: AnyObject) {
        print("sp3 fragment clicked")
    }
    
    @IBAction func sp2Clicked(_ sender: AnyObject) {
        print("sp2 fragment clicked")
    }
    
    @IBAction func sp_aClicked(_ sender: AnyObject) {
        print("sp a fragment clicked")
    }
    
    @IBAction func sp_bClicked(_ sender: AnyObject) {
        print("sp b fragment clicked")
    }
    
    
    func fragClicked(_ sender: AnyObject) {
        print("sp3 clicked")
    }
    
    func elementSelected(_ e: Element) {
        
        @discardableResult func buildScene(_ view: SCNView, geometry: ChemGeometry) -> SCNScene {
            let scene = SceneKitRenderer.renderMoleculeAsScene(
                MoleculeFragmentFactory.create(geometry, fromElement: e, withFillElement: Element.EMPTY, andBondTypes: Array(repeating: Bond.BondType.single, count: geometry.rawValue)).0)
            SceneKitRenderer.startRotating(scene.rootNode.childNodes[0], r: SCNVector4Make(0.1, 1.0, 0.0, 0.0))
            view.scene = scene
            view.backgroundColor = NSColor.clear
            view.isHidden = false
            return scene
        }
        
        print("Element selected: " + e.rawValue)
        fragmentsView.isHidden = false
        frag1Button.isHidden = false
        frag1Button.title = "sp3"
        buildScene(frag1View, geometry: ChemGeometry.TETRAHEDRAL)
        frag2Button.isHidden = false
        frag2Button.title = "sp2"
        buildScene(frag2View, geometry: ChemGeometry.TRIGONALPLANAR)
        frag3Button.isHidden = false
        frag3Button.title = "sp"
        buildScene(frag3View, geometry: ChemGeometry.LINEAR)
        frag4Button.isHidden = false
        frag4Button.title = "sp"
        buildScene(frag4View, geometry: ChemGeometry.LINEAR)        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
