//
//  GameFunctions.swift
//  DodgeFall
//
//  Created by Kim Nordin on 2021-02-02.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func stopPlayer() {
        playerNode.moving = false
    }
    
    func movePlayerToStart() {
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
    
    func isOutOfBounds(_ position: Position) -> Bool {
        if position.x > gridNode.grid.width-1 || position.x < 0 ||
            position.y > gridNode.grid.height-1 || position.y < 0 {
            return true
        }
        return false
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
        movePlayer(.right)
    }
    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
        movePlayer(.left)
    }
    @objc func swipeUp(sender: UISwipeGestureRecognizer) {
        movePlayer(.up)
    }
    @objc func swipeDown(sender: UISwipeGestureRecognizer) {
        movePlayer(.down)
    }
    
    func movePlayer(_ direction: UISwipeGestureRecognizer.Direction) {
        if !playerNode.moving {
            checkCollisionBeforeMoving(direction)
        }
    }
    
    func checkCollisionBeforeMoving(_ direction: UISwipeGestureRecognizer.Direction) {
        guard var blocks = currentLevelModel.blocks else { return }
        blocks.append(goalNode.goal)
        let collisionSquare = checkTileForCollision(direction: direction, blocks: blocks)
        
        switch collisionSquare?.type {
        case .block:
            stopPlayer()
        case .goal:
            nextLevel()
        default:
            moveToSquare(direction)
        }
    }
    
    /**
     Move the Player to a new square
     - parameter direction: The direction to move in
     - remark: Recursively runs the ``checkCollisionBeforeMoving`` function
     */
    func moveToSquare(_ direction: UISwipeGestureRecognizer.Direction) {
        let newPosition = positionToMove(direction)
        playerNode.player.position = newPosition
        playerNode.moving = true
        
        let realPosition = gridNode.gridPosition(x: newPosition.x, y: newPosition.y)
        let moveAction = SKAction.move(to: realPosition, duration: playerMoveSpeed)
        playerNode.run(moveAction) { [self] in
            if !isOutOfBounds(playerNode.player.position) {
                self.checkCollisionBeforeMoving(direction)
            } else {
                movePlayerToStart()
            }
        }
    }
    
    /**
     The updated position to move to, based on the current position
     - parameter direction: The desired direction to move in
     - returns Position: The updated position
     */
    func positionToMove(_ direction: UISwipeGestureRecognizer.Direction) -> Position {
        var position = playerNode.player.position
        switch direction {
        case .up:
            position.y = playerNode.player.position.y + 1
        case .down:
            position.y = playerNode.player.position.y - 1
        case .left:
            position.x = playerNode.player.position.x - 1
        case .right:
            position.x = playerNode.player.position.x + 1
        default: break
        }
        return position
    }
    
    /**
     Checks the tiles around the player in a certain direction for a collision
     - parameter direction: The direction to check for a collision
     - parameter blocks: The blocks to consider as colliding obstacles
     - returns Bool: Indicating whether a collision was made or not
     */
    func checkTileForCollision(direction: UISwipeGestureRecognizer.Direction, blocks: [Square]) -> Square? {
        let playerPosition = playerNode.player.position
        
        switch direction {
        case .up:
            if let block = blocks.first(where: { $0.position.y == playerNode.player.position.y+1 &&
                $0.position.x == playerPosition.x }) {
                return block
            }
        case .down:
            if let block = blocks.first(where: { $0.position.y == playerNode.player.position.y-1 &&
                $0.position.x == playerPosition.x }) {
                return block
            }
        case .left:
            if let block = blocks.first(where: { $0.position.x == playerNode.player.position.x-1 &&
                $0.position.y == playerPosition.y }) {
                return block
            }
        case .right:
            if let block = blocks.first(where: { $0.position.x == playerNode.player.position.x+1 &&
                $0.position.y == playerPosition.y }) {
                return block
            }
        default: break
        }
        
        return nil
    }
    
    func remove(node: SKNode) {
        node.removeFromParent()
    }

    func endGame(){
        let gameScene = GameScene(size: self.size)
        self.view!.presentScene(gameScene)
    }
}
