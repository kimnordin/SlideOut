//
//  GameFunctions.swift
//  DodgeFall
//
//  Created by Kim Nordin on 2021-02-02.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func movePlayer(direction: UISwipeGestureRecognizer.Direction) {
        var newPosition = playerNode.player.position
        if playerNode.moving == false {
            playerNode.moving = true
            playerNode.direction = direction
            
            checkTiles(direction: direction) { closestCollision, positionDifference in
                playerNode.player.position.x = Int(closestCollision.x)
                playerNode.player.position.y = Int(closestCollision.y)
                
                let realPosition = gridNode.gridPosition(x: Int(closestCollision.x), y: Int(closestCollision.y))
                let duration = Double(positionDifference) * 0.2
                let moveAction = SKAction.move(to: realPosition, duration: duration)
                
                playerNode.run(moveAction) { [self] in
                    stopPlayer()
                    checkOutOfBounds(playerNode.player.position)
                }
            }
        }
    }
    
    func stopPlayer() {
        playerNode.direction = nil
        playerNode.moving = false
    }
    
    func checkOutOfBounds(_ position: Position) {
        if position.x > currentLevelModel.grid.x-1 || position.x < 0 ||
            position.y > currentLevelModel.grid.y-1 || position.y < 0 {
            movePlayerToStart()
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
    
    func movePlayerToStart() {
        playerNode.direction = nil
        playerNode.moving = false
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
