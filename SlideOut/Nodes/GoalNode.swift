//
//  GoalNode.swift
//  SlideOut
//
//  Created by Kim Nordin on 2022-10-02.
//

import SpriteKit
import GameplayKit

class GoalNode: SKSpriteNode {
    var goal: Square!
    
    init(goal: Square, size: CGSize) {
        self.goal = goal
        super.init(texture: nil, color: UIColor().named(goal.color ?? "green") ?? .green, size: size)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
