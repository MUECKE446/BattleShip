//
//  extensionGameScene.swift
//  BlockGame
//
//  Created by Christian Muth on 03.09.16.
//  Copyright © 2016 Christian Muth. All rights reserved.
//

import Foundation
import SpriteKit

#if os(iOS)
typealias Color = UIColor
#endif
#if os(OSX)
typealias Color = NSColor
#endif

struct ShipNode {
    var nodes:[SKSpriteNode] = []
    var lenght = -1
}

extension GameScene {

    func addNumberLabels() {
        // tile (0,0) liegt in der unteren linken Ecke
        let lowerLeftTilePosition = gamePlayField.centerOfTile(atColumn: 0, row: 0)
        var numberLabelPosition = lowerLeftTilePosition
        numberLabelPosition.y += (gamePlayField.tileSize.height * CGFloat(gamePlayField.numberOfRows))
        
        for j in 0..<gridSize {
            // oben
            let numberBackGroundLabel = SKSpriteNode(color: Color.lightGray, size: gamePlayField.tileSize)
            numberBackGroundLabel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            numberBackGroundLabel.position = numberLabelPosition
            gamePlayField.addChild(numberBackGroundLabel)
            let numberLabel = SKLabelNode(text: String(j))
            numberLabel.fontColor = Color.black
            numberLabel.fontName = "Helvetica"
            numberLabel.fontSize = 28
            let numberLabelName = "numberLabelUp " + String(j)
            numberLabel.name = numberLabelName
            numberLabel.position = numberLabelPosition
            numberLabel.verticalAlignmentMode = .center
            numberLabel.zPosition = numberBackGroundLabel.zPosition + 1
            gamePlayField.addChild(numberLabel)
            numberLabelPosition.x += gamePlayField.tileSize.width
        }
        numberLabelPosition = lowerLeftTilePosition
        numberLabelPosition.x -= gamePlayField.tileSize.height
        for i in 0..<gridSize {
            // links
            let numberBackGroundLabel = SKSpriteNode(color: Color.lightGray, size: gamePlayField.tileSize)
            numberBackGroundLabel.position = numberLabelPosition
            gamePlayField.addChild(numberBackGroundLabel)
            let numberLabel = SKLabelNode(text: String(i))
            numberLabel.fontColor = Color.black
            numberLabel.fontName = "Helvetica"
            numberLabel.fontSize = 28
            let numberLabelName = "numberLabelLeft " + String(i)
            numberLabel.name = numberLabelName
            numberLabel.position = numberLabelPosition
            numberLabel.verticalAlignmentMode = .center
            numberLabel.zPosition = numberBackGroundLabel.zPosition + 1
            gamePlayField.addChild(numberLabel)
            numberLabelPosition.y += gamePlayField.tileSize.height
        }
    }
    
    
    
    
    func showShipsInPlayField(game:BattleShipGame) {
        //let bundlePath = Bundle.main.path(forResource: "PlayFieldTileSet", ofType: "sks")
        let playFieldTileSet = SKTileSet(named: "PlayField")
        gamePlayFieldLayer1 = SKTileMapNode(tileSet: playFieldTileSet!, columns: gridSize, rows: gridSize, tileSize: CGSize(width: 80, height: 80))
        gamePlayFieldLayer1.name = "PlayFieldLayer1"
        let tileGroups = playFieldTileSet!.tileGroups
        //let emptyFieldTile = tileGroups.first(where: {$0.name == "EmptyField"})
        //        let waterTile = tileGroups.first(where: {$0.name == "Water"})
        let shipMiddleTile = tileGroups.first(where: {$0.name == "ShipMiddle"})
        let shipLeftTile = tileGroups.first(where: {$0.name == "ShipLeft"})
        let shipRightTile = tileGroups.first(where: {$0.name == "ShipRight"})
        let shipUpTile = tileGroups.first(where: {$0.name == "ShipUp"})
        let shipDownTile = tileGroups.first(where: {$0.name == "ShipDown"})
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if game.gameGrid[row][col] {
                    // setze das entsprechende Feld in gamePlayFieldLayer1
                    let ship = game.findShip(row, col)
                    
                    gamePlayFieldLayer1.setTileGroup(shipMiddleTile, forColumn: col, row: row)
                    switch ship.direction {
                    case .horizontal:
                        if row == ship.startFieldIndex.row && col == ship.startFieldIndex.column {
                            gamePlayFieldLayer1.setTileGroup(shipLeftTile, forColumn: col, row: row)
                        }
                        if row == ship.startFieldIndex.row && col == ship.startFieldIndex.column+ship.length-1 {
                            gamePlayFieldLayer1.setTileGroup(shipRightTile, forColumn: col, row: row)
                        }
                    case .vertical:
                        if col == ship.startFieldIndex.column && row == ship.startFieldIndex.row {
                            gamePlayFieldLayer1.setTileGroup(shipDownTile, forColumn: col, row: row)
                        }
                        if col == ship.startFieldIndex.column && row == ship.startFieldIndex.row+ship.length-1 {
                            gamePlayFieldLayer1.setTileGroup(shipUpTile, forColumn: col, row: row)
                        }
                    }
                }
            }
        }
        gamePlayFieldLayer1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gamePlayFieldLayer1.zPosition = gamePlayField.zPosition + 1
        gamePlayFieldLayer1.xScale = gamePlayField.xScale
        gamePlayFieldLayer1.yScale = gamePlayField.yScale
        gamePlayFieldLayer1.position = gamePlayFieldPosition
        addChild(gamePlayFieldLayer1)
        
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
        let gamePlayFieldRect = gamePlayField.calculateAccumulatedFrame()
        var nextShipPosition = CGPoint(x: gamePlayFieldRect.origin.x + gamePlayField.tileSize.width, y: gamePlayFieldRect.origin.y)
        let scale = CGFloat(0.7)
        // Höhe einer Kachel + halbe Höhe
        let testNode = SKSpriteNode(imageNamed: "shipPreviewMiddle")
        let nodeHeight = testNode.size.height
        nextShipPosition.y -= (nodeHeight + nodeHeight/2) * scale
        
        // zeige die Schiffe vom größtem zum kleinsten hin
        for ship in game.ships.reversed() {
            var shipNode = ShipNode()
            if lastLength != ship.length || (nextShipPosition.x + CGFloat(ship.length) * CGFloat(76.0 * scale) > gamePlayFieldRect.origin.x + gamePlayFieldRect.size.width) {
                nextShipPosition.x = gamePlayFieldRect.origin.x + gamePlayField.tileSize.width
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
            numberLabel.fontColor = Color.black
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
    
    // zeige zufällig n belegte Felder
    func showRandomUsedShipFields(game:BattleShipGame, numberOfFields:Int) {
        for i in 0..<numberOfFields {
            // suche ein Schiff
            let s = Int.random(0..<game.ships.count)
            let ship = game.ships[s]
            let f = Int.random(1..<ship.length)
        }
    }
    
}
