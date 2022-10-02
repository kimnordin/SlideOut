//
//  GameElements.swift
//  DodgeFall
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
        let size = CGSize(width: currentLevelModel.squareSize, height: currentLevelModel.squareSize)
        gridNode = GridNode(grid: grid, squareSize: CGFloat(currentLevelModel.squareSize))
        
        gridNode.delegate = self
        gridNode.position = CGPoint (x:frame.midX, y:frame.midY)
        addChild(gridNode)
    }
    
    func initPlayer() {
        let player = currentLevelModel.player
        let size = CGSize(width: currentLevelModel.squareSize, height: currentLevelModel.squareSize)
        playerNode = PlayerNode(player: player, size: size)
        
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.linearDamping = 0
        playerNode.physicsBody?.categoryBitMask = playerCategory
        playerNode.physicsBody?.contactTestBitMask = goalCategory | blockCategory
        playerNode.physicsBody?.collisionBitMask = movableBlockCategory
        
        playerNode.setScale(1.0)
        playerNode.position = gridNode.gridPosition(col: player.position.column, row: player.position.row)
        gridNode.addChild(playerNode)
    }
    
    func initGoal() {
        let goal = currentLevelModel.goal
        let size = CGSize(width: currentLevelModel.squareSize, height: currentLevelModel.squareSize)
        goalNode = GoalNode(goal: goal, size: size)
        
        let halfSize = CGSize(width: goalNode.size.width/2, height: goalNode.size.height/2)
        goalNode.physicsBody = SKPhysicsBody(rectangleOf: halfSize)
        goalNode.physicsBody?.allowsRotation = false
        goalNode.physicsBody?.linearDamping = 0
        goalNode.physicsBody?.categoryBitMask = goalCategory
        goalNode.physicsBody?.contactTestBitMask = playerCategory
        
        goalNode.setScale(1.0)
        goalNode.position = gridNode.gridPosition(col: goal.position.column, row: goal.position.row)
        gridNode.addChild(goalNode)
    }
    
    func initBlocks() {
        if let blocks = currentLevelModel.blocks {
            let size = CGSize(width: currentLevelModel.squareSize, height: currentLevelModel.squareSize)
            for block in blocks {
                let newBlock = BlockNode(block: block, size: size)
                newBlock.physicsBody = SKPhysicsBody(rectangleOf: newBlock.size)
                newBlock.physicsBody?.isDynamic = false
                newBlock.physicsBody?.categoryBitMask = blockCategory
                newBlock.physicsBody?.restitution = 0
                newBlock.position = gridNode.gridPosition(col: block.position.column, row: block.position.row)
                gridNode.addChild(newBlock)
            }
        }
    }
    
    func initMovableBlocks() {
        if let movableBlocks = currentLevelModel.movableBlocks {
            let size = CGSize(width: currentLevelModel.squareSize, height: currentLevelModel.squareSize)
            for movableBlock in movableBlocks {
                let newMovableBlock = MovableBlockNode(movableBlock: movableBlock, size: size)
                newMovableBlock.physicsBody = SKPhysicsBody(rectangleOf: newMovableBlock.size)
                newMovableBlock.physicsBody?.categoryBitMask = movableBlockCategory
                newMovableBlock.physicsBody?.restitution = 0
                newMovableBlock.position = gridNode.gridPosition(col: movableBlock.position.column, row: movableBlock.position.row)
                movableBlockNodes.append(newMovableBlock)
                gridNode.addChild(newMovableBlock)
            }
        }
    }
    
    func createHUD() {
        levelLabel = self.childNode(withName: "level") as? SKLabelNode
        levelLabel?.text = currentLevelModel.name
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
