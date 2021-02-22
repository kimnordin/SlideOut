//
//  GameFunctions.swift
//  DodgeFall
//
//  Created by Kim Nordin on 2021-02-02.
//

import SpriteKit
import GameplayKit

enum Direction {
    case up
    case down
    case left
    case right
    case upleft
    case upright
    case downright
    case downleft
}

extension Player {
    func movePlayer(direction: Direction) {
        if !self.hasActions() {
            switch direction {
            case .right:
                let moveRightAction = SKAction.move(by: CGVector(dx: 1, dy: 0), duration: 0.005)
                let repeatAction = SKAction.repeatForever(moveRightAction)
                self.run(repeatAction)
            case .left:
                let moveLeftAction = SKAction.move(by: CGVector(dx: -1, dy: 0), duration: 0.005)
                let repeatAction = SKAction.repeatForever(moveLeftAction)
                self.run(repeatAction)
            case .up:
                let moveUpAction = SKAction.move(by: CGVector(dx: 0, dy: 1), duration: 0.005)
                let repeatAction = SKAction.repeatForever(moveUpAction)
                self.run(repeatAction)
            case .down:
                let moveDownAction = SKAction.move(by: CGVector(dx: 0, dy: -1), duration: 0.005)
                let repeatAction = SKAction.repeatForever(moveDownAction)
                self.run(repeatAction)
            default: return
            }
        }
    }
}

extension GameScene {
        
    func spawnEnemies() {
        let randomTracks = [0, 1, 2]
        let roll = randomTracks[Int(arc4random_uniform(UInt32(randomTracks.count)))]
        
        
        let randomEnemyType = Enemies(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 3))!
        if let newEnemy = addEnemy(type: randomEnemyType, forTrack: roll) {
            self.addChild(newEnemy)
            print("newEnemy track: ", roll)
        }
        
        self.enumerateChildNodes(withName: "ENEMY") { (node:SKNode, nil) in
            if node.position.y < 70 {
                self.removeEnemy(node: node)
                self.increaseScore()
            }
        }
    }
    
    func moveTile() {
        
    }
    
    func increaseScore() {
        currentScore += 1
    }
    
    func removeEnemy(node: SKNode) {
        node.removeFromParent()
    }
    
    func removeTouches(nodes: [SKSpriteNode?]) {
        for node in nodes {
            if let node = node {
                node.isUserInteractionEnabled = false
            }
        }
    }
    
    func endGame(){
        let gameScene = GameScene(size: self.size)
        self.view!.presentScene(gameScene)
    }
    
    func movePlayerToStart() {
        player.removeFromParent()
        self.addPlayer()
    }
}
