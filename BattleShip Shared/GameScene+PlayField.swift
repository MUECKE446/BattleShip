//
//  extensionGameScene.swift
//  BlockGame
//
//  Created by Christian Muth on 03.09.16.
//  Copyright © 2016 Christian Muth. All rights reserved.
//

import Foundation
import SpriteKit

struct ShipNode {
    var nodes:[SKSpriteNode] = []
    var lenght = -1
}

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
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let pieceName = "playField_part(" + String(row) + "," + String(col) + ")"
                if game.gameGrid[row][col] {
                    // ersetze das entsprechende Feld im playField
                    for node in playField.children {
                        if let nodeName = node.name {
                            if nodeName == pieceName {
                                var shipNode = SKSpriteNode(imageNamed: "shipMiddle")
                                let ship = game.findShip(row, col)
                                switch ship.direction {
                                case .horizontal:
                                    if row == ship.startFieldIndex.row && col == ship.startFieldIndex.column {
                                        shipNode = SKSpriteNode(imageNamed: "shipLeft")
                                    }
                                    if row == ship.startFieldIndex.row && col == ship.startFieldIndex.column+ship.length-1 {
                                        shipNode = SKSpriteNode(imageNamed: "shipRight")
                                    }
                                    break
                                case .vertical:
                                    if col == ship.startFieldIndex.column && row == ship.startFieldIndex.row {
                                        shipNode = SKSpriteNode(imageNamed: "shipUp")
                                    }
                                    if col == ship.startFieldIndex.column && row == ship.startFieldIndex.row+ship.length-1 {
                                        shipNode = SKSpriteNode(imageNamed: "shipDown")
                                    }
                                    break
                                }
                                shipNode.name = pieceName
                                shipNode.position = node.position
                                node.removeFromParent()
                                playField.addChild(shipNode)
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
    
    func showUsedShipsInGame(_ game:BattleShipGame) {
        var lastLength = game.ships.last?.length
        var nextShipPosition = playField.position
        let scale = CGFloat(0.7)
        // Höhe einer Kachel + halbe Höhe
        let testNode = SKSpriteNode(imageNamed: "shipPreviewMiddle")
        let nodeHeight = testNode.size.height
        nextShipPosition.y -= (nodeHeight + nodeHeight/2) * scale
        
        // zeige die Schiffe vom größtem zum kleinsten hin
        for ship in game.ships.reversed() {
            var shipNode = ShipNode()
            let playFieldRect = playField.calculateAccumulatedFrame()
            if lastLength != ship.length || (nextShipPosition.x + CGFloat(ship.length) * CGFloat(76.0 * scale) > playFieldRect.origin.x + playFieldRect.size.width) {
                nextShipPosition.x = playField.position.x
                nextShipPosition.y -= CGFloat((nodeHeight + nodeHeight/4) * scale)
            }
            var nextNodePosition = nextShipPosition
            
            shipNode.lenght = ship.length
            // alle Schiffe werden hier horizontal angezeigt
            // ersten Node hinzufügen
            var node = SKSpriteNode(imageNamed: "shipPreviewLeft")
            node.position = nextNodePosition
            // im ersten Node wird die Länge angezeigt
            let numberLabel = SKLabelNode(text: String(ship.length))
            numberLabel.fontColor = UIColor.darkText
            numberLabel.fontName = "Helvetica"
            numberLabel.fontSize = 28
            numberLabel.verticalAlignmentMode = .center
            numberLabel.zPosition = node.zPosition + 1
            node.addChild(numberLabel)
            shipNode.nodes.append(node)
            if ship.length > 2 {
                for _ in 2...ship.length-1 {
                    node = SKSpriteNode(imageNamed: "shipPreviewMiddle")
                    nextNodePosition.x += CGFloat(76 * scale)
                    node.position = nextNodePosition
                    shipNode.nodes.append(node)
                }
            }
            node = SKSpriteNode(imageNamed: "shipPreviewRight")
            nextNodePosition.x += CGFloat(76 * scale)
            shipNode.nodes.append(node)
            node.position = nextNodePosition
            //let ship = SKSpriteNode()
            for node in shipNode.nodes {
                node.setScale(scale)
                addChild(node)
            }
            lastLength = ship.length
            // Lücke zum nächsten Schiff
            nextShipPosition.x = nextNodePosition.x + CGFloat((nodeHeight + nodeHeight/4) * scale)
        }
    }
    
}
