//
//  FixedSizeBufferTests.swift
//  StarfalliaTests
//
//  Created by Jake Foster on 7/8/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import XCTest
@testable import Starfallia

class FixedSizeBufferTests: XCTestCase {
    func testEmpty() {
        let buffer = FixedSizeBuffer<Int>(size: 50)
        XCTAssertTrue(buffer.allElements.isEmpty)
    }

    func testSingleton() {
        var buffer = FixedSizeBuffer<Int>(size: 1)
        XCTAssertTrue(buffer.allElements.isEmpty)
        buffer.replaceAppend(1)
        XCTAssertTrue(buffer.allElements.first == 1)
        buffer.replaceAppend(2)
        XCTAssertTrue(buffer.allElements.first == 2)
    }

    func testReplaceAppend() {
        var buffer = FixedSizeBuffer<Int>(size: 2)
        buffer.replaceAppend(1)
        buffer.replaceAppend(2)
        var elements = buffer.allElements
        XCTAssertEqual(elements.count, 2)
        XCTAssertTrue(elements.contains(1))
        XCTAssertTrue(elements.contains(2))

        buffer.replaceAppend(3)
        elements = buffer.allElements
        XCTAssertEqual(elements.count, 2)
        XCTAssertTrue(elements.contains(3))
        XCTAssertTrue(elements.contains(2))
    }

    func testRemoveAll() {
        var buffer = FixedSizeBuffer<Int>(size: 3)
        buffer.replaceAppend(1)
        buffer.replaceAppend(2)

        XCTAssertEqual(buffer.allElements.count, 2)

        let removed = buffer.removeAll()
        XCTAssertTrue(buffer.allElements.isEmpty)
        XCTAssertEqual(removed.count, 2)
        XCTAssertTrue(removed.contains(1))
        XCTAssertTrue(removed.contains(2))
    }
}
