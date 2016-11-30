//
//  AppDelegate.swift
//  McMolecules
//
//  Created by Matt Houser on 12/26/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Cocoa
import SceneKit
import McMoleculesUI
import McMoleculesModel


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var fragmentsView: SCNView!
    @IBOutlet weak var periodicTableView: SCNView!
    @IBOutlet weak var periodicElementsDelegate: PeriodicTableElementsUI!
    @IBOutlet weak var periodicFragmentsDelegate: PeriodicTableFragmentsUI!
    @IBOutlet weak var moleculeView: SceneKitMoleculeView!
    
    @IBAction func moleculeClick(_ sender: NSClickGestureRecognizer) {
        let location = sender.location(in: moleculeView)
        let hits = moleculeView.hitTest(location, options: [SCNHitTestOption.ignoreHiddenNodes: "NO"])
        if hits.count > 0 {
            let result = hits.first
            let node = result!.node
            if (node is AtomNode) {
                let atomNode = node as! AtomNode
                if (atomNode.atom.element == Element.EMPTY) {
                    if let molView = sender.view as? SceneKitMoleculeView {
                        if let mol = molView.moleculeFragment {
                            let newMol = mol.replaceAtom(atomNode.atom, withAtom: Atom(fromElement: Element.HYDROGEN, andChemVector3: atomNode.atom.location))
                            molView.moleculeFragment = newMol
                            molView.scene = SceneKitRenderer.renderMoleculeAsScene(newMol)
                        }
                    }
                    print("empty atom clicked")
                }
            }
        }

    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("application starting... here we go!")
        
        let methane1Tuple = MoleculeFragmentFactory.create(ChemGeometry.TETRAHEDRAL, fromElement: Element.CARBON, withFillElement:Element.EMPTY, andBondTypes: Array(repeating: Bond.BondType.single, count: 4))
        let methane1 = methane1Tuple.0
        let empty1 = methane1Tuple.1
        let carbon1 = methane1.bonds.filter({$0.contains(empty1)}).first!.otherAtom(empty1)
        let targetVector = carbon1.location - empty1.location

        let methane2Tuple =  MoleculeFragmentFactory.create(ChemGeometry.TETRAHEDRAL, fromElement: Element.OXYGEN, alignV: ChemVector3Make(0,1,0), toV: targetVector, offsetBy: empty1.location, withFillElement:Element.EMPTY, andBondTypes: Array(repeating: Bond.BondType.single, count: 4))
        let methane2 =  methane2Tuple.0
        let connectToAtom = methane2Tuple.1
        let empty2 = connectToAtom
        
        let ethane = methane1.append(methane2, byReplacingAtom: empty1, withAtom: empty2)
        print("atom count = \(ethane.atoms.count)")
        
        moleculeView.moleculeFragment = ethane
        moleculeView.scene = SceneKitRenderer.renderMoleculeAsScene(ethane)
        periodicElementsDelegate.registerListener(periodicFragmentsDelegate)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
