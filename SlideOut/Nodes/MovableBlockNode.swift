//
//  MovableBlockNode.swift
//  SlideOut
//
//  Created by Kim Nordin on 2022-10-02.
//

import SpriteKit
import GameplayKit

class MovableBlockNode: SKSpriteNode {
    var movableBlock: Square!
    
    init(movableBlock: Square, size: CGSize) {
        self.movableBlock = movableBlock
        super.init(texture: nil, color: UIColor().named(movableBlock.color ?? "orange") ?? .orange, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
