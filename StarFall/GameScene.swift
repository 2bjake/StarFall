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

    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: motionQueue) { [weak physicsWorld] motion, error in
            if let physicsWorld = physicsWorld, let motion = motion {
                physicsWorld.gravity = CGVector(dx: 9.8 * motion.gravity.x, dy: 9.8 * motion.gravity.y)
            }
        }
    }

    private func makeStarAt(_ position: CGPoint) -> SKNode {
        let size = CGSize(width: 75, height: 75)
        let starNode = SKSpriteNode(texture: starTexture, color: .yellow, size: size)
        starNode.colorBlendFactor = 0.75
        starNode.position = position
        starNode.physicsBody = SKPhysicsBody(texture: starTexture, size: size)
        return starNode
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let newStar = makeStarAt(touch.location(in: self))
        if let oldStar = starBuffer.replaceAppend(newStar) {
            oldStar.removeFromParent()
        }
        scene?.addChild(newStar)
    }
}
