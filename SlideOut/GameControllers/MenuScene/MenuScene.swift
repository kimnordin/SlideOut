//
//  MenuScene.swift
//  SlideOut
//
//  Created by Kim Nordin on 2023-09-10.
//

import SpriteKit

class MenuScene: SKScene {
    
    // MARK: HUD
    private var startLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        startLabel = self.childNode(withName: "start") as? SKLabelNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch")
        for touch in touches {
            let location = touch.location(in: self)
            let nodesArray = nodes(at: location)
            
            for node in nodesArray {
                if node.name == "start", let gameScene = SKScene(fileNamed: "GameScene") { // Transition to GameScene
                    gameScene.scaleMode = .aspectFill
                    self.view?.presentScene(gameScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
                }
            }
        }
    }
}
