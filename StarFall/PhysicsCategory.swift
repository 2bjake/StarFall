//
//  PhysicsCategory.swift
//  StarFall
//
//  Created by Jake Foster on 6/25/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit

struct PhysicsCategory: Equatable {
    let bitMask: UInt32

    init(bitMask: UInt32) {
        self.bitMask = bitMask
    }

    init(shift: Int) {
        self.bitMask = 0x1 << shift
    }
}

func |(left: PhysicsCategory, right: PhysicsCategory) -> PhysicsCategory {
    return PhysicsCategory(bitMask: left.bitMask | right.bitMask)
}

func &(left: PhysicsCategory, right: PhysicsCategory) -> PhysicsCategory {
    return PhysicsCategory(bitMask: left.bitMask & right.bitMask)
}

typealias BitMask = UInt32

extension BitMask {
    init(_ category: PhysicsCategory) {
        self = category.bitMask
    }
}

extension SKPhysicsBody {
    func isCategory(_ category: PhysicsCategory) -> Bool {
        return self.category == category
    }

    var category: PhysicsCategory {
        return PhysicsCategory(bitMask: categoryBitMask)
    }
}

extension SKPhysicsContact {
    func hasCategory(_ category: PhysicsCategory) -> Bool {
        return mainBodyAs(category) != nil
    }

    func mainBodyAs(_ category: PhysicsCategory) -> (main: SKPhysicsBody, other: SKPhysicsBody)? {
        if bodyA.isCategory(category) {
            return (bodyA, bodyB)
        } else if bodyB.isCategory(category) {
            return (bodyB, bodyA)
        } else {
            return nil
        }
    }

    func firstBodyAs(_ category: PhysicsCategory) -> SKPhysicsBody? {
        if let (main, _) = mainBodyAs(category) {
            return main
        } else {
            return nil
        }
    }
}
