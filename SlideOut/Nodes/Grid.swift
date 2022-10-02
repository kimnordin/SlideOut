//
//  Grid.swift
//  SlideOut
//
//  Created by Kim Nordin on 2021-02-14.
//

import Foundation
import SpriteKit
import GameplayKit

protocol GridDelegate: class {
    func moveTo(gridPosition: CGPoint)
}

class Grid: SKSpriteNode {
    weak var delegate: GridDelegate!
    var rows: Int!
    var cols: Int!
    var blockSize: CGFloat!
    var movableNode: SKNode?
    var dir: Direction?

    convenience init?(blockSize: CGFloat, rows: Int, cols: Int) {
        guard let texture = Grid.gridTexture(blockSize: blockSize, rows: rows, cols: cols) else {
            return nil
        }
        self.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.isUserInteractionEnabled = true
        self.blockSize = blockSize
        self.rows = rows
        self.cols = cols
    }

    class func gridTexture(blockSize: CGFloat, rows: Int, cols: Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(rows)*blockSize+1.0, height: CGFloat(cols)*blockSize+1.0)
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        // Draw vertical lines
        for i in 0...cols {
            let y = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        // Draw horizontal lines
        for i in 0...rows {
            let x = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        SKColor.white.setStroke()
        bezierPath.lineWidth = 1.0
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return SKTexture(image: image!)
    }

    func gridPosition(row: Int, col: Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        let x = CGFloat(row) * blockSize - (blockSize * CGFloat(rows)) / 2.0 + offset
        let y = CGFloat(cols - col - 1) * blockSize - (blockSize * CGFloat(cols)) / 2.0 + offset
        return CGPoint(x: x, y: y)
    }
    
    /**
     Returns a new position if it is within the bounds of the grid, given a current position and a direction to move in
     - parameter col: The current column position of the Player
     - parameter row: The current row position of the Player
     - parameter dir: The swiped Direction, indicating where to move
     - returns CGPoint?: The new position to move to if it is within the bounds of the grid
     */
    func positionWithinGrid(col: CGFloat, row: CGFloat, dir: Direction) -> CGPoint? {
        var x = row
        var y = col
        switch dir {
        case .up:
            if y != 0.0 {
                y = y-1
            }
        case .down:
            if y != col-1 {
                y = y+1
            }
        case .left:
            if x != 0.0 {
                x = x-1
            }
        case .right:
            if x != row-1 {
                x = x+1
            }
        default: return nil
        }
        
        return CGPoint(x: x, y: y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in:self)
            let node = atPoint(position)
            if node != self {
                if node is Player {
                    node.removeAllActions()
                    dir = nil
                    movableNode = node
                }
            }
            else {
                let x = size.width / 2 + position.x
                let y = size.height / 2 - position.y
                let row = Int(floor(x / blockSize))
                let col = Int(floor(y / blockSize))
                print("\(row) \(col)")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, movableNode != nil {
            
            let xTouch = touch.location(in: movableNode!).x
            let yTouch = touch.location(in: movableNode!).y
            
            let distance = sqrt(xTouch*xTouch+yTouch*yTouch)
            
            if let player = movableNode as? Player {
                
                // Check if the user's finger moved a minimum distance
                if distance > 30 {
                    player.color = .yellow
                    // Determine the direction of the swipe
                    let x = abs(xTouch/distance) > 0.4 ? Int(sign(Float(xTouch))) : 0
                    let y = abs(yTouch/distance) > 0.4 ? Int(sign(Float(yTouch))) : 0
                    
                    switch (x,y) {
                    case (0,1):
                        dir = .up
                    case (0,-1):
                        dir = .down
                    case (-1,0):
                        dir = .left
                    case (1,0):
                        dir = .right
                    case (1,1):
                        dir = .upright
                    case (-1,-1):
                        dir = .downleft
                    case (-1,1):
                        dir = .upleft
                    case (1,-1):
                        dir = .downright
                    default:
                        dir = nil
                        break
                    }
                    print("Direction: ", dir)
                } else {
                    dir = nil
                    player.color = .red
                    print("Distance too small")
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, movableNode != nil {
            if let player = movableNode as? Player {
                player.color = .red
                if dir != nil {
                    if let position = positionWithinGrid(col: player.col, row: player.row, dir: dir!) {
                        player.row = position.x
                        player.col = position.y
                        let newPosition = self.gridPosition(row: Int(position.x), col: Int(position.y))
                        self.delegate?.moveTo(gridPosition: newPosition)
                    }
                }
            }
            movableNode = nil
            print("touch ended")
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            movableNode = nil
            print("touch cancelled")
        }
    }

}
