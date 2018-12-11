//
//  GameScene.swift
//  BattleShip Shared
//
//  Created by Christian Muth on 04.12.18.
//  Copyright © 2018 Christian Muth. All rights reserved.
//

import SpriteKit

class GameScene : SKScene {
    
    
    var sceneCenter = CGPoint.zero
    
    var playField = SKSpriteNode()
    var gridSize = 0

    // Aktions
    var sequenceAction = SKAction()
    
    let scaleToSmall = CGFloat(0.5)
    
    #if os(iOS)
    var panGestureRecognizer = UIPanGestureRecognizer()
    #endif
    
//    var playFieldNode: SKSpriteNode {
//        get {
//            var tmpNode = SKSpriteNode()
//            for node in self.children {
//                if node.name != nil {
//                    if node.name == "PlayField" {
//                        tmpNode = node as! SKSpriteNode
//                        break
//                    }
//                }
//            }
//            return tmpNode
//        }
//    }
    
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
        playField = createPlayField(gridSize: gridSize, withNumberLabels: true)
        // das ist der Mittelpunkt der Scene
        sceneCenter = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        #if os(iOS)
        // Design für iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            let playFieldRect = playField.calculateAccumulatedFrame()
            playField.position = CGPoint(x: sceneCenter.x-playFieldRect.size.width/2-playFieldRect.origin.x, y: self.size.height * 0.9 - playFieldRect.size.height - playFieldRect.origin.y)
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

