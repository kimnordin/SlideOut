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
    
    override func didMove(to view: SKView) {
        initGame()
    }
    
    func checkTiles(direction: UISwipeGestureRecognizer.Direction, closestCollision: (CGPoint, Int) -> ()) {
        guard let player = playerNode.player else { return }
        
        let blocks = currentLevelModel.blocks ?? []
        var tilePositionDifference = 0
        var gridPositionToMove = CGPoint(x: player.position.x, y: player.position.y)

        switch direction {
        case .up:
            let negSameRowBlocks = blocks.filter({ $0.position.x == player.position.x && $0.position.y > player.position.y})
            if let closestValue = negSameRowBlocks.min { abs($0.position.y - player.position.y) < abs($1.position.y - player.position.y) } {
                gridPositionToMove = CGPoint(x: player.position.x, y: closestValue.position.y-1)
                tilePositionDifference = closestValue.position.y - player.position.y

                closestCollision(gridPositionToMove, tilePositionDifference)
            } else {
                gridPositionToMove = CGPoint(x: player.position.x, y: currentLevelModel.grid.y)
                tilePositionDifference = currentLevelModel.grid.y - player.position.y
                
                closestCollision(gridPositionToMove, tilePositionDifference)
            }
        case .down:
            let negSameRowBlocks = blocks.filter({ $0.position.x == player.position.x && $0.position.y < player.position.y})
            if let closestValue = negSameRowBlocks.min { abs($0.position.y - player.position.y) < abs($1.position.y - player.position.y) } {
                gridPositionToMove = CGPoint(x: player.position.x, y: closestValue.position.y+1)
                tilePositionDifference = player.position.y - closestValue.position.y

                closestCollision(gridPositionToMove, tilePositionDifference)
            } else {
                gridPositionToMove = CGPoint(x: player.position.x, y: -1)
                tilePositionDifference = player.position.y
                
                closestCollision(gridPositionToMove, tilePositionDifference)
            }
        case .left:
            let negSameRowBlocks = blocks.filter({ $0.position.y == player.position.y && $0.position.x < player.position.x})
            if let closestValue = negSameRowBlocks.min { abs($0.position.x - player.position.x) < abs($1.position.x - player.position.x) } {
                gridPositionToMove = CGPoint(x: closestValue.position.x+1, y: player.position.y)
                tilePositionDifference = player.position.x - closestValue.position.x
                
                closestCollision(gridPositionToMove, tilePositionDifference)
            } else {
                gridPositionToMove = CGPoint(x: -1, y: player.position.y)
                tilePositionDifference = player.position.x
                
                closestCollision(gridPositionToMove, tilePositionDifference)
            }
        case .right:
            let negSameRowBlocks = blocks.filter({ $0.position.y == player.position.y && $0.position.x > player.position.x})
            if let closestValue = negSameRowBlocks.min { abs($0.position.x - player.position.x) < abs($1.position.x - player.position.x) } {
                gridPositionToMove = CGPoint(x: closestValue.position.x-1, y: player.position.y)
                tilePositionDifference = closestValue.position.x - player.position.x
                
                closestCollision(gridPositionToMove, tilePositionDifference)
            } else {
                gridPositionToMove = CGPoint(x: currentLevelModel.grid.x, y: player.position.y)
                tilePositionDifference = currentLevelModel.grid.x - player.position.x
                
                closestCollision(gridPositionToMove, tilePositionDifference)
            }
        default: return
        }
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
    
    func moveTo(gridPosition: CGPoint) {
        toPosition = gridPosition
    }
}
