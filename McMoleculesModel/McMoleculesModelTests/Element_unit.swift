//
//  Element_unit.swift
//  molecule_model
//
//  Created by Matt Houser on 12/15/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import XCTest
@testable import McMoleculesModel

class ElementUnitTests: XCTestCase {
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
    
    func helpTestAtom(_ test: (Element.ElementInfo, (Element, Int, String))->Bool) -> Bool {
        return elements.reduce(true) {
            let info = Element.getInfo(forElement: $1.0)
            let pass = test(info, $1)
            XCTAssert(pass)
            return $0 && pass
        }
    }

    
    func testGetFromSymbol() {
        let test = {
            (info: Element.ElementInfo, tuple: (Element, Int, String)) -> Bool in
            return Element.get(fromSymbol: tuple.2) == tuple.0
        }
        XCTAssert(helpTestAtom(test))
    }

    
    func testAtomicNumber() {
        let test = {
            (info: Element.ElementInfo, tuple: (Element, Int, String)) -> Bool in
            return info.number == tuple.1
        }
        XCTAssert(helpTestAtom(test))
    }

    func testAtomicSymbol() {
        let test = {
            (info: Element.ElementInfo, tuple: (Element, Int, String)) -> Bool in
            return info.symbol == tuple.2
        }
        XCTAssert(helpTestAtom(test))
    }
}
