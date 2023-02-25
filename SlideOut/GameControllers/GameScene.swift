//
//  GameScene.swift
//  SlideOut
//
//  Created by Kim Nordin on 2021-02-02.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: Game Properties
    private var levels: Levels!
    var currentLevelModel: LevelModel!
    var currentLevel = 0
    var playerMoveSpeed = 0.2
    var score = 0
    
    // MARK: HUD
    var levelLabel: SKLabelNode?
    var scoreLabel: SKLabelNode?
    var victoryLabel: SKLabelNode?
    
    // MARK: Nodes
    var playerNode: PlayerNode!
    var gridNode: GridNode!
    var goalNode: SquareNode!
    
    // MARK: Colliders
    var collisionNodes = [SquareNode]()
    
    override func didMove(to view: SKView) {
        initGame()
    }
    
    func initGame() {
        levels = initLevel(from: "GameLevels", withExtension: "json")
        currentLevelModel = levels[currentLevel]
        
        initGrid()
        initGoal()
        initPlayer()
        initPoints()
        initBlocks()
        initEnemies()
        initMovableNodes()
        addActions()
        createHUD()
    }
    
    func clearGame() {
        collisionNodes = []
        remove(node: gridNode)
        resetPoints()
    }
    
    func nextLevel() {
        if currentLevel < levels.count-1 {
            currentLevel += 1
            clearGame()
            initGame()
        } else {
            victoryLabel?.isHidden = false
        }
    }
}
