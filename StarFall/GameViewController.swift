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
        let viewPosition = recognizer.location(in: view)
        let scenePosition = scene.convertPoint(fromView: viewPosition)
        let direction: GameScene.PinchDirection = recognizer.velocity > 0 ? .out : .in

        switch recognizer.state {
        case .began:
            scene.pinchBeganAt(scenePosition, direction: direction)
        case .changed:
            scene.pinchChangedAt(scenePosition, direction: direction)
        case .ended:
            scene.pinchEndedAt(scenePosition, direction: direction)
        default:
            break
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
