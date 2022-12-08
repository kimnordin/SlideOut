//
//  GameElements.swift
//  SlideOut
//
//  Created by Kim Nordin on 2021-02-02.
//

import GameplayKit
import SpriteKit

extension GameScene {
    func initLevel(from resource: String, withExtension: String) -> Levels? {
        guard let path = Bundle.main.url(forResource: resource, withExtension: withExtension) else { return nil }
        do {
            let data = try Data(contentsOf: path)
            let levels = try? JSONDecoder().decode(Levels.self, from: data)
            print("levels: ", levels)
            return levels
        } catch {
            print(error)
            return nil
        }
    }
    
    func initGrid() {
        let grid = currentLevelModel.grid
        gridNode = GridNode(grid: grid, squareSize: CGFloat(grid.squareSize))
        
        gridNode.position = CGPoint (x:frame.midX, y:frame.midY)
        addChild(gridNode)
    }
    
    func initPlayer() {
        let player = currentLevelModel.player
        let size = CGSize(width: gridNode.grid.squareSize, height: gridNode.grid.squareSize)
        playerNode = PlayerNode(square: player, size: size)
        
        playerNode.setScale(1.0)
        playerNode.position = gridNode.gridPosition(x: player.position.x, y: player.position.y)
        gridNode.addChild(playerNode)
    }
    
    func initGoal() {
        let goal = currentLevelModel.goal
        let size = CGSize(width: gridNode.grid.squareSize, height: gridNode.grid.squareSize)
        goalNode = SquareNode(square: goal, size: size)
        
        goalNode.setScale(1.0)
        goalNode.position = gridNode.gridPosition(x: goal.position.x, y: goal.position.y)
        gridNode.addChild(goalNode)
        
        collisionNodes.append(goalNode)
    }
    
    func initPoints() {
        if let points = currentLevelModel.points {
            let size = CGSize(width: gridNode.grid.squareSize/2, height: gridNode.grid.squareSize/2)
            for point in points {
                let newPoint = SquareNode(square: point, size: size)
                newPoint.position = gridNode.gridPosition(x: point.position.x, y: point.position.y)
                gridNode.addChild(newPoint)
                collisionNodes.append(newPoint)
            }
        }
    }
    
    func initBlocks() {
        if let blocks = currentLevelModel.blocks {
            let size = CGSize(width: gridNode.grid.squareSize, height: gridNode.grid.squareSize)
            for block in blocks {
                let newBlock = SquareNode(square: block, size: size)
                newBlock.position = gridNode.gridPosition(x: block.position.x, y: block.position.y)
                gridNode.addChild(newBlock)
                collisionNodes.append(newBlock)
            }
        }
    }
    
    func initEnemies() {
        if let blocks = currentLevelModel.enemies {
            let size = CGSize(width: gridNode.grid.squareSize, height: gridNode.grid.squareSize)
            for block in blocks {
                let newEnemy = EnemyNode(square: block, size: size)
                newEnemy.position = gridNode.gridPosition(x: block.position.x, y: block.position.y)
                gridNode.addChild(newEnemy)
                collisionNodes.append(newEnemy)
            }
        }
    }
    
    func initMovableNodes() {
        if let movableBlockNodes = currentLevelModel.movableBlocks {
            let size = CGSize(width: gridNode.grid.squareSize, height: gridNode.grid.squareSize)
            for movableNode in movableBlockNodes {
                let newMovableNode = MovableBlockNode(square: movableNode, size: size)
                newMovableNode.position = gridNode.gridPosition(x: movableNode.position.x, y: movableNode.position.y)
                gridNode.addChild(newMovableNode)
                collisionNodes.append(newMovableNode)
            }
        }
    }
    
    func createHUD() {
        victoryDisplayNode = self.childNode(withName: "victory") as? SKLabelNode
        victoryDisplayNode?.text = "Winner!!!"
        victoryDisplayNode?.isHidden = true
        
        levelLabel = self.childNode(withName: "level") as? SKLabelNode
        levelLabel?.text = currentLevelModel.name
    }
    
    func restartLevel() {
        movePlayerToStart()
        movePointsToStart()
        moveEnemiesToStart()
        moveMovableNodesToStart()
    }
    
    func movePlayerToStart() {
        remove(node: playerNode)
        initPlayer()
    }
    
    func movePointsToStart() {
        let pointNodes = collisionNodes.filter({ $0.square.type == .point })
        for pointNode in pointNodes {
            removeCollisionNode(pointNode)
        }
        initPoints()
        
    }
    
    func moveEnemiesToStart() {
        let enemyNodes = collisionNodes.filter({ $0.square.type == .enemy })
        for enemyNode in enemyNodes {
            removeCollisionNode(enemyNode)
        }
        initEnemies()
    }
    
    func moveMovableNodesToStart() {
        let movableNodes = collisionNodes.filter({ $0.square.type == .movableBlock })
        for movableNode in movableNodes {
            removeCollisionNode(movableNode)
        }
        initMovableNodes()
    }

    func removeCollisionNode(_ node: SquareNode) {
        remove(node: node)
        collisionNodes.removeAll(where: { $0.square.id == node.square.id })
    }
    
    func remove(node: SKNode) {
        node.removeFromParent()
    }

    func endGame(){
        let gameScene = GameScene(size: self.size)
        self.view!.presentScene(gameScene)
    }
    
    func addActions() {
        let swipeRight = UISwipeGestureRecognizer(target: self,
            action: #selector(GameScene.swipeRight(sender:)))
        swipeRight.direction = .right
        view?.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self,
            action: #selector(GameScene.swipeLeft(sender:)))
        swipeLeft.direction = .left
        view?.addGestureRecognizer(swipeLeft)
        let swipeUp = UISwipeGestureRecognizer(target: self,
            action: #selector(GameScene.swipeUp(sender:)))
        swipeUp.direction = .up
        view?.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self,
            action: #selector(GameScene.swipeDown(sender:)))
        swipeDown.direction = .down
        view?.addGestureRecognizer(swipeDown)
    }
}
