//
//  GameViewController.swift
//  SlideOut
//
//  Created by Kim Nordin on 2021-02-02.
//

import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            // Load the SKScene from 'MenuScene.sks'
            if let menuScene = SKScene(fileNamed: "MenuScene") {
                menuScene.scaleMode = .aspectFill
                view.presentScene(menuScene)
            }
            
            if #available(iOS 11.0, *), let view = self.view {
                view.frame = self.view.safeAreaLayoutGuide.layoutFrame
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom]
    }
}
