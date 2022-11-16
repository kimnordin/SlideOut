//
//  LevelModel.swift
//  SlideOut
//
//  Created by Kim Nordin on 2022-10-02.
//
//   let level = try? newJSONDecoder().decode(Levels.self, from: jsonData)

import Foundation

// MARK: - LevelModel
struct LevelModel: Codable {
    let name: String
    let squareSize: Int
    let player: Square
    let goal: Square
    let grid: Grid
    let blocks: [Square]?
    let movableBlocks: [Square]?
}

// MARK: - Grid
struct Grid: Codable {
    let x, y: Int
}

// MARK: - Square
struct Square: Codable {
    var color: String?
    var position: Position
}

// MARK: - Position
struct Position: Codable {
    var x, y: Int
}

typealias Levels = [LevelModel]
