//
//  SquareNode.swift
//  SlideOut
//
//  Created by Kim Nordin on 2022-11-19.
//

import Foundation
import SpriteKit

class SquareNode: SKSpriteNode {
    var square: Square!
    
    init(square: Square, size: CGSize) {
        self.square = square
        super.init(texture: nil, color: UIColor().named(square.color ?? "red") ?? .red, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
