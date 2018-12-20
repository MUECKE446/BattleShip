//
//  GameScene.swift
//  BattleShip Shared
//
//  Created by Christian Muth on 04.12.18.
//  Copyright © 2018 Christian Muth. All rights reserved.
//

import SpriteKit

class GameScene : SKScene {
    
    var viewController : GameViewController!
    
    let playFieldTileSet = SKTileSet(named: "PlayField")

    var gamePlayField : SKTileMapNode!
    var gamePlayFieldLayer1 : SKTileMapNode!
    var gamePlayFieldLayer2 : SKTileMapNode!

    var gamePlayFieldPosition = CGPoint.zero
    
    var gridSize = 0

    var securedFields:[FieldIndex] = []
    
    // Aktions
    var sequenceAction = SKAction()
    
    let scaleToSmall = CGFloat(0.5)
    
    #if os(iOS)
    var panGestureRecognizer = UIPanGestureRecognizer()
    #endif
        
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        #if os(iOS)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom(recognizer:)))
        self.view!.addGestureRecognizer(panGestureRecognizer)

        // mehrere Finger will ich ausschließen
        self.view?.isMultipleTouchEnabled = false
        #endif
        
        backgroundColor = SKColor.gray
        
        createStartScene()
    }
    
    func createStartScene() {
        //let playFieldTileSet = SKTileSet(named: "PlayField")
        gamePlayField = SKTileMapNode(tileSet: playFieldTileSet!, columns: gridSize, rows: gridSize, tileSize: CGSize(width: 80, height: 80))
        gamePlayField.name = "PlayField"
        let tileGroups = playFieldTileSet!.tileGroups
        let emptyFieldTile = tileGroups.first(where: {$0.name == "EmptyField"})
//        let waterTile = tileGroups.first(where: {$0.name == "Water"})
//        let shipMiddleTile = tileGroups.first(where: {$0.name == "ShipMiddle"})
//        let shipLeftTile = tileGroups.first(where: {$0.name == "ShipLeft"})
//        let shipRightTile = tileGroups.first(where: {$0.name == "ShipRight"})
//        let shipUpTile = tileGroups.first(where: {$0.name == "ShipUp"})
//        let shipDownTile = tileGroups.first(where: {$0.name == "ShipDown"})
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                gamePlayField.setTileGroup(emptyFieldTile, forColumn: col, row: row)
            }
        }
        gamePlayField.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        addNumberLabels()
        calculateGamePlayFieldPosition()
        gamePlayField.position = gamePlayFieldPosition
        
        addChild(gamePlayField)
    }
    
    func calculateGamePlayFieldPosition() {
        let sceneCenter = CGPoint(x: size.width/2, y: size.height/2)
        var gamePlayFieldRect = gamePlayField.calculateAccumulatedFrame()
        
        #if os(iOS)
        // Design für iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            gamePlayFieldPosition = CGPoint(x: sceneCenter.x + gamePlayField.tileSize.width/2, y: sceneCenter.y + gamePlayFieldRect.size.height/2 - gamePlayField.tileSize.height - 20)
        }
        
        // Design für iPhone
        if UIDevice.current.userInterfaceIdiom == .phone {
            var scaleFactor:CGFloat = 1.0
            while gamePlayFieldRect.size.width > JKGame.rect.size.width
            {
                scaleFactor -= 0.075
                gamePlayField.setScale(scaleFactor)
                gamePlayFieldRect = gamePlayField.calculateAccumulatedFrame()
            }
            gamePlayFieldPosition = CGPoint(x: sceneCenter.x + gamePlayField.tileSize.width/2, y: sceneCenter.y + gamePlayFieldRect.size.height/2 - gamePlayField.tileSize.height - 20)
        }
        #endif
        
        #if os(OSX)
        gamePlayFieldPosition = CGPoint(x: sceneCenter.x + gamePlayField.tileSize.width/2, y: sceneCenter.y + gamePlayFieldRect.size.height/2 - gamePlayField.tileSize.height - 20)
        #endif

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

