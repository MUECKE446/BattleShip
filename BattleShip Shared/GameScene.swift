//
//  GameScene.swift
//  BattleShip Shared
//
//  Created by Christian Muth on 04.12.18.
//  Copyright © 2018 Christian Muth. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
    var sceneCenter = CGPoint.zero
    
    // erzeuge das Gitter, indem gespielt wird und platziere es bei origin
    var playField = GameScene.createPlayField(gridSize: kGridSize, withNumberLabels: true)
    
    // Aktions
    var sequenceAction = SKAction()
    
    let scaleToSmall = CGFloat(0.5)
    
    #if os(iOS)
    var panGestureRecognizer = UIPanGestureRecognizer()
    #endif
    

    
    // ein internes Abbild des Spielfeldes; unbelegtes Feld = false, belegtes Feld = true
    var blockGameField = Array(repeating: Array(repeating: false, count: kGridSize), count: kGridSize)
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
//        #if os(iOS)
//        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom(recognizer:)))
//        self.view!.addGestureRecognizer(panGestureRecognizer)
//
//        // mehrere Finger will ich ausschließen
//        self.view?.isMultipleTouchEnabled = false
//        #endif
        
        backgroundColor = SKColor.gray
        
        createStartScene()
    }
    
    func createStartScene() {
        // das ist der Mittelpunkt der Scene
        sceneCenter = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        #if os(iOS)
        // Design für iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            let playFieldRect = playField.calculateAccumulatedFrame()
            playField.position = CGPoint(x: sceneCenter.x-playFieldRect.size.width/2-playFieldRect.origin.x, y: sceneCenter.y-playFieldRect.size.height/2-playFieldRect.origin.y)
        }

        // Design für iPhone
        if UIDevice.current.userInterfaceIdiom == .phone {
            var playFieldRect = playField.calculateAccumulatedFrame()
            if playFieldRect.size.width > JKGame.rect.size.width {
                let scaleFactor = JKGame.rect.size.width/playFieldRect.size.width
                playField.setScale(scaleFactor)
                playFieldRect = playField.calculateAccumulatedFrame()
            }
            playField.position = CGPoint(x: sceneCenter.x-playFieldRect.size.width/2-playFieldRect.origin.x, y: sceneCenter.y-playFieldRect.size.height/2-playFieldRect.origin.y)
        }

        #endif
        
        #if os(OSX)
        playField.position = CGPoint(x: sceneCenter.x-playFieldRect.size.width/2+40, y: sceneCenter.y-playFieldRect.size.height/2+40)
        #endif
        
        // Spielfeld hinzufügen
        self.addChild(playField)

//        JKGame.game.drawBorder(on: self)
    }
    

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

