//
//  Atom_unit.swift
//  molecule_model
//
//  Created by Matt Houser on 12/15/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import XCTest
import GLKit

@testable import McMoleculesModel

class AtomUnitTests: XCTestCase {
    let elements: [(Element, Int, String)] = [
        (Element.HYDROGEN, 1, "H"),
        (Element.CARBON, 6, "C"),
        (Element.IODINE, 53, "I"),
        (Element.EMPTY, 0, "")]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFromElement() {
        let atom_c = Atom(Element.CARBON)
        XCTAssert(atom_c.element == Element.CARBON)
    }
    
    func testHashable() {
        let c = Atom(Element.CARBON)
        let dict: Dictionary<Atom, Int> = [c: 6]
        XCTAssert(dict.count > 0)
        XCTAssert(dict.contains(where: { (tuple: (Atom, Int)) -> Bool in
            return tuple.0 == c && tuple.1 == 6
        }))
    }

    func testEquality() {
        let atom_c1 = Atom(Element.CARBON)
        let atom_c2 = Atom(Element.CARBON)
        let atom_c3 = atom_c1
        XCTAssert(atom_c1 == atom_c3)
        XCTAssert(atom_c1 != atom_c2)
    }

    func testAtom3dCreation() {
        let c = Atom(fromElement: Element.CARBON, andChemVector3: ChemVector3Make(1, 2, 3))
        let location : ChemVector3 = c.location
        XCTAssert(location.x == 1 && location.y == 2 && location.z == 3)
    }

}
