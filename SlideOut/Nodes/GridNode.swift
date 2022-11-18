//
//  Grid.swift
//  SlideOut
//
//  Created by Kim Nordin on 2021-02-14.
//

import Foundation
import SpriteKit
import GameplayKit

class GridNode: SKSpriteNode {
    var grid: Grid!

    convenience init(grid: Grid, squareSize: CGFloat) {
        let texture = GridNode.gridTexture(squareSize: squareSize, x: grid.width, y: grid.height)
        let displaySize = UIScreen.main.bounds
        self.init(texture: texture, color: SKColor.clear, size: texture?.size() ?? CGSize(width: displaySize.width, height: displaySize.height))
        self.isUserInteractionEnabled = true
        self.grid = grid
    }
}

extension GridNode {
    /**
     Draws a Grid with lines.
     - parameter squareSize: The size of the squares in the grid
     - parameter x: The width of the grid
     - parameter y: The height of the grid
     - returns SKTexture: An image of the grid
     */
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
     Returns the real position in a grid given an x and y position.
     - parameter x: The current x position of the Player
     - parameter y: The current y position of the Player
     - returns CGPoint: The real position in the grid
     */
    func gridPosition(x: Int, y: Int) -> CGPoint {
        let offset = grid.squareSize / 2.0
        let x = CGFloat(x) * grid.squareSize - (grid.squareSize * CGFloat(grid.width)) / 2.0 + offset
        let y = CGFloat(y) * grid.squareSize - (grid.squareSize * CGFloat(grid.height)) / 2.0 + offset
        return CGPoint(x: x, y: y)
    }
}
