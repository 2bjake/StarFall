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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else { return }

        let scene = GameScene(size: view.frame.size)
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
