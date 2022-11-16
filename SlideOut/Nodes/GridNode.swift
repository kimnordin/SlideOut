//
//  Grid.swift
//  SlideOut
//
//  Created by Kim Nordin on 2021-02-14.
//

import Foundation
import SpriteKit
import GameplayKit

protocol GridDelegate {
    func moveTo(gridPosition: CGPoint)
}

class GridNode: SKSpriteNode {
    var delegate: GridDelegate!
    var grid: Grid!
    var movableNode: SKNode?
    var squareSize: CGFloat!

    convenience init?(grid: Grid, squareSize: CGFloat) {
        guard let texture = GridNode.gridTexture(squareSize: squareSize, x: grid.x, y: grid.y) else {
            return nil
        }
        self.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.isUserInteractionEnabled = true
        self.grid = grid
        self.squareSize = squareSize
    }
    
    class func gridTexture(squareSize: CGFloat, x: Int, y: Int) -> SKTexture? {
        let size = CGSize(width: CGFloat(x)*squareSize+1.0, height: CGFloat(y)*squareSize+1.0)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        
        // Draw horizontal lines
        for i in 0...x {
            let x = CGFloat(i)*squareSize + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        // Draw vertical lines
        for i in 0...y {
            let y = CGFloat(i)*squareSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        
        SKColor.white.setStroke()
        bezierPath.lineWidth = 1.0
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }
    
    /**
     Returns the real position in a grid given a column and row
     - parameter col: The current column position of the Player
     - parameter row: The current row position of the Player
     - returns CGPoint: The position in the grid
     */
    func gridPosition(x: Int, y: Int) -> CGPoint {
        let offset = squareSize / 2.0
        let x = CGFloat(x) * squareSize - (squareSize * CGFloat(grid.x)) / 2.0 + offset
        let y = CGFloat(y) * squareSize - (squareSize * CGFloat(grid.y)) / 2.0 + offset
        return CGPoint(x: x, y: y)
    }
    
    /**
     Returns a new position if it is within the bounds of the grid, given a current position and a direction to move in
     - parameter col: The current column position of the Player
     - parameter row: The current row position of the Player
     - parameter dir: The swiped Direction, indicating where to move
     - returns CGPoint?: The new position to move to if it is within the bounds of the grid
     */
    func positionWithinGrid(x: Int, y: Int, swipeDirection: UISwipeGestureRecognizer.Direction) -> CGPoint? {
        var _x = x
        var _y = y
        switch swipeDirection {
        case .up:
            if y != 0 {
                _y = y - 1
            }
        case .down:
            if y != _y - 1 {
                _y = y + 1
            }
        case .left:
            if x != 0 {
                _x = x - 1
            }
        case .right:
            if x != _x - 1 {
                _x = x + 1
            }
        default: return nil
        }
        return CGPoint(x: _x, y: _y)
    }
}
