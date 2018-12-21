//
//  GameViewController.swift
//  BattleShip macOS
//
//  Created by Christian Muth on 04.12.18.
//  Copyright © 2018 Christian Muth. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    var scene:GameScene? = nil
    let battleShipGame = BattleShipGame(gridSize: kGridSize)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UniversalGame.game.setOrientation(JKOrientation.portrait)
        scene = GameScene(size: UniversalGame.size)
        scene?.gridSize = kGridSize

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true

        // erzeuge ein neues Spiel
        battleShipGame.createGame()
        scene!.showOccupiedFieldsInRowsAndColumns(game: battleShipGame)
        scene!.showShipsInPlayField(game: battleShipGame)
        scene!.showUsedShipsInGame(battleShipGame)
        

    }

}

