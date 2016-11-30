//
//  SceneKitRender.swift
//  McMoleculesRender
//
//  Created by Matt Houser on 12/21/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Foundation
import SceneKit
import McMoleculesModel

open class SceneKitRenderer {
    //The SceneKitRenderer class is a utility to help construct a closure that
    //takes a MoleculeFragment as input, and returns a SceneKit Node as output.
    //These
    open static func createNodeRenderClosure(
        _ atomNodeRenderer: @escaping (_: Atom)->SCNNode = SceneKitBallAndStickRender.renderAtomAsNode,
        bondNodeRenderer: @escaping (_: Bond)->SCNNode = SceneKitBallAndStickRender.renderBondAsNode,
        cameraNodeGenerator: ()->[SCNNode] = {return []},
        lightingNodesRenderer: ()->[SCNNode] = {return []}) -> (MoleculeFragment)->SCNNode {

        //Generate and return the closure that renders molecules
        let renderer = {(mol: MoleculeFragment) -> SCNNode in
            func reduceToNode(_ nodes: [SCNNode]) -> SCNNode {
                return nodes.reduce(SCNNode()) { (baseNode: SCNNode, thisNode: SCNNode) -> SCNNode in
                    baseNode.addChildNode(thisNode)
                    return baseNode
                }
            }
            let moleculeNode = SCNNode()
            moleculeNode.addChildNode(reduceToNode(mol.atoms.map({atomNodeRenderer($0)})))
            moleculeNode.addChildNode(reduceToNode(mol.bonds.map({bondNodeRenderer($0)})))
            return moleculeNode
        }
        return renderer
    }
    
    open static func renderMoleculeAsScene(_ mol: MoleculeFragment) -> SCNScene {
        let scene = SCNScene()
        let renderer = SceneKitRenderer.createNodeRenderClosure()
        let moleculeNode = renderer(mol)
        scene.rootNode.addChildNode(moleculeNode)
        return scene
    }
    
    open static func startRotating(_ node: SCNNode, r: SCNVector4 = SCNVector4Make(1.0, 1.0, 0.0, 0.0)) {
        node.rotation = r
        let spin = CABasicAnimation(keyPath: "rotation.w")
        spin.toValue = 2.0*M_PI
        spin.duration = 3
        spin.repeatCount = HUGE
        node.addAnimation(spin, forKey: "spin around")
    }

}
