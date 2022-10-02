//
//  Player.swift
//  Slider
//
//  Created by Kim Nordin on 2020-09-06.
//  Copyright © 2020 Kim Nordin. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayerNode: SKSpriteNode {
    var player: Player!
    
    init(player: Player) {
        self.player = player
        super.init(texture: nil, color: UIColor().named(player.color ?? "red") ?? .red, size: CGSize(width: player.size, height: player.size))
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
