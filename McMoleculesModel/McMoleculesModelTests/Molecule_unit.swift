//
//  Molecule_unit.swift
//  molecule_model
//
//  Created by Matt Houser on 12/17/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Foundation
import XCTest

@testable import McMoleculesModel

class MoleculeFragmentUnitTests: XCTestCase {
    
    let atom1 = Atom(Element.CARBON)
    let atom2 = Atom(Element.HYDROGEN)
    let atom3 = Atom(Element.HYDROGEN)
    let atom4 = Atom(Element.CARBON)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDefaultInit() {
        let m = MoleculeFragment()
        XCTAssert(m.bonds.count == 0)
    }
    
    func testInitFromBonds() {
        let bond1 = Bond(fromAtom: atom1, andAtom: atom2, andBondType: Bond.BondType.single)
        let m = MoleculeFragment([bond1])
        XCTAssert(m.bonds.count == 1)
        XCTAssert(m.atoms.contains(atom1))
        XCTAssert(m.atoms.contains(atom2))
        XCTAssert(m.bonds.filter({$0 == bond1}).count > 0)
        let m2 = MoleculeFragment(m.bonds + [bond1])
        XCTAssert(m2.bonds.count == 1)  //Identical bond added twice. Bonds is a Set
        let m3 = MoleculeFragment(m.bonds + [Bond(fromAtom: atom1, andAtom: atom2, andBondType: Bond.BondType.double)])
        XCTAssert(m3.bonds.count == 2)
    }
    
    func testGetAtoms() {
        let bond1 = Bond(fromAtom: atom1, andAtom: atom2, andBondType: Bond.BondType.single)
        let m = MoleculeFragment([bond1])
        let atoms = m.atoms
        XCTAssert(atoms.count == 2)
        XCTAssert(atoms.contains(atom1))
        XCTAssert(atoms.contains(atom2))
    }
    
    func testNewAddingBond() {
        let bond1 = Bond(fromAtom: atom1, andAtom: atom2, andBondType: Bond.BondType.single)
        let m1 = MoleculeFragment([bond1])
        let bond2 = Bond(fromAtom: atom1, andAtom: atom3, andBondType: Bond.BondType.single)
        let m2 = m1.add(bond2)
        XCTAssert(m2.bonds.count == 2)
        XCTAssert(m2.bonds.contains(bond1))
        XCTAssert(m2.bonds.contains(bond2))
        XCTAssert(m2.atoms.count == 3)
    }
 
    func testSimpleReplaceAtom() {
        let bond1 = Bond(fromAtom: atom1, andAtom: atom2, andBondType: Bond.BondType.single)
        let m1 = MoleculeFragment([bond1])
        let m2 = m1.replaceAtom(atom1, withAtom: Atom(Element.BROMINE))
        XCTAssert(m2.atoms.filter({$0.element==Element.BROMINE}).count == 1)
        XCTAssert(m2.atoms.filter({$0.element==Element.CARBON}).count == 0)
    }
    
    func testNewJoinReplacingAtom() {
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
        XCTAssert(ethane.atoms.count == 8)
        XCTAssert(ethane.bonds.count == 7)
        
        //Replace all EMPTY with HYDROGEN
        let empties = ethane.atoms.filter({$0.element == Element.EMPTY})
        let ethane2 = empties.reduce(ethane) { (newMol: MoleculeFragment, a: Atom) -> MoleculeFragment in
            return newMol.replaceAtom(a, withAtom: Atom(fromElement: Element.HYDROGEN, andChemVector3: a.location))
        }
        XCTAssert(ethane2.atoms.count == 8)
        XCTAssert(ethane2.bonds.count == 7)
        XCTAssert(ethane2.atoms.filter({$0.element == Element.EMPTY}).count == 0)
        XCTAssert(ethane2.atoms.filter({$0.element == Element.HYDROGEN}).count == 6)
        XCTAssert(ethane2.atoms.filter({$0.element == Element.CARBON}).count == 1)
        XCTAssert(ethane2.atoms.filter({$0.element == Element.OXYGEN}).count == 1)
    }
    
    func testFindBonds() {
        let bond1 = Bond(fromAtom: atom1, andAtom: atom2, andBondType: Bond.BondType.single)
        let m1 = MoleculeFragment([bond1]).add(Bond(fromAtom: atom1, andAtom: atom3, andBondType: Bond.BondType.single))
        let bonds = m1.bonds.filter({$0.contains(self.atom1)})
        XCTAssert(bonds.count == 2)
        let bonds2 = m1.bonds.filter({$0.contains(self.atom4)})
        XCTAssert(bonds2.count == 0)
    }    
}
