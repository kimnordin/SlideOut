//
//  Block.swift
//  Slider
//
//  Created by Kim Nordin on 2020-09-06.
//  Copyright © 2020 Kim Nordin. All rights reserved.
//

import SpriteKit
import GameplayKit

class BlockNode: SKSpriteNode {
    var block: Square!
    
    init(block: Square, size: CGSize) {
        self.block = block
        super.init(texture: nil, color: UIColor().named(block.color ?? "red") ?? .red, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
