//
//  Player.swift
//  Slider
//
//  Created by Kim Nordin on 2020-09-06.
//  Copyright © 2020 Kim Nordin. All rights reserved.
//

import SpriteKit
import GameplayKit

class Player: SKSpriteNode {
    
    var currentGridPosition = CGPoint(x: 0, y: 0)
    
    var direction: Direction? {
        didSet {
            switch direction {
            case .up:
                row = row + 1
            case .down:
                row = row - 1
            case .left:
                col = col - 1
            case .right:
                col = col + 1
            default: break
            }
        }
    }
    var col: CGFloat = 0.0
    var row: CGFloat = 0.0
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    init(imageNamed: String) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: imageNamed)
        let size = CGSize(width: 50, height: 50)
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
