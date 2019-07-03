//
//  FixedSizeBuffer.swift
//  StarFall
//
//  Created by Jake Foster on 7/2/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import Foundation

struct FixedSizeBuffer<Element> {
    private var buffer: [Element?]
    private let maxSize: Int
    private var backIndex = 0 // index "one off the end"

    init(size: Int) {
        maxSize = size
        buffer = .init(repeating: nil, count: size)
    }

    @discardableResult
    mutating func replaceAppend(_ element: Element) -> Element? {
        let previousValue = buffer[backIndex]
        buffer[backIndex] = element

        backIndex = (backIndex + 1) % maxSize
        return previousValue
    }

    mutating func removeAll() -> [Element] {
        let oldBuffer = buffer
        buffer = Array.init(repeating: nil, count: maxSize)
        backIndex = 0
        return oldBuffer.compactMap { $0 }
    }
}
