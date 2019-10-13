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
    var gamePlaySecuredFieldsLayer : SKTileMapNode!

    var gamePlayFieldPosition = CGPoint.zero
    
    // die Angaben in gamePlayFieldKoordinaten (nicht in Scene Koordinaten)
    var playGameFieldPositionLocal = CGPoint(x: 0, y: 0)
    var playGameFieldRectLocal = CGRect(x: 0, y: 0, width: 0, height: 0)
    var playGameFieldSizeLocal = CGSize(width: 0, height: 0)
    
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
        
        // berechne hier die erforderlichen geometrischen Größen in playGameField - Koordinaten
        playGameFieldPositionLocal = self.convert(gamePlayField.position, to: gamePlayField)

        let lowerLeftGamePlayFieldX = gamePlayField.position.x - gamePlayField.mapSize.width/2
        let lowerLeftGamePlayFieldY = gamePlayField.position.y - gamePlayField.mapSize.height/2
        let lowerLeftGamePlayFielPosition = CGPoint(x: lowerLeftGamePlayFieldX, y: lowerLeftGamePlayFieldY)
        let lowerLeftGamePlayFieldPositionLocal = self.convert(lowerLeftGamePlayFielPosition, to: gamePlayField)
        

        let upperLeftGamePlayFieldX = gamePlayField.position.x - gamePlayField.mapSize.width/2
        let upperLeftGamePlayFieldY = gamePlayField.position.y + gamePlayField.mapSize.height/2
        let upperLeftGamePlayFielPosition = CGPoint(x: upperLeftGamePlayFieldX, y: upperLeftGamePlayFieldY)
        let upperLeftGamePlayFieldPositionLocal = self.convert(upperLeftGamePlayFielPosition, to: gamePlayField)

        let lowerRightGamePlayFieldX = gamePlayField.position.x + gamePlayField.mapSize.width/2
        let lowerRightGamePlayFieldY = gamePlayField.position.y - gamePlayField.mapSize.height/2
        let lowerRightGamePlayFielPosition = CGPoint(x: lowerRightGamePlayFieldX, y: lowerRightGamePlayFieldY)
        let lowerRightGamePlayFieldPositionLocal = self.convert(lowerRightGamePlayFielPosition, to: gamePlayField)

        let upperRightGamePlayFieldX = gamePlayField.position.x + gamePlayField.mapSize.width/2
        let upperRightGamePlayFieldY = gamePlayField.position.y + gamePlayField.mapSize.height/2
        let upperRightGamePlayFieldPosition = CGPoint(x: upperRightGamePlayFieldX, y: upperRightGamePlayFieldY)
        let upperRightGamePlayFieldPositionLocal = self.convert(upperRightGamePlayFieldPosition, to: gamePlayField)
        
        let localWidth = upperRightGamePlayFieldPositionLocal.x - lowerLeftGamePlayFieldPositionLocal.x < 0 ?
            -(upperRightGamePlayFieldPositionLocal.x - lowerLeftGamePlayFieldPositionLocal.x) :
            upperRightGamePlayFieldPositionLocal.x - lowerLeftGamePlayFieldPositionLocal.x

        let localHeight = upperRightGamePlayFieldPositionLocal.y - lowerLeftGamePlayFieldPositionLocal.y < 0 ?
            -(upperRightGamePlayFieldPositionLocal.y - lowerLeftGamePlayFieldPositionLocal.y) :
            upperRightGamePlayFieldPositionLocal.y - lowerLeftGamePlayFieldPositionLocal.y
        
        playGameFieldRectLocal = CGRect(x: lowerLeftGamePlayFieldPositionLocal.x, y: lowerLeftGamePlayFieldPositionLocal.y, width: localWidth, height: localHeight)
        playGameFieldSizeLocal = playGameFieldRectLocal.size

        print("lowerLeft = ",lowerLeftGamePlayFieldPositionLocal,"  uperLeft = ",upperLeftGamePlayFieldPositionLocal,
              "lowerRight = ",lowerRightGamePlayFieldPositionLocal,"  uperRight = ",upperRightGamePlayFieldPositionLocal)
        
        
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
            while gamePlayFieldRect.size.width > UniversalGame.rect.size.width
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

