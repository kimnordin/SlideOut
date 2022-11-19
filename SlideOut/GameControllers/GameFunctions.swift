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
            checkCollisionBeforeMoving(playerNode, direction: direction, nodes: collisionNodes)
        }
    }
    
    func stopNode(_ node: SquareNode) {
        if let playerNode = node as? PlayerNode {
            playerNode.moving = false
        } else if let movableNode = node as? MovableBlockNode {
            movableNode.moving = false
        }
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
     Moves a node and updates its position given a direction.
     - parameter node: The node to update.
     - parameter direction: The direction to move in.
     - returns: Closure confirming that the action completed.
     */
    private func moveSquareAction(_ node: SquareNode, direction: UISwipeGestureRecognizer.Direction, finished: @escaping () -> ()) {
        let newPosition = positionToMove(node, direction: direction)
        node.square.position = newPosition

        let realPosition = gridNode.gridPosition(x: newPosition.x, y: newPosition.y)
        let moveAction = SKAction.move(to: realPosition, duration: playerMoveSpeed)
        node.run(moveAction) {
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
     Moves a node depending on it's `type` in a given direction.
     - parameter node: The node to move.
     - parameter direction: The direction to move in.
     - parameter nodes: The nodes to consider as colliders.
     */
    func moveNode(_ node: SquareNode, direction: UISwipeGestureRecognizer.Direction, nodes: [SquareNode]) {
        if !isOutOfBounds(node.square.position, grid: gridNode.grid) {
            moveSquareAction(node, direction: direction) { [self] in
                checkCollisionBeforeMoving(node, direction: direction, nodes: nodes)
            }
        } else if node.square.type == .player {
            movePlayerToStart()
        }
    }
    
    /**
     Check for a collision around a node in a given direction, running an action conforming to the type of collision that was made.
     - parameter node: The node to check around.
     - parameter direction: The direction to check for a collision.
     - parameter nodes: The nodes to consider as colliders.
     */
    private func checkCollisionBeforeMoving(_ node: SquareNode, direction: UISwipeGestureRecognizer.Direction, nodes: [SquareNode]) {
        let collidedNode = nodeCollision(node, distance: 1, direction: direction, nodes: nodes)
        
        switch (node.square.type, collidedNode?.square.type) {
        case (.player, .block):
            stopNode(node)
        case (.player, .goal):
            nextLevel()
        case (.player, .movableBlock):
            stopNode(node)
            guard let collidedNode = collidedNode else { return }
            checkCollisionBeforeMoving(collidedNode, direction: direction, nodes: nodes)
        case (.movableBlock, .block):
            stopNode(node)
        default: // No Collision
            moveNode(node, direction: direction, nodes: nodes)
        }
    }
    
    /**
     Returns the updated position to move to, based on a nodes current position.
     - parameter node: The node to update the position of.
     - parameter direction: The direction to move in.
     - returns: The updated position.
     */
    private func positionToMove(_ node: SquareNode, direction: UISwipeGestureRecognizer.Direction) -> Position {
        var position = node.square.position
        
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
     Checks for a collision around a ``SquareNode`` given a distance and direction, returning the node it collided with.
     - parameter node: The node to check for surrounding collisions.
     - parameter distance: The number of nodes to check.
     - parameter direction: The direction to check for a collision.
     - parameter nodes: The nodes to consider as colliders.
     - returns: The node that was collided with, or `nil` if no collision was made.
     */
    private func nodeCollision(_ node: SquareNode, distance: Int, direction: UISwipeGestureRecognizer.Direction, nodes: [SquareNode]) -> SquareNode? {
        let squarePosition = node.square.position

        switch direction {
        case .up:
            if let matchingNode = nodes.first(where: { $0.square.position.y == squarePosition.y + distance &&
                $0.square.position.x == squarePosition.x }) {
                return matchingNode
            }
        case .down:
            if let matchingNode = nodes.first(where: { $0.square.position.y == squarePosition.y - distance &&
                $0.square.position.x == squarePosition.x }) {
                return matchingNode
            }
        case .left:
            if let matchingNode = nodes.first(where: { $0.square.position.x == squarePosition.x - distance &&
                $0.square.position.y == squarePosition.y }) {
                return matchingNode
            }
        case .right:
            if let matchingNode = nodes.first(where: { $0.square.position.x == squarePosition.x + distance &&
                $0.square.position.y == squarePosition.y }) {
                return matchingNode
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
