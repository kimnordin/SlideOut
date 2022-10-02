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
    var currentLevelModel: LevelModel!
    var currentLevel = 0
    
    // MARK: HUD
    var levelLabel: SKLabelNode?
    
    // MARK: Nodes
    var playerNode: PlayerNode!
    var gridNode: GridNode!
    var goalNode: GoalNode!
    var movableBlockNodes = [MovableBlockNode]()
    
    // MARK: Sound
    let moveSound = SKAction.playSoundFileNamed("move.wav", waitForCompletion: false)
    var backgroundNoise: SKAudioNode!
    
    //MARK: Grid
    private var toPosition: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            let moveAction = SKAction.move(to: toPosition, duration: 0.2)
            playerNode.run(moveAction)
        }
    }
    
    // MARK: Collision Categories
    let playerCategory: UInt32 = 0x1 << 0 //1
    let goalCategory: UInt32 = 0x1 << 1 //2
    let blockCategory: UInt32 = 0x1 << 2 //4
    let movableBlockCategory: UInt32 = 0x1 << 3 //8
    
    override func didMove(to view: SKView) {
        initGame()
        
        self.physicsWorld.contactDelegate = self
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
        remove(node: gridNode)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var playerBody: SKPhysicsBody
        var otherBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            playerBody = contact.bodyA
            otherBody = contact.bodyB
        }
        else {
            playerBody = contact.bodyB
            otherBody = contact.bodyA
        }

        if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == goalCategory {
            currentLevel += 1
            clearGame()
            initGame()
        }
        
        if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == blockCategory {
            if let player = playerBody.node as? PlayerNode,
                let block = otherBody.node as? BlockNode  {
                switch player.direction {
                case UISwipeGestureRecognizer.Direction.up:
                    if player.position.y < block.position.y && player.position.x < block.position.x + 2 && player.position.x > block.position.x - 2 {
                        stopPlayer(player.direction)
                    }
                case UISwipeGestureRecognizer.Direction.down:
                    if player.position.y > block.position.y && player.position.x < block.position.x + 2 && player.position.x > block.position.x - 2 {
                        stopPlayer(player.direction)
                    }
                case UISwipeGestureRecognizer.Direction.left:
                    if player.position.x > block.position.x && player.position.y < block.position.y + 2 && player.position.y > block.position.y - 2 {
                        stopPlayer(player.direction)
                    }
                case UISwipeGestureRecognizer.Direction.right:
                    if player.position.x < block.position.x && player.position.y < block.position.y + 2 && player.position.y > block.position.y - 2 {
                        stopPlayer(player.direction)
                    }
                default: return
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if playerNode.position.y > gridNode.size.height / 2 - playerNode.size.height / 2 || playerNode.position.y < -gridNode.size.height / 2 + playerNode.size.height/2
        || playerNode.position.x > gridNode.size.width / 2 - playerNode.size.width / 2 || playerNode.position.x < -gridNode.size.width / 2 + playerNode.size.width / 2 {
            movePlayerToStart()
            moveMovableBlocksToStart()
        }
    }
    
    func moveTo(gridPosition: CGPoint) {
        toPosition = gridPosition
    }
}
