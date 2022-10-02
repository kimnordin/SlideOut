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
    var dir: Direction?
    var squareSize: CGFloat!

    convenience init?(grid: Grid, squareSize: CGFloat) {
        guard let texture = GridNode.gridTexture(squareSize: squareSize, rows: grid.rows, cols: grid.columns) else {
            return nil
        }
        self.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.isUserInteractionEnabled = true
        self.grid = grid
        self.squareSize = squareSize
    }

    class func gridTexture(squareSize: CGFloat, rows: Int, cols: Int) -> SKTexture? {
        let size = CGSize(width: CGFloat(cols)*squareSize+1.0, height: CGFloat(rows)*squareSize+1.0)
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        // Draw vertical lines
        for i in 0...rows {
            let y = CGFloat(i)*squareSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        // Draw horizontal lines
        for i in 0...cols {
            let x = CGFloat(i)*squareSize + offset
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
        let offset = squareSize / 2.0
        let x = CGFloat(grid.columns - col - 1) * squareSize - (squareSize * CGFloat(grid.columns)) / 2.0 + offset
        let y = CGFloat(row) * squareSize - (squareSize * CGFloat(grid.rows)) / 2.0 + offset
        return CGPoint(x: x, y: y)
    }
    
    /**
     Returns a new position if it is within the bounds of the grid, given a current position and a direction to move in
     - parameter col: The current column position of the Player
     - parameter row: The current row position of the Player
     - parameter dir: The swiped Direction, indicating where to move
     - returns CGPoint?: The new position to move to if it is within the bounds of the grid
     */
    func positionWithinGrid(col: Int, row: Int, dir: Direction) -> CGPoint? {
        var x = row
        var y = col
        switch dir {
        case .up:
            if y != 0 {
                y = y-1
            }
        case .down:
            if y != col-1 {
                y = y+1
            }
        case .left:
            if x != 0 {
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
}
