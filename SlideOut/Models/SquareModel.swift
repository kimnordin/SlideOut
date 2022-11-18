//
//  SquareModel.swift
//  SlideOut
//
//  Created by Kim Nordin on 2022-11-17.
//

import Foundation

// MARK: - Square

/**
 A Square model used for objects in the grid.
 */
struct Square: Codable {
    var color: String?
    var position: Position
    var type: SquareType
}
