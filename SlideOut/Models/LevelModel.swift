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
    let player: Player
    let grid: Grid
}

// MARK: - Grid
struct Grid: Codable {
    let squareSize: Double
    let rows, columns: Int
}

// MARK: - Player
struct Player: Codable {
    let size: Int
    var color: String?
    var position: Position
}

// MARK: - Position
struct Position: Codable {
    var row, column: Int
}

typealias Levels = [LevelModel]
