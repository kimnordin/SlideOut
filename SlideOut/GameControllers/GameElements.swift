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
        playerNode = PlayerNode(player: player, size: size)
        
        playerNode.setScale(1.0)
        playerNode.position = gridNode.gridPosition(x: player.position.x, y: player.position.y)
        gridNode.addChild(playerNode)
    }
    
    func initGoal() {
        let goal = currentLevelModel.goal
        let size = CGSize(width: gridNode.grid.squareSize, height: gridNode.grid.squareSize)
        goalNode = GoalNode(goal: goal, size: size)
        
        goalNode.setScale(1.0)
        goalNode.position = gridNode.gridPosition(x: goal.position.x, y: goal.position.y)
        gridNode.addChild(goalNode)
        
        collisionSquares.append(goal)
    }
    
    func initBlocks() {
        if let blocks = currentLevelModel.blocks {
            let size = CGSize(width: gridNode.grid.squareSize, height: gridNode.grid.squareSize)
            for block in blocks {
                let newBlock = BlockNode(block: block, size: size)
                newBlock.position = gridNode.gridPosition(x: block.position.x, y: block.position.y)
                gridNode.addChild(newBlock)
            }
            collisionSquares.append(contentsOf: blocks)
        }
    }
    
    func initMovableBlocks() {
        if let movableBlocks = currentLevelModel.movableBlocks {
            let size = CGSize(width: gridNode.grid.squareSize, height: gridNode.grid.squareSize)
            for movableBlock in movableBlocks {
                let newMovableBlock = MovableBlockNode(movableBlock: movableBlock, size: size)
                newMovableBlock.position = gridNode.gridPosition(x: movableBlock.position.x, y: movableBlock.position.y)
                gridNode.addChild(newMovableBlock)
            }
            collisionSquares.append(contentsOf: movableBlocks)
        }
    }
    
    func createHUD() {
        victoryDisplayNode = self.childNode(withName: "victory") as? SKLabelNode
        victoryDisplayNode?.text = "Winner!!!"
        victoryDisplayNode?.isHidden = true
        
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
