//
//  GameViewController.swift
//  StarFall
//
//  Created by Jake Foster on 7/2/19.
//  Copyright © 2019 Jake Foster. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var scene: GameScene!

    @IBAction func pinchHandler(_ recognizer: UIPinchGestureRecognizer) {
        guard let pinchEvent = GameScene.PinchEvent(recognizer.state) else { return }

        let viewPosition = recognizer.location(in: view)

        var touchDistance: CGFloat?
        if recognizer.numberOfTouches >= 2 {
            let largestPossibleTouch = sqrt(pow(scene.size.height, 2) + pow(scene.size.width, 2))
            let touchOne = recognizer.location(ofTouch: 0, in: view)
            let touchTwo = recognizer.location(ofTouch: 1, in: view)
            touchDistance = sqrt(pow(touchOne.x - touchTwo.x, 2) + pow(touchOne.y - touchTwo.y, 2)) / largestPossibleTouch
        }

        scene.pinchEvent(pinchEvent,
                         inSceneAt: scene.convertPoint(fromView: viewPosition),
                         velocity: recognizer.velocity,
                         distance: touchDistance)
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
