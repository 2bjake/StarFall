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
private let ejectVelocity = CGFloat(25)

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

    enum PinchEvent {
        case began, changed, ended, cancelled

        init?(_ state: UIGestureRecognizer.State) {
            switch state {
            case .began: self = .began
            case .changed: self = .changed
            case .ended: self = .ended
            case .cancelled: self = .cancelled
            default:
                return nil
            }
        }
    }

    private func randomEjectionPosition() -> CGPoint {
        enum Side: CaseIterable { case left, right, top, bottom }

        switch Side.allCases.randomElement()! {
        case .left:
            return .init(x: -starLength, y: CGFloat.random(in: 0..<size.height))
        case .right:
            return .init(x: size.width + starLength, y: CGFloat.random(in: 0..<size.height))
        case .top:
            return .init(x: CGFloat.random(in: 0..<size.width), y: size.height + starLength)
        case .bottom:
            return .init(x: CGFloat.random(in: 0..<size.width), y: -starLength)
        }
    }

    private func ejectStars() {
        print("ejecting stars")
        starBuffer.removeAll().forEach { starNode in
            starNode.physicsBody = nil
            starNode.run(.move(to: randomEjectionPosition(), duration: 0.25)) {
                starNode.removeFromParent()
                starNode.removeAllActions()
            }
        }
    }

    func pinchEvent(_ event: PinchEvent, inSceneAt positionInScene: CGPoint, velocity: CGFloat, distance: CGFloat?) {

        switch event {
        case .began, .changed:
            pinchField.isEnabled = true
            pinchField.position = positionInScene

            let strengthModifier = Float(distance ?? 0) * 10
            pinchField.strength = pinchFieldStrength - strengthModifier
        case .cancelled:
            pinchField.isEnabled = false
        case .ended:
            pinchField.isEnabled = false
            if velocity > ejectVelocity {
                ejectStars()
            }
        }
    }
}
