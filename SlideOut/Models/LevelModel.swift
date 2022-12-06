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
    let player: Square
    let goal: Square
    let grid: Grid
    let blocks: [Square]?
    let enemies: [Square]?
    let movableBlocks: [Square]?
}

enum SquareType: String, Codable {
    case player, goal, block, enemy, movableBlock
}

typealias Levels = [LevelModel]
