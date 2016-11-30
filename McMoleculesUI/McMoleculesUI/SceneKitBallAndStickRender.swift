//
//  SceneKitBallAndStickRender.swift
//  McMoleculesUI
//
//  Created by Matt Houser on 1/4/16.
//  Copyright © 2016 Matt Houser. All rights reserved.
//

import Foundation
import SceneKit
import McMoleculesModel

open class SceneKitBallAndStickRender {
    open static func renderAtomAsNode( _ atom : Atom ) -> SCNNode {
        func getSphere(_ r: Float, diffuse: ChemColor, specular: ChemColor = ChemColor.white, opacity: Float = 1.0) -> SCNGeometry {
            let s = SCNSphere(radius: CGFloat(r))
            s.firstMaterial!.specular.contents = specular
            s.firstMaterial!.diffuse.contents = diffuse
            return s
        }
        func renderEmptyAtom() -> AtomNode {
            let node = AtomNode(atom: atom)
            let sphere1Node = AtomNode(atom: atom, geo: getSphere(0.25, diffuse: DefaultElementColorMap.getElementColor(atom.element)))
            sphere1Node.isHidden = true
            node.addChildNode(sphere1Node)
            node.addChildNode(SCNNode(geometry: getSphere(0.1, diffuse: DefaultElementColorMap.getElementColor(atom.element))))
            node.addParticleSystem(SCNParticleSystem(named: "Fire.scnp", inDirectory: nil)!)
            return node
        }
        let atomNode : AtomNode
        if (atom.element == Element.EMPTY) {
            atomNode = renderEmptyAtom()
        } else {
            atomNode = AtomNode(atom: atom, geo: getSphere(0.25, diffuse: DefaultElementColorMap.getElementColor(atom.element)))
        }
        atomNode.position = SCNVector3Make(CGFloat(atom.location.x),
            CGFloat(atom.location.y), CGFloat(atom.location.z))
        return atomNode
    }
    
    open static func renderBondAsNode ( _ bond : Bond ) -> SCNNode {
        func getCyl(_ atoms: (Atom, Atom), pointsUp: Bool = true, r: Float = 0.1, specular: ChemColor = ChemColor.white) -> SCNNode {
            let len = (atoms.0.location - atoms.1.location).length()
            let cyl = SCNCylinder(radius: CGFloat(r), height: CGFloat(len/2.0))
            let diffuse = (atoms.0.element == Element.EMPTY) ? ChemColor.white : DefaultElementColorMap.getElementColor(atoms.0.element)
            cyl.firstMaterial!.diffuse.contents = diffuse
            cyl.firstMaterial!.specular.contents = specular
            let node = SCNNode(geometry: cyl)
            let yFactor = pointsUp ? Float(1) : Float(-1)
            node.position = SCNVector3Make(CGFloat(0.0), CGFloat(yFactor * Float(len)/4.0), CGFloat(0.0))
            return node
        }
        let bondNode = SCNNode()
        let p1 = bond.atoms.0.location
        let p2 = bond.atoms.1.location
        bondNode.addChildNode(getCyl((bond.atoms.0, bond.atoms.1), pointsUp: false))
        bondNode.addChildNode(getCyl((bond.atoms.1, bond.atoms.0), pointsUp: true))
        
        let targetVector = (p2-p1).normalize()
        let yVector = ChemVector3Make(0, 1, 0)
        bondNode.rotation = SCNVector4(ChemRotationVector.rotationVector(toAlignVector: yVector, toVector: targetVector))
        bondNode.position = SCNVector3(p1 + (p2-p1)/2)
        
        return bondNode
    }

}
