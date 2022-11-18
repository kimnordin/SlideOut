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
    
    // MARK: HUD
    var levelLabel: SKLabelNode?
    
    // MARK: Nodes
    var playerNode: PlayerNode!
    var gridNode: GridNode!
    var goalNode: GoalNode!
    var victoryDisplayNode: SKLabelNode?
    var allBlocks = [Square]()
    
    override func didMove(to view: SKView) {
        initGame()
    }
    
    func initGame() {
        levels = initLevel(from: "GameLevels", withExtension: "json")
        currentLevelModel = levels[currentLevel]
        
        initGrid()
        initGoal()
        initPlayer()
        initBlocks()
        initMovableBlocks()
        addActions()
        createHUD()
    }
    
    func clearGame() {
        allBlocks = []
        remove(node: gridNode)
    }
    
    func nextLevel() {
        if currentLevel < levels.count-1 {
            currentLevel += 1
            clearGame()
            initGame()
        } else {
            victoryDisplayNode?.isHidden = false
        }
    }
}
