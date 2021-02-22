//
//  GameScene.swift
//  DodgeFall
//
//  Created by Kim Nordin on 2021-02-02.
//

import SpriteKit
import GameplayKit

let gameTime = 60.0

class GameScene: SKScene, SKPhysicsContactDelegate, GridDelegate {
    
    //MARK: Game Properties
    // MARK:-
    
    // MARK: HUD
    var scoreLabel: SKLabelNode?
    var currentScore: Int = 0 {
        didSet {
            self.scoreLabel?.text = "SCORE: \(self.currentScore)"
        }
    }
    
    // MARK: Nodes
    var player = Player(color: .red, size: CGSize(width: 50, height: 50))
    var block = Block(color: .yellow, size: CGSize(width: 50, height: 50))
    
    // MARK: Sound
    let moveSound = SKAction.playSoundFileNamed("move.wav", waitForCompletion: false)
    var backgroundNoise: SKAudioNode!
    
    // MARK: Arrays
    var blocks = [Block]()
    var walls = [Wall]()
    
    //MARK: Grid
    let grid = Grid(blockSize: 50.0, rows: 12, cols: 8)
    var toPosition: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {

            
            let moveAction = SKAction.move(to: toPosition, duration: 0.2)
            player.run(moveAction)
            player.currentGridPosition = toPosition
        }
    }
    
    // MARK: Collision Cateogires
    let playerCategory: UInt32 = 0x1 << 0 //1
    let wallCategory: UInt32 = 0x1 << 1 //2
    let enemyCategory: UInt32 = 0x1 << 2 //4
    let powerUpCategory: UInt32 = 0x1 << 3 //8
    
    var playerVelocity = CGVector(dx: 0, dy: 0)
    var movableObject = false
    
    override func didMove(to view: SKView) {
        
        if let grid = grid {
            grid.delegate = self
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            addChild(grid)
            
            let gamePiece = player
            gamePiece.setScale(1.0)
            player.row = 1
            player.col = 1
            gamePiece.position = grid.gridPosition(row: 1, col: 1)
            grid.addChild(gamePiece)
        }
        
        self.physicsWorld.contactDelegate = self
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
        
        if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == enemyCategory {
            self.run(SKAction.playSoundFileNamed("fail.wav", waitForCompletion: true))
//            movePlayerToStart()
            if let otherNode = otherBody.node {
                removeEnemy(node: otherNode)
            }
        }
    }
    
    func moveTo(gridPosition: CGPoint) {
        toPosition = gridPosition
        print("move to: ", gridPosition)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
