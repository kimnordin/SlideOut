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
            checkCollisionBeforeMoving(playerNode.player, direction: direction, squares: collisionSquares)
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
     Returns a Square with an updated position given a square to move, and a direction.
     - parameter square: The square to update.
     - parameter direction: The direction to move in.
     - returns: Closure containing the updated square.
     */
    private func moveSquareAction(_ originSquare: Square, direction: UISwipeGestureRecognizer.Direction, updatedSquare: @escaping (Square) -> ()) {
        
        let newPosition = positionToMove(originSquare, direction: direction)
        var newSquare = originSquare
        newSquare.position = newPosition

        let realPosition = gridNode.gridPosition(x: newPosition.x, y: newPosition.y)
        let moveAction = SKAction.move(to: realPosition, duration: playerMoveSpeed)
        playerNode.run(moveAction) {
            updatedSquare(newSquare)
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
     Moves a certain Square depending on it's `type` in a given direction.
     - parameter square: The position in the grid (x, y) to check.
     - parameter direction: The direction to move in.
     - returns: Whether the position is within the bounds of the grid or not.
     */
    func moveSquare(_ square: Square, direction: UISwipeGestureRecognizer.Direction, squares: [Square]) {
        switch square.type {
        case .player:
            if !isOutOfBounds(square.position, grid: gridNode.grid) {
                moveSquareAction(square, direction: direction) { [self] updatedSquare in
                    playerNode.player = updatedSquare
                    checkCollisionBeforeMoving(updatedSquare, direction: direction, squares: squares)
                }
            }  else {
                movePlayerToStart()
            }
        default: return
        }
    }
    
    /**
     Check for a collision around a square in a given direction, running an action conforming to the type of collision that was made.
     - parameter square: The square to check around.
     - parameter direction: The direction to check for a collision.
     - parameter squares: The squares to consider as colliders.
     */
    private func checkCollisionBeforeMoving(_ square: Square, direction: UISwipeGestureRecognizer.Direction, squares: [Square]) {
        let collidedSquare = squareCollision(square, distance: 1, direction: direction, squares: squares)
        
        switch collidedSquare?.type {
        case .block:
            stopPlayer()
        case .goal:
            nextLevel()
        default: // No Collision
            moveSquare(square, direction: direction, squares: squares)
        }
    }
    
    /**
     Returns the updated position to move to, based on a squares current position.
     - parameter square: The square to update the position of.
     - parameter direction: The direction to move in.
     - returns: The updated position.
     */
    private func positionToMove(_ square: Square, direction: UISwipeGestureRecognizer.Direction) -> Position {
        var position = square.position
        
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
     - parameter square: The square to check for surrounding collisions.
     - parameter distance: The number of squares to check.
     - parameter direction: The direction to check for a collision.
     - parameter squares: The squares to consider as colliding obstacles.
     - returns: The square that was collided with, or `nil` if no collision was made.
     */
    private func squareCollision(_ square: Square, distance: Int, direction: UISwipeGestureRecognizer.Direction, squares: [Square]) -> Square? {
        let squarePosition = square.position

        switch direction {
        case .up:
            if let matchingSquare = squares.first(where: { $0.position.y == squarePosition.y + distance &&
                $0.position.x == squarePosition.x }) {
                return matchingSquare
            }
        case .down:
            if let matchingSquare = squares.first(where: { $0.position.y == squarePosition.y - distance &&
                $0.position.x == squarePosition.x }) {
                return matchingSquare
            }
        case .left:
            if let matchingSquare = squares.first(where: { $0.position.x == squarePosition.x - distance &&
                $0.position.y == squarePosition.y }) {
                return matchingSquare
            }
        case .right:
            if let matchingSquare = squares.first(where: { $0.position.x == squarePosition.x + distance &&
                $0.position.y == squarePosition.y }) {
                return matchingSquare
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
