//
//  MoleculeFragmentFactory_unit.swift
//  molecule_model
//
//  Created by Matt Houser on 12/18/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Foundation
import XCTest

@testable import McMoleculesModel

class MoleculeFragmentFactoryUnitTests: XCTestCase {
    
    let c = Element.CARBON
    let h = Element.HYDROGEN
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        let m = MoleculeFragmentFactory.create(ChemGeometry.TETRAHEDRAL, fromElement: c, withFillElement: h, andBondTypes: Array(repeating: Bond.BondType.single, count: 4) ).0
        XCTAssert(m.bonds.count == 4)
        let m2 = MoleculeFragmentFactory.create(ChemGeometry.TETRAHEDRAL, fromElement: c, withFillElement: h).0
        XCTAssert(m2.bonds.count == 4)
        let m3 = MoleculeFragmentFactory.create(ChemGeometry.TRIGONALPLANAR, fromElement: c, withFillElement: Element.EMPTY, andBondTypes: [Bond.BondType.double, Bond.BondType.single, Bond.BondType.single]).0
        XCTAssert(m3.bonds.count == 3)
        let carbon = m3.atoms.filter({$0.element == Element.CARBON}).first!
        let doubleBond = m3.bonds.filter({$0.type == Bond.BondType.double && $0.contains(carbon) && $0.contains(Element.EMPTY) }).first!
        let emptyAtom = (doubleBond.atoms.0.element == Element.EMPTY ? doubleBond.atoms.0 : doubleBond.atoms.1)
        let m4 = m3.replaceAtom(emptyAtom, withAtom: Atom(fromElement: Element.CARBON, andChemVector3: emptyAtom.location))
        let m4Atoms = m4.atoms
        XCTAssert(m4Atoms.count == 4)
    }
}
