//
//  BitMask.swift
//  Starfallia
//
//  Created by Jake Foster on 6/25/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

typealias BitMask = UInt32

extension BitMask {
    init(shift: Int) {
        self.init(0x1 << shift)
    }

    static let star = BitMask(shift: 1)
    static let pinchField = BitMask(shift: 2)
}
