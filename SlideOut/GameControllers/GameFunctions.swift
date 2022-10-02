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

extension GameScene {
    func movePlayer(direction: UISwipeGestureRecognizer.Direction) {
        if direction != playerNode.collision {
            if playerNode.moving == false {
                playerNode.moving = true
                playerNode.direction = direction
                switch direction {
                case .right:
                    let moveRightAction = SKAction.move(by: CGVector(dx: 1, dy: 0), duration: 0.005)
                    let repeatAction = SKAction.repeatForever(moveRightAction)
                    playerNode.run(repeatAction)
                case .left:
                    let moveLeftAction = SKAction.move(by: CGVector(dx: -1, dy: 0), duration: 0.005)
                    let repeatAction = SKAction.repeatForever(moveLeftAction)
                    playerNode.run(repeatAction)
                case .up:
                    let moveUpAction = SKAction.move(by: CGVector(dx: 0, dy: 1), duration: 0.005)
                    let repeatAction = SKAction.repeatForever(moveUpAction)
                    playerNode.run(repeatAction)
                case .down:
                    let moveDownAction = SKAction.move(by: CGVector(dx: 0, dy: -1), duration: 0.005)
                    let repeatAction = SKAction.repeatForever(moveDownAction)
                    playerNode.run(repeatAction)
                default: return
                }
            }
        }
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
        movePlayer(direction: .right)
    }
    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
        movePlayer(direction: .left)
    }
    @objc func swipeUp(sender: UISwipeGestureRecognizer) {
        movePlayer(direction: .up)
    }
    @objc func swipeDown(sender: UISwipeGestureRecognizer) {
        movePlayer(direction: .down)
    }
    
    func stopPlayer(_ direction: UISwipeGestureRecognizer.Direction?) {
        playerNode.collision = direction
        playerNode.removeAllActions()
        playerNode.moving = false
    }
    
    func movePlayerToStart() {
        playerNode.collision = nil
        playerNode.direction = nil
        playerNode.moving = false
        playerNode.removeAllActions()
        remove(node: playerNode)
        initPlayer()
    }
    
    func moveMovableBlocksToStart() {
        for movableBlock in movableBlockNodes {
            remove(node: movableBlock)
        }
        initMovableBlocks()
    }
    
    func remove(node: SKNode) {
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
}
