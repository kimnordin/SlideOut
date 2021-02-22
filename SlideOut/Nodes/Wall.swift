//
//  Wall.swift
//  Slider
//
//  Created by Kim Nordin on 2020-09-06.
//  Copyright © 2020 Kim Nordin. All rights reserved.
//

import SpriteKit
import GameplayKit

class Wall: SKSpriteNode {
    
    var direction: Direction
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.direction = .right
        super.init(texture: texture, color: color, size: size)
    }
    
    
    init?(color: UIColor, direction: Direction) {
        self.direction = direction
        let color = color
        var size = CGSize(width: 0, height: 0)
        switch direction {
        case .right, .left:
            size = CGSize(width: 10, height: 414)
        case .up, .down:
            size = CGSize(width: 736, height: 10)
        default: return nil
        }
        self.init(color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
