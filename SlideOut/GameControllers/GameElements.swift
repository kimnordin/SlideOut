//
//  GameElements.swift
//  DodgeFall
//
//  Created by Kim Nordin on 2021-02-02.
//

import GameplayKit
import SpriteKit

extension GameScene {
    func initLevel(from resource: String, withExtension: String) -> Levels? {
        guard let path = Bundle.main.url(forResource: resource, withExtension: withExtension) else { return nil }
        do {
            let data = try Data(contentsOf: path)
            let levels = try? JSONDecoder().decode(Levels.self, from: data)
            print("levels: ", levels)
            return levels
        } catch {
            print(error)
            return nil
        }
    }
    
    func initGrid(from level: LevelModel) {
        let grid = level.grid
        gridNode = GridNode(grid: grid)
        
        gridNode.delegate = self
        gridNode.position = CGPoint (x:frame.midX, y:frame.midY)
        addChild(gridNode)
    }
    
    func initPlayer(from level: LevelModel) {
        let player = level.player
        playerNode = PlayerNode(player: player)
        
        playerNode.setScale(1.0)
        playerNode.position = gridNode.gridPosition(row: player.position.row, col: player.position.column)
        gridNode.addChild(playerNode)
    }
    
    func createHUD(from level: LevelModel) {
        levelLabel = self.childNode(withName: "level") as? SKLabelNode
        levelLabel?.text = level.name
    }
}
