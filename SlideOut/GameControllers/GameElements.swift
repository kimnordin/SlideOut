//
//  GameElements.swift
//  DodgeFall
//
//  Created by Kim Nordin on 2021-02-02.
//

import GameplayKit
import SpriteKit

enum Enemies: Int {
    case slow
    case medium
    case fast
}

extension GameScene {
    
    func createHUD() {
        scoreLabel = self.childNode(withName: "score") as? SKLabelNode
        
        currentScore = 0
    }
    
    
    func addPlayer(){
        // Physics
        player = Player(color: .red, size: CGSize(width: 50, height: 50))
        print("Player Created")
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.linearDamping = 0
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = enemyCategory | wallCategory
        player.physicsBody?.affectedByGravity = false
        
        player.position = CGPoint(x: self.size.width/2, y: 150)
        
        self.addChild(player)
        
    }
    
    func addEnemy(type: Enemies, forTrack track: Int) -> SKShapeNode? {
        let enemySprite = SKShapeNode()
        enemySprite.name = "ENEMY"
        
        
        switch type {
        case .slow:
            enemySprite.fillColor = UIColor(red: 0.4431, green: 0.5529, blue: 0.7451, alpha: 1)
        case .medium:
            enemySprite.fillColor = UIColor(red: 0.7804, green: 0.4039, blue: 0.4039, alpha: 1)
        case .fast:
            enemySprite.fillColor = UIColor(red: 0.7804, green: 0.6392, blue: 0.4039, alpha: 1)
        }
        
        enemySprite.physicsBody = SKPhysicsBody(edgeLoopFrom: enemySprite.path!)
        enemySprite.physicsBody?.categoryBitMask = enemyCategory
//        enemySprite.physicsBody?.velocity = CGVector(dx: 0, dy: -velocityArray[track])
        
        return enemySprite
    }
}
