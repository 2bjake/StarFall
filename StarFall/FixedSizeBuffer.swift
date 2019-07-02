//
//  FixedSizeBuffer.swift
//  StarFall
//
//  Created by Jake Foster on 7/2/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import Foundation

struct FixedSizeBuffer<Element> {
    private var buffer: Array<Element?>
    private let maxSize: Int
    private var backIndex = 0 // index "one off the end"

    init(size: Int) {
        maxSize = size
        buffer = Array<Element?>.init(repeating: nil, count: size)
    }

    @discardableResult
    mutating func replaceAppend(_ element: Element) -> Element? {
        let previousValue = buffer[backIndex]
        buffer[backIndex] = element

        backIndex = (backIndex + 1) % maxSize
        return previousValue
    }
}
