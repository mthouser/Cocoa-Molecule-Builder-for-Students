import Cocoa
import McMoleculesModel
import McMoleculesUI
import SceneKit
import XCPlayground

let methane = MoleculeFragmentFactory.create(ChemGeometry.TETRAHEDRAL, fromElement: Element.CARBON, withFillElement: Element.HYDROGEN, andBondTypes: Array(count: 4, repeatedValue: Bond.BondType.SINGLE)).0
let sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
let scene = SceneKitRenderer.renderMoleculeAsScene(methane)
//sceneView.scene = scene
//XCPlaygroundPage.currentPage.liveView = sceneView
