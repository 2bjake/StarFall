//
//  GameViewController.swift
//  Starfallia
//
//  Created by Jake Foster on 7/2/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

//contants
private let ejectPinchVelocity = CGFloat(25)
private let doubleSwipeInterval = TimeInterval(0.5)

class GameViewController: UIViewController {

    var scene: GameScene!

    var lastSwipe: (edge: GameScene.EjectionEdge, time: Date)?

    private func isSecondSwipeToward(_ edge: GameScene.EjectionEdge) -> Bool {
        guard let lastSwipe = lastSwipe else { return false }
        return edge == lastSwipe.edge && Date().timeIntervalSince(lastSwipe.time) < doubleSwipeInterval
    }

    private func handleSwipeToward(_ edge: GameScene.EjectionEdge) {
        if isSecondSwipeToward(edge){
            scene.ejectStars(edge: edge)
            lastSwipe = nil
        } else {
            lastSwipe = (edge, Date())
        }
    }

    @IBAction func leftSwipeHandler(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            handleSwipeToward(.left)
        }
    }

    @IBAction func rightSwipeHandler(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            handleSwipeToward(.right)
        }
    }

    @IBAction func upSwipeHandler(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            handleSwipeToward(.top)
        }
    }

    @IBAction func downSwipeHandler(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            handleSwipeToward(.bottom)
        }
    }

    @IBAction func pinchHandler(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            guard recognizer.numberOfTouches >= 2 else { return }

            let viewPosition = recognizer.location(in: view)
            let largestPossibleTouch = sqrt(pow(scene.size.height, 2) + pow(scene.size.width, 2))
            let touchOne = recognizer.location(ofTouch: 0, in: view)
            let touchTwo = recognizer.location(ofTouch: 1, in: view)
            let touchDistance = sqrt(pow(touchOne.x - touchTwo.x, 2) + pow(touchOne.y - touchTwo.y, 2)) / largestPossibleTouch
            scene.enablePinchField(position: scene.convertPoint(fromView: viewPosition), diameter: touchDistance)
        case .ended, .cancelled:
            scene.disablePinchField()
            if recognizer.velocity > ejectPinchVelocity {
                scene.ejectStars(edge: .all)
            }
        default:
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else { return }

        scene = GameScene(size: view.frame.size)
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
