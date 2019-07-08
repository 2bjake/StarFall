//
//  GameScene.swift
//  Starfallia
//
//  Created by Jake Foster on 7/2/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import SpriteKit
import CoreMotion

//constants
private let gravity = 9.8
private let pinchFieldStrength = Float(15)
private let maxNumStars = 50
private let starWidthPercentage = CGFloat(1.0 / 12)


class GameScene: SKScene {
    private let motionManager = CMMotionManager()
    private let motionQueue = OperationQueue()

    private let starTexture = SKTexture(imageNamed: "star")
    private var starBuffer = FixedSizeBuffer<SKNode>(size: maxNumStars)

    private lazy var starLength = size.width * starWidthPercentage
    private lazy var starSize = CGSize(width: starLength, height: starLength)

    private let pinchField = SKFieldNode.radialGravityField()

    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        pinchField.categoryBitMask = .pinchField
        pinchField.falloff = 0
        pinchField.isEnabled = false
        addChild(pinchField)

        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: motionQueue) { [weak physicsWorld] motion, _ in
            guard let motion = motion else { return }
            physicsWorld?.gravity = CGVector(dx: gravity * motion.gravity.x, dy: gravity * motion.gravity.y)
        }
    }

    private func makeStarAt(_ position: CGPoint) -> SKNode {
        let starNode = SKSpriteNode(texture: starTexture, color: .yellow, size: starSize)
        starNode.colorBlendFactor = 0.75
        starNode.position = position
        starNode.physicsBody = SKPhysicsBody(texture: starTexture, size: starSize)
        starNode.physicsBody?.categoryBitMask = .star
        starNode.physicsBody?.fieldBitMask = .pinchField
        return starNode
    }

    private func clampedLocationForTouch(_ touch: UITouch) -> CGPoint {
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

        let location = clampedLocationForTouch(touch)
        guard nodes(at: location).isEmpty else { return } //clicked on star, not adding another

        let newStar = makeStarAt(location)
        if let oldStar = starBuffer.replaceAppend(newStar) {
            oldStar.removeFromParent()
        }
        scene?.addChild(newStar)
    }

    enum EjectionEdge {
        case right, left, top, bottom, all
    }

    // slides star directly toward specified edge
//    private func slideEjectionPosition(from startPosition: CGPoint, toEdge edge: EjectionEdge) -> CGPoint {
//        var newPosition = startPosition
//        switch edge {
//        case .all:
//            newPosition =  randomEjectionPosition(edge: .all)
//        case .left:
//            newPosition.x -= size.width
//        case .right:
//            newPosition.x += size.width
//        case .top:
//            newPosition.y += size.height
//        case .bottom:
//            newPosition.y -= size.height
//        }
//        return newPosition
//    }

    // moves star to random spot on specified edge
    private func randomEjectionPosition(edge: EjectionEdge) -> CGPoint {
        switch edge {
        case .left:
            return .init(x: -starLength, y: CGFloat.random(in: 0..<size.height))
        case .right:
            return .init(x: size.width + starLength, y: CGFloat.random(in: 0..<size.height))
        case .top:
            return .init(x: CGFloat.random(in: 0..<size.width), y: size.height + starLength)
        case .bottom:
            return .init(x: CGFloat.random(in: 0..<size.width), y: -starLength)
        case .all:
            return randomEjectionPosition(edge: [EjectionEdge.left, .right, .top, .bottom].randomElement()!)
        }
    }

    private func ejectionPosition(from startPosition: CGPoint, toEdge edge: EjectionEdge) -> CGPoint {
        // slides star straight off specified edge
        //return slideEjectionPosition(from: startPosition, toEdge: edge)

        // explodes stars to random positions on random edges
        //return randomEjectionPosition(edge: .all)

        // moves stars to random positions on specified edge
        return randomEjectionPosition(edge: edge)
    }

    func ejectStars(edge: EjectionEdge) {
        starBuffer.removeAll().forEach { starNode in
            starNode.physicsBody = nil
            starNode.run(.move(to: ejectionPosition(from: starNode.position, toEdge: edge), duration: 0.25)) {
                starNode.removeFromParent()
                starNode.removeAllActions()
            }
        }
    }

    func enablePinchField(position: CGPoint, diameter: CGFloat) {
        pinchField.isEnabled = true
        pinchField.position = position
        pinchField.strength = pinchFieldStrength - Float(diameter * 10)
    }

    func disablePinchField() {
        pinchField.isEnabled = false
    }
}
