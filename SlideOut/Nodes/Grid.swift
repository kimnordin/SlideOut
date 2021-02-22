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
    func moveTo(squarePoint: CGPoint)
}

class Grid: SKSpriteNode {
    weak var delegate: GridDelegate!
    var rows: Int!
    var cols: Int!
    var blockSize: CGFloat!
    var movableNode: SKNode?
    var currentDirection: Direction?
    var playerShouldMove: Bool = true

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
        return CGPoint(x:x, y:y)
    }
    
    func isValidGridPosition(col: CGFloat, row: CGFloat, dir: Direction) -> Bool {
        switch dir {
        case .up:
            if col != 0.0 {
                return true
            }
        case .down:
            if col != CGFloat(cols-1) {
                return true
            }
        case .left:
            if row != 0.0 {
                return true
            }
        case .right:
            if row != CGFloat(rows-1) {
                return true
            }
        default: return false
        }
        return false
    }
    
    func moveToNewGridPositionFrom(col: CGFloat, row: CGFloat, dir: Direction) -> CGPoint? {
        var x = row
        var y = col
        var move: Bool = false
        var newDir: Direction? = nil
        switch dir {
        case .up:
            if y != 0.0 {
                y = y-1
                move = true
                newDir = .up
            }
        case .down:
            if y != CGFloat(cols-1) {
                y = y+1
                move = true
                newDir = .down
            }
        case .left:
            if x != 0.0 {
                x = x-1
                move = true
                newDir = .left
            }
        case .right:
            if x != CGFloat(rows-1) {
                x = x+1
                move = true
                newDir = .right
            }
        default: return nil
        }
        currentDirection = newDir
        playerShouldMove = move
        return CGPoint(x: x, y: y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in:self)
            let node = atPoint(position)
            if node != self {
                if node is Player {
                    node.removeAllActions()
                    currentDirection = nil
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
                        currentDirection = .up
                    case (0,-1):
                        currentDirection = .down
                    case (-1,0):
                        currentDirection = .left
                    case (1,0):
                        currentDirection = .right
                    case (1,1):
                        currentDirection = .upright
                    case (-1,-1):
                        currentDirection = .downleft
                    case (-1,1):
                        currentDirection = .upleft
                    case (1,-1):
                        currentDirection = .downright
                    default:
                        currentDirection = nil
                        break
                    }
                }
                else {
                    player.color = .red
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, movableNode != nil {
            if let player = movableNode as? Player {
                player.color = .red
                
                print("currentDirection: ", currentDirection)
                print("playerShouldMove: ", playerShouldMove)
                if currentDirection != nil {
                    playerShouldMove = isValidGridPosition(col: player.col, row: player.row, dir: currentDirection!)
                    while playerShouldMove {
                        if let squareInGrid = moveToNewGridPositionFrom(col: player.col, row: player.row, dir: currentDirection!) {
                            let squarePosition = self.gridPosition(row: Int(squareInGrid.x), col: Int(squareInGrid.y))
                            player.row = squareInGrid.x
                            player.col = squareInGrid.y
                            
                            print("player row x: ", player.row)
                            print("player col y: ", player.col)
                            self.delegate?.moveTo(squarePoint: squarePosition)
                        }
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
