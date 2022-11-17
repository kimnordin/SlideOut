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
        if playerNode.moving == false {
            playerNode.moving = true
            playerNode.direction = direction
            
            checkTiles(direction: direction) { closestCollision, positionDifference, isGoal in
                playerNode.player.position.x = Int(closestCollision.x)
                playerNode.player.position.y = Int(closestCollision.y)
                
                let realPosition = gridNode.gridPosition(x: Int(closestCollision.x), y: Int(closestCollision.y))
                let duration = Double(positionDifference) * playerMoveSpeed
                let moveAction = SKAction.move(to: realPosition, duration: duration)
                
                playerNode.run(moveAction) { [self] in
                    stopPlayer()
                    checkIsGoal(isGoal)
                    checkOutOfBounds(playerNode.player.position)
                }
            }
        }
    }
    
    func stopPlayer() {
        playerNode.direction = nil
        playerNode.moving = false
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
    
    func checkIsGoal(_ goal: Bool) {
        if goal {
            nextLevel()
        }
    }
    
    func checkOutOfBounds(_ position: Position) {
        if position.x > gridNode.grid.width-1 || position.x < 0 ||
            position.y > gridNode.grid.height-1 || position.y < 0 {
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
    
    /**
     Checks the tiles around the player in a certain direction and returnins the closest collision
     - parameter direction: The direction to check for a closest collision
     - returns closestCollision: A completion returning a:
        - CGPoint: x and y position of the closest obstacle
        - Int: Grid tiles between the player and the obstacle
        - Bool: Whether the obstacle is the goal or not
     */
    func checkTiles(direction: UISwipeGestureRecognizer.Direction, closestCollision: (CGPoint, Int, Bool) -> ()) {
        guard let player = playerNode.player else { return }
        
        var blocks = currentLevelModel.blocks ?? []
        blocks.append(goalNode.goal)
        var tilePositionDifference = 0
        var gridPositionToMove = CGPoint(x: player.position.x, y: player.position.y)

        switch direction {
        case .up:
            let negSameRowBlocks = blocks.filter({ $0.position.x == player.position.x && $0.position.y > player.position.y})
            
            if let closestValue = negSameRowBlocks.min(by: { abs($0.position.y - player.position.y) < abs($1.position.y - player.position.y) }) {
                gridPositionToMove = CGPoint(x: player.position.x, y: closestValue.position.y-1)
                tilePositionDifference = closestValue.position.y - player.position.y

                let isGoal = closestValue.position == goalNode.goal.position
                closestCollision(gridPositionToMove, tilePositionDifference, isGoal)
            } else {
                gridPositionToMove = CGPoint(x: player.position.x, y: gridNode.grid.height)
                tilePositionDifference = gridNode.grid.height - player.position.y
                
                closestCollision(gridPositionToMove, tilePositionDifference, false)
            }
        case .down:
            let negSameRowBlocks = blocks.filter({ $0.position.x == player.position.x && $0.position.y < player.position.y})
            
            if let closestValue = negSameRowBlocks.min(by: { abs($0.position.y - player.position.y) < abs($1.position.y - player.position.y) }) {
                gridPositionToMove = CGPoint(x: player.position.x, y: closestValue.position.y+1)
                tilePositionDifference = player.position.y - closestValue.position.y

                let isGoal = closestValue.position == goalNode.goal.position
                closestCollision(gridPositionToMove, tilePositionDifference, isGoal)
            } else {
                gridPositionToMove = CGPoint(x: player.position.x, y: -1)
                tilePositionDifference = player.position.y+1
                
                closestCollision(gridPositionToMove, tilePositionDifference, false)
            }
        case .left:
            let negSameRowBlocks = blocks.filter({ $0.position.y == player.position.y && $0.position.x < player.position.x})
            
            if let closestValue = negSameRowBlocks.min(by: { abs($0.position.x - player.position.x) < abs($1.position.x - player.position.x) }) {
                gridPositionToMove = CGPoint(x: closestValue.position.x+1, y: player.position.y)
                tilePositionDifference = player.position.x - closestValue.position.x
                
                let isGoal = closestValue.position == goalNode.goal.position
                closestCollision(gridPositionToMove, tilePositionDifference, isGoal)
            } else {
                gridPositionToMove = CGPoint(x: -1, y: player.position.y)
                tilePositionDifference = player.position.x+1
                
                closestCollision(gridPositionToMove, tilePositionDifference, false)
            }
        case .right:
            let negSameRowBlocks = blocks.filter({ $0.position.y == player.position.y && $0.position.x > player.position.x})
            
            if let closestValue = negSameRowBlocks.min(by: { abs($0.position.x - player.position.x) < abs($1.position.x - player.position.x) }) {
                gridPositionToMove = CGPoint(x: closestValue.position.x-1, y: player.position.y)
                tilePositionDifference = closestValue.position.x - player.position.x
                
                let isGoal = closestValue.position == goalNode.goal.position
                closestCollision(gridPositionToMove, tilePositionDifference, isGoal)
            } else {
                gridPositionToMove = CGPoint(x: gridNode.grid.width, y: player.position.y)
                tilePositionDifference = gridNode.grid.width - player.position.x
                
                closestCollision(gridPositionToMove, tilePositionDifference, false)
            }
        default: return
        }
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
