//
//  GridNode.swift
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
        let texture = GridNode.gridTexture(squareSize: squareSize, width: grid.width, height: grid.height)
        let displaySize = UIScreen.main.bounds
        self.init(texture: texture, color: SKColor.clear, size: texture?.size() ?? CGSize(width: displaySize.width, height: displaySize.height))
        self.isUserInteractionEnabled = true
        self.grid = grid
    }
}

extension GridNode {
    /**
     Draws a grid with lines.
     - parameter squareSize: The size of the squares in the grid.
     - parameter width: The width of the grid.
     - parameter height: The height of the grid.
     - returns: An image of the grid.
     */
    class func gridTexture(squareSize: CGFloat, width: Int, height: Int) -> SKTexture? {
        let size = CGSize(width: CGFloat(width)*squareSize+1.0, height: CGFloat(height)*squareSize+1.0)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        
        // Draw horizontal lines
        for i in 0...width {
            let width = CGFloat(i)*squareSize + offset
            bezierPath.move(to: CGPoint(x: width, y: 0))
            bezierPath.addLine(to: CGPoint(x: width, y: size.height))
        }
        // Draw vertical lines
        for i in 0...height {
            let height = CGFloat(i)*squareSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: height))
            bezierPath.addLine(to: CGPoint(x: size.width, y: height))
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
     - parameter x: The x position in the grid.
     - parameter y: The y position in the grid.
     - returns: The real position in the grid.
     */
    func gridPosition(x: Int, y: Int) -> CGPoint {
        let offset = grid.squareSize / 2.0
        let x = CGFloat(x) * grid.squareSize - (grid.squareSize * CGFloat(grid.width)) / 2.0 + offset
        let y = CGFloat(y) * grid.squareSize - (grid.squareSize * CGFloat(grid.height)) / 2.0 + offset
        return CGPoint(x: x, y: y)
    }
}
