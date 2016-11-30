//
//  Bond_unit.swift
//  molecule_model
//
//  Created by Matt Houser on 12/17/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Foundation
import XCTest

@testable import McMoleculesModel

class BondUnitTests: XCTestCase {

    let atom1 = Atom(Element.CARBON)
    let atom2 = Atom(Element.HYDROGEN)

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFromAtom1andAtom2() {
        let bond = Bond(fromAtom: atom1, andAtom: atom2, andBondType: Bond.BondType.single)
        XCTAssert(bond.atoms.0 === atom1)
        XCTAssert(bond.atoms.1 === atom2)
        XCTAssert(bond.type == Bond.BondType.single)
    }
    
    func testDoesBondContainAtom() {
        let bond = Bond(fromAtom: atom1, andAtom: atom2, andBondType: Bond.BondType.single)
        let atom3 = Atom(Element.CARBON)
        
        XCTAssert(Bond.does(bond: bond, containAtom: atom1))
        XCTAssert(!Bond.does(bond: bond, containAtom: atom3))
    }
    
    func testEquality() {
        let bond1 = Bond(fromAtom: atom1, andAtom: atom2, andBondType: Bond.BondType.single)
        let bond2 = Bond(fromAtom: atom2, andAtom: atom1, andBondType: Bond.BondType.single)
        let bond3 = Bond(fromAtom: atom1, andAtom: Atom(Element.HYDROGEN), andBondType: Bond.BondType.single)
        let bond4 = Bond(fromAtom: atom2, andAtom: atom1, andBondType: Bond.BondType.double)
        
        XCTAssert(bond1 == bond2)
        XCTAssert(bond2 == bond1)
        XCTAssert(bond1 == bond1)
        XCTAssert(!(bond1==bond3))
        XCTAssert(!(bond2==bond4))
        XCTAssert(bond1 != bond3)
    }
}
