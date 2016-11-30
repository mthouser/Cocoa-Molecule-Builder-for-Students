//
//  MoleculeFragmentFactory.swift
//  molecule_model
//
//  Created by Matt Houser on 12/18/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Foundation
import GLKit

public enum ChemGeometry : Int {
    case SINGLE = 1
    case LINEAR = 2
    case TRIGONALPLANAR = 3
    case TETRAHEDRAL = 4
}



open class MoleculeFragmentFactory {
    static func getTetrahedralPoints() -> [ChemVector3] {
        let angle = Float(Double(109.5) * M_PI / Double(180))
        let a = ChemVector3Make(0,1,0).normalize()
        let rotZ = GLKQuaternionMakeWithAngleAndVector3Axis(angle, GLKVector3Make(0,0,1))
        let b = GLKQuaternionRotateVector3(rotZ, a)
        let rotY = GLKQuaternionMakeWithAngleAndVector3Axis(angle, GLKVector3Make(0,1,0))
        let c = GLKQuaternionRotateVector3(rotY, b)
        let d = GLKQuaternionRotateVector3(rotY, c)
        return [a,b,c,d]
    }
    static func getTrigonalPlanarPoints() -> [ChemVector3] {
        let angle = Float(Double(120) * M_PI / Double(180))
        let a = ChemVector3Make(0, 1, 0)
        let rotZ = GLKQuaternionMakeWithAngleAndVector3Axis(angle, GLKVector3Make(0,0,1))
        let b = GLKQuaternionRotateVector3(rotZ, a)
        let c = GLKQuaternionRotateVector3(rotZ, b)
        return [a,b,c]
    }
    
    static let geometries = [
        ChemGeometry.SINGLE: [
            ChemVector3Make(0.0, 1.0, 0.0)],
        ChemGeometry.LINEAR: [
            ChemVector3Make(0.0, 1.0, 0.0),
            ChemVector3Make(0.0, -1.0, 0.0)],
        ChemGeometry.TRIGONALPLANAR: MoleculeFragmentFactory.getTrigonalPlanarPoints(),
        ChemGeometry.TETRAHEDRAL: MoleculeFragmentFactory.getTetrahedralPoints()
    ]
    
    open static func create(_ geometry: ChemGeometry, fromElement element: Element, alignV v1: ChemVector3 = ChemVector3Make(0, 1, 0), toV v2: ChemVector3 = ChemVector3Make(0, 1, 0), offsetBy o: ChemVector3 = ChemVector3Make(0,0,0), withFillElement fill: Element = Element.EMPTY, andBondTypes inBondTypes: [Bond.BondType]=[]) -> (MoleculeFragment, Atom) {

        let points = (MoleculeFragmentFactory.geometries[geometry])!
        let bondTypes = (inBondTypes.count == 0) ? Array(repeating: Bond.BondType.single, count: points.count) : inBondTypes
        assert(bondTypes.count == MoleculeFragmentFactory.geometries[geometry]?.count)
        
        let transformedPoints = points.map({ChemRotationVector.rotateVector(vectorToRotate: $0, vectorToAlign: v1, ontoVector: v2) + o})
        let atom = Atom(fromElement: element, andChemVector3: o)
        let connectToAtom = Atom(fromElement: fill, andChemVector3: transformedPoints.first!)
        let fillAtoms = transformedPoints.dropFirst().map({Atom(fromElement: fill, andChemVector3: $0)}) + [connectToAtom]
        let atomsAndBondTypes : [(Atom, Bond.BondType)] = Array(zip(fillAtoms, bondTypes))
        let bonds = atomsAndBondTypes.map({Bond(fromAtom: atom, andAtom: $0.0, andBondType: $0.1)})
        return (MoleculeFragment(bonds), connectToAtom)
    }
}
