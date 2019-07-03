//
//  GameScene.swift
//  StarFall
//
//  Created by Jake Foster on 7/2/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    private let motionManager = CMMotionManager()
    private let motionQueue = OperationQueue()

    private let starTexture = SKTexture(imageNamed: "star")
    private var starBuffer = FixedSizeBuffer<SKNode>(size: 50)

    private lazy var starLength = CGFloat(size.width / 12)
    private lazy var starSize = CGSize(width: starLength, height: starLength)

    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: motionQueue) { [weak physicsWorld] motion, error in
            if let physicsWorld = physicsWorld, let motion = motion {
                physicsWorld.gravity = CGVector(dx: 9.8 * motion.gravity.x, dy: 9.8 * motion.gravity.y)
            }
        }
    }

    private func makeStarAt(_ position: CGPoint) -> SKNode {
        let starNode = SKSpriteNode(texture: starTexture, color: .yellow, size: starSize)
        starNode.colorBlendFactor = 0.75
        starNode.position = position
        starNode.physicsBody = SKPhysicsBody(texture: starTexture, size: starSize)
        return starNode
    }

    func clampLocationForTouch(_ touch: UITouch) -> CGPoint {
        var location = touch.location(in: self)

        func clamp(_ value: inout CGFloat, max: CGFloat) {
            let halfLength = starLength / 2
            if value < halfLength {
                value = halfLength
            } else if value > max - halfLength {
                value =  max - halfLength
            }
        }

        clamp(&location.x, max: size.width)
        clamp(&location.y, max: size.height)
        return location
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = clampLocationForTouch(touch)
        guard nodes(at: location).isEmpty else { return } //clicked on star, not adding another

        let newStar = makeStarAt(location)
        if let oldStar = starBuffer.replaceAppend(newStar) {
            oldStar.removeFromParent()
        }
        scene?.addChild(newStar)
    }
}
