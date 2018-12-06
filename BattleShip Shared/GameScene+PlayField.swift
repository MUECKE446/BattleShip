//
//  extensionGameScene.swift
//  BlockGame
//
//  Created by Christian Muth on 03.09.16.
//  Copyright © 2016 Christian Muth. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {

    func createPlayField(gridSize:Int,withNumberLabels:Bool) -> SKSpriteNode {
        // dies ist das Gitter, in dem gespielt wird
        // (0,0) oberstes linkes Feld
        let playField = SKSpriteNode()
        playField.name = "PlayField"
        
        // da der ancorPoint bei default (0.5,0.5) liegt (was der Mittelpunkt der ersten SpriteNode ist) liegt die
        // untere Ecke bei (-40,-40)
        var playFieldPosition = CGPoint.zero
        
        if withNumberLabels {
            // es sollen jetzt oben und links noch die Label hinzugefügt werden
            playFieldPosition.y = CGFloat(gridSize * 76)
            for j in 0..<gridSize {
                // oben
                let numberBackGroundLabel = SKSpriteNode(color: UIColor.lightGray, size: CGSize(width: 80, height: 80))
                numberBackGroundLabel.position = playFieldPosition
                playField.addChild(numberBackGroundLabel)
                let numberLabel = SKLabelNode(text: String(j))
                numberLabel.fontColor = UIColor.darkText
                numberLabel.fontName = "Helvetica"
                numberLabel.fontSize = 28
                let numberLabelName = "numberLabelUp " + String(j)
                numberLabel.name = numberLabelName
                numberLabel.position = playFieldPosition
                numberLabel.verticalAlignmentMode = .center
                numberLabel.zPosition = numberBackGroundLabel.zPosition + 1
                playField.addChild(numberLabel)
                playFieldPosition.x += 76
            }
            playFieldPosition.y = 0
            playFieldPosition.x = -76
            for i in 0..<gridSize {
                // links
                let numberBackGroundLabel = SKSpriteNode(color: UIColor.lightGray, size: CGSize(width: 80, height: 80))
                numberBackGroundLabel.position = playFieldPosition
                playField.addChild(numberBackGroundLabel)
                let numberLabel = SKLabelNode(text: String((gridSize-1)-i))
                numberLabel.fontColor = UIColor.darkText
                numberLabel.fontName = "Helvetica"
                numberLabel.fontSize = 28
                let numberLabelName = "numberLabelLeft " + String((gridSize-1)-i)
                numberLabel.name = numberLabelName
                numberLabel.position = playFieldPosition
                numberLabel.verticalAlignmentMode = .center
                numberLabel.zPosition = numberBackGroundLabel.zPosition + 1
                playField.addChild(numberLabel)
                playFieldPosition.y += 76
            }
        }
        //return playField

        playFieldPosition = CGPoint.zero
        // ich brauche gridSize Reihen und Spalten
        for i in 0..<gridSize {
            // dies ist eine Reihe
            for j in 0..<gridSize {
                //!!!: beim Namen der Datei kommt es auf Groß/Kleinschreibung an
                let playFieldPiece = SKSpriteNode(imageNamed: "Gitterfeld_80x80")
                let pieceName = "playField_part(" + String((gridSize-1)-i) + "," + String(j) + ")"
                playFieldPiece.name = pieceName
                playFieldPiece.position = playFieldPosition
                playField.addChild(playFieldPiece as SKNode)
                // für den Test die Koordinaten einblenden
//                let coordinatesText = String((gridSize-1)-i) + "," + String(j)
//                let coordinateLabel = SKLabelNode(text: coordinatesText)
//                coordinateLabel.fontColor = UIColor.darkText
//                coordinateLabel.fontName = "Helvetica"
//                coordinateLabel.fontSize = 22
//                coordinateLabel.position = playFieldPosition
//                coordinateLabel.verticalAlignmentMode = .center
//                coordinateLabel.zPosition = playFieldPiece.zPosition + 1
//                playField.addChild(coordinateLabel)
                // ein Gitterfeld ist 80x80 Pixel groß; die umgebende Umrandung hat eine Linienstärke von 2 Pixeln
                playFieldPosition.x += 76
            }
            playFieldPosition.x = 0
            playFieldPosition.y += 76
        }
        return playField
    }
    
    func showShipsInPlayField(game:BattleShipGame) {
        var playFieldNode = SKSpriteNode()
        for node in self.children {
            if node.name != nil {
                if node.name == "PlayField" {
                    playFieldNode = node as! SKSpriteNode
                    break
                }
            }
        }
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let pieceName = "playField_part(" + String(row) + "," + String(col) + ")"
                if game.gameGrid[row][col] {
                    // ersetze das entsprechende Feld im playField
                    for node in playFieldNode.children {
                        if let nodeName = node.name {
                            if nodeName == pieceName {
                                let shipNode = SKSpriteNode(imageNamed: "playingField_80x80")
                                shipNode.name = pieceName
                                shipNode.position = node.position
                                node.removeFromParent()
                                playFieldNode.addChild(shipNode)
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showOccupiedFieldsInRowsAndColumns(game:BattleShipGame) {
        var found = false
        for i in 0..<game.gridSize {
            // finde numberLabel
            found = false
            for node in self.children {
                if node.name != nil {
                    if node.name == "PlayField" {
                        for childNode in node.children {
                            if let nodeName = childNode.name {
                                if nodeName == "numberLabelUp " + String(i) {
                                    // numberLabel  gefunden
                                    let numberLabel = childNode as! SKLabelNode
                                    numberLabel.text = String(game.occupiedFieldsInColumns[i])
                                    found = true
                                    break
                                }
                            }
                        }
                        if found {
                            break
                        }
                    }
                }
            }
        }
        for i in 0..<game.gridSize {
            // finde numberLabel
            found = false
            for node in self.children {
                if node.name != nil {
                    if node.name == "PlayField" {
                        for childNode in node.children {
                            if let nodeName = childNode.name {
                                if nodeName == "numberLabelLeft " + String(i) {
                                    // numberLabel  gefunden
                                    let numberLabel = childNode as! SKLabelNode
                                    numberLabel.text = String(game.occupiedFieldsInRows[i])
                                    found = true
                                    break
                                }
                            }
                        }
                        if found {
                            break
                        }
                    }
                }
            }
        }
    }
}
