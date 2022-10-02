//
//  GameScene.swift
//  DodgeFall
//
//  Created by Kim Nordin on 2021-02-02.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, GridDelegate {
    
    //MARK: Game Properties
    private var levels: Levels!
    private var currentLevelModel: LevelModel!
    var currentLevel = 2
    
    // MARK: HUD
    var levelLabel: SKLabelNode?
    
    // MARK: Nodes
    var playerNode: PlayerNode!
    var gridNode: GridNode!
    var block = Block(color: .yellow, size: CGSize(width: 50, height: 50))
    
    // MARK: Sound
    let moveSound = SKAction.playSoundFileNamed("move.wav", waitForCompletion: false)
    var backgroundNoise: SKAudioNode!
    
    // MARK: Arrays
    var blocks = [Block]()
    
    //MARK: Grid
    private var toPosition: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            let moveAction = SKAction.move(to: toPosition, duration: 0.2)
            playerNode.run(moveAction)
        }
    }
    
    // MARK: Collision Cateogires
    private let playerCategory: UInt32 = 0x1 << 0 //1
    private let wallCategory: UInt32 = 0x1 << 1 //2
    private let enemyCategory: UInt32 = 0x1 << 2 //4
    private let powerUpCategory: UInt32 = 0x1 << 3 //8
    
    override func didMove(to view: SKView) {
        levels = initLevel(from: "GameLevels", withExtension: "json")
        currentLevelModel = levels[currentLevel]
        
        initGrid(from: currentLevelModel)
        initPlayer(from: currentLevelModel)
        createHUD(from: currentLevelModel)
    }
    
    func moveTo(gridPosition: CGPoint) {
        toPosition = gridPosition
        print("move to: ", gridPosition)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
