//
//  GameFunctions.swift
//  SlideOut
//
//  Created by Kim Nordin on 2021-02-02.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func movePlayer(_ direction: UISwipeGestureRecognizer.Direction) {
        if !playerNode.moving {
            playerNode.moving = true
            checkCollisionBeforeMoving(playerNode.player, direction: direction, blocks: allBlocks)
        }
    }
    
    func stopPlayer() {
        playerNode.moving = false
    }
    
    func movePlayerToStart() {
        playerNode.moving = false
        remove(node: playerNode)
        initPlayer()
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
    
    /**
     Move the Player to a new position given a direction.
     - parameter direction: The direction to move.
     - returns: Closure confirming that the move action completed.
     */
    private func movePlayerAction(direction: UISwipeGestureRecognizer.Direction, finished: @escaping () -> ()) {
        let newPosition = positionToMove(playerNode.player, direction: direction)
        playerNode.player.position = newPosition
        
        let realPosition = gridNode.gridPosition(x: newPosition.x, y: newPosition.y)
        let moveAction = SKAction.move(to: realPosition, duration: playerMoveSpeed)
        playerNode.run(moveAction) {
            finished()
        }
    }
    
    /**
     Check whether a given position is within a grid or not, returning the result.
     - parameter position: The position in the grid (x, y) to check.
     - parameter grid: The grid to check within.
     - returns: Whether the position is within the bounds of the grid or not.
     */
    private func isOutOfBounds(_ position: Position, grid: Grid) -> Bool {
        if position.x > grid.width-1 || position.x < 0 ||
            position.y > grid.height-1 || position.y < 0 {
            return true
        }
        return false
    }
    
    /**
     Check for a collision around a square in a given direction, running an action conforming to the type of collision that was made.
     - parameter originSquare: The square to check around.
     - parameter direction: The direction to check for a collision.
     - parameter blocks: The blocks to consider as colliders.
     */
    private func checkCollisionBeforeMoving(_ originSquare: Square, direction: UISwipeGestureRecognizer.Direction, blocks: [Square]) {
        let collidedSquare = squareCollision(playerNode.player, distance: 1, direction: direction, blocks: blocks)
        
        switch collidedSquare?.type {
        case .block:
            stopPlayer()
        case .goal:
            nextLevel()
        default: // No Collision
            movePlayerAction(direction: direction) { [self] in
                if isOutOfBounds(playerNode.player.position, grid: gridNode.grid) {
                    movePlayerToStart()
                } else {
                    checkCollisionBeforeMoving(playerNode.player, direction: direction, blocks: blocks)
                }
            }
        }
    }
    
    /**
     Returns the updated position to move to, based on a squares current position.
     - parameter originSquare: The square to update the position of.
     - parameter direction: The desired direction to move in.
     - returns: The updated position.
     */
    private func positionToMove(_ originSquare: Square, direction: UISwipeGestureRecognizer.Direction) -> Position {
        var position = originSquare.position
        
        switch direction {
        case .up:
            position.y = position.y + 1
        case .down:
            position.y = position.y - 1
        case .left:
            position.x = position.x - 1
        case .right:
            position.x = position.x + 1
        default: break
        }
        return position
    }
    
    /**
     Checks for a collision around a ``Square`` given a distance and direction, returning the square it collided with.
     - parameter originSquare: The square to check for surrounding collisions.
     - parameter distance: The number of squares to check.
     - parameter direction: The direction to check for a collision.
     - parameter blocks: The blocks to consider as colliding obstacles.
     - returns: The square that was collided with, or `nil` if no collision was made.
     */
    private func squareCollision(_ originSquare: Square, distance: Int, direction: UISwipeGestureRecognizer.Direction, blocks: [Square]) -> Square? {
        let squarePosition = originSquare.position

        switch direction {
        case .up:
            if let block = blocks.first(where: { $0.position.y == squarePosition.y + distance &&
                $0.position.x == squarePosition.x }) {
                return block
            }
        case .down:
            if let block = blocks.first(where: { $0.position.y == squarePosition.y - distance &&
                $0.position.x == squarePosition.x }) {
                return block
            }
        case .left:
            if let block = blocks.first(where: { $0.position.x == squarePosition.x - distance &&
                $0.position.y == squarePosition.y }) {
                return block
            }
        case .right:
            if let block = blocks.first(where: { $0.position.x == squarePosition.x + distance &&
                $0.position.y == squarePosition.y }) {
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
