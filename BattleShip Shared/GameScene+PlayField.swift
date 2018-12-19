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
        gamePlayFieldLayer1.isHidden = true
        addChild(gamePlayFieldLayer1)
        
    }
    
    func isMirrorOfGameGrid(game:BattleShipGame) {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if game.gameGrid[row][col] {
                    let tile = gamePlayFieldLayer1.tileGroup(atColumn: col, row: row)
                    assert((tile?.name?.contains("Ship"))!)
                }
            }
        }
    }
    
    func showOccupiedFieldsInRowsAndColumns(game:BattleShipGame) {
        var found = false
        for i in 0..<gridSize {
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
        for i in 0..<gridSize {
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
        securedFields = []
        let tileGroups = playFieldTileSet!.tileGroups
        let emptyFieldTile = tileGroups.first(where: {$0.name == "EmptyField"})
        //let waterTile = tileGroups.first(where: {$0.name == "Water"})
        let shipMiddleTile = tileGroups.first(where: {$0.name == "ShipMiddle"})
        let shipLeftTile = tileGroups.first(where: {$0.name == "ShipLeft"})
        let shipRightTile = tileGroups.first(where: {$0.name == "ShipRight"})
        let shipUpTile = tileGroups.first(where: {$0.name == "ShipUp"})
        let shipDownTile = tileGroups.first(where: {$0.name == "ShipDown"})
        
        for _ in 0..<numberOfFields {
            // suche ein Schiff
            var index = (row:-1,column:-1)
            var ship = Ship(length: 0)
            var s = -1, f = -1
            var tile = emptyFieldTile
//            var onceAgain = false
            repeat {
                s = Int.random(0..<game.ships.count)
                ship = game.ships[s]
//                switch ship.direction {
//                case .horizontal:
//                    for c in 0..<ship.length {
//                        assert(game.gameGrid[ship.startFieldIndex.row][ship.startFieldIndex.column+c])
//                    }
//                case .vertical:
//                    for r in 0..<ship.length {
//                        assert(game.gameGrid[ship.startFieldIndex.row+r][ship.startFieldIndex.column])
//                    }
//                }
                f = Int.random(0..<ship.length)
                tile = shipMiddleTile
                switch ship.direction {
                case .horizontal:
                    index = (row:ship.startFieldIndex.row,column:ship.startFieldIndex.column+f)
                    assert(game.gameGrid[index.row][index.column], "das ist nicht fair")
                    if index.column == ship.startFieldIndex.column {
                        tile = shipLeftTile
                    }
                    if index.column == ship.startFieldIndex.column+ship.length-1 {
                        tile = shipRightTile
                    }
                case .vertical:
                    index = (row:ship.startFieldIndex.row+f,column:ship.startFieldIndex.column)
                    assert(game.gameGrid[index.row][index.column], "das ist nicht fair")
                    if index.row == ship.startFieldIndex.row {
                        tile = shipDownTile
                    }
                    if index.row == ship.startFieldIndex.row+ship.length-1 {
                        tile = shipUpTile
                        gamePlayFieldLayer2.setTileGroup(shipUpTile, forColumn: index.column, row: index.row)
                    }
                }
//                if securedFields.contains(where: {(tileIndex:(column:Int,row:Int)) in index == tileIndex}) {
//                    onceAgain = true
//                }
//                else {
//                    onceAgain = false
//                }
            } while securedFields.contains(where: {(tileIndex:(column:Int,row:Int)) in index == tileIndex})
            
            gamePlayFieldLayer2.setTileGroup(tile, forColumn: index.column, row: index.row)
            securedFields.append((column: index.column,row:index.row))
        }
        // zeige jetzt alle sicher identifizierbaren Felder drumrum
        showAllFieldsAroundSecuredFields()
        // zeige alle Reihen,Spalten in denen kein Feld belegt ist
        showAllFieldsInZeroRowsOrColumns(game: game)
        
    }
    
    func showAllFieldsAroundSecuredFields() {
        // zeige jetzt alle sicher identifizierbaren Felder drumrum
        let tileGroups = playFieldTileSet!.tileGroups
        let waterTile = tileGroups.first(where: {$0.name == "Water"})
        var fieldsToShow:[FieldIndex] = []
        for securedField in securedFields {
            let field = (row:securedField.row,column:securedField.column)
            let tile = gamePlayFieldLayer2.tileDefinition(atColumn: securedField.column, row: securedField.row)
            fieldsToShow.append(contentsOf: getAllFieldsAround(fieldIndex: field, tile: tile!))
        }
        for index in fieldsToShow {
            gamePlayFieldLayer2.setTileGroup(waterTile, forColumn: index.column, row: index.row)
            
        }

    }
    
    func getAllFieldsAround(fieldIndex:FieldIndex,tile:SKTileDefinition) -> [FieldIndex] {
        var tmpFieldIndizes:[FieldIndex] = []
        var rowStart = -1, rowEnd = -1, columnStart = -1, columnEnd = -1
        rowStart = fieldIndex.row; rowEnd = fieldIndex.row; columnStart = fieldIndex.column; columnEnd = fieldIndex.column
        
        switch tile.name {
        case "ShipMiddle":
            rowStart != 0 ? rowStart -= 1 : nil
            rowEnd != gridSize-1 ? rowEnd += 1 : nil
            if fieldIndex.row == 0 || fieldIndex.row == gridSize - 1  {
                columnStart != 0 ? columnStart -= 1 : nil
                columnEnd != gridSize - 1 ? columnEnd += 1 : nil
            }
            columnStart != 0 ? columnStart -= 1 : nil
            columnEnd != gridSize - 1 ? columnEnd += 1 : nil
            if fieldIndex.column == 0 || fieldIndex.column == gridSize - 1  {
                rowStart != 0 ? rowStart -= 1 : nil
                rowEnd != gridSize-1 ? rowEnd += 1 : nil
            }
            for r in rowStart...rowEnd {
                for c in columnStart...columnEnd {
                    // ausgeschlossene Felder:
                    // das Feld selbst; rechts und links daneben und oben und unten daneben, wenn das Feld nicht am Rand liegt
                    if  (c == fieldIndex.column && r == fieldIndex.row) ||
                        (r == fieldIndex.row && (fieldIndex.column != 0 && fieldIndex.column != gridSize-1)) ||
                        (c == fieldIndex.column && (fieldIndex.row != 0 && fieldIndex.row != gridSize - 1)) {
                    continue
                    }
                    tmpFieldIndizes.append((row: r,column: c))
                }
            }
        case "ShipLeft":
            rowStart != 0 ? rowStart -= 1 : nil
            rowEnd != gridSize-1 ? rowEnd += 1 : nil
            columnStart != 0 ? columnStart -= 1 : nil
            columnEnd != gridSize - 1 ? columnEnd += 1 : nil
            columnEnd != gridSize - 1 ? columnEnd += 1 : nil
            for r in rowStart...rowEnd {
                for c in columnStart...columnEnd {
                    if r == fieldIndex.row && c >= fieldIndex.column {
                        continue
                    }
                    tmpFieldIndizes.append((row: r,column: c))
                }
            }
        case "ShipRight":
            rowStart != 0 ? rowStart -= 1 : nil
            rowEnd != gridSize-1 ? rowEnd += 1 : nil
            columnStart != 0 ? columnStart -= 1 : nil
            columnStart != 0 ? columnStart -= 1 : nil
            columnEnd != gridSize - 1 ? columnEnd += 1 : nil
            for r in rowStart...rowEnd {
                for c in columnStart...columnEnd {
                    if r == fieldIndex.row && c <= fieldIndex.column {
                        continue
                    }
                    tmpFieldIndizes.append((row: r,column: c))
                }
            }
        case "ShipDown":
            rowStart != 0 ? rowStart -= 1 : nil
            rowEnd != gridSize-1 ? rowEnd += 1 : nil
            rowEnd != gridSize-1 ? rowEnd += 1 : nil
            columnStart != 0 ? columnStart -= 1 : nil
            columnEnd != gridSize - 1 ? columnEnd += 1 : nil
            for r in rowStart...rowEnd {
                for c in columnStart...columnEnd {
                    if r >= fieldIndex.row && c == fieldIndex.column {
                        continue
                    }
                    tmpFieldIndizes.append((row: r,column: c))
                }
            }
        case "ShipUp":
            rowStart != 0 ? rowStart -= 1 : nil
            rowStart != 0 ? rowStart -= 1 : nil
            rowEnd != gridSize-1 ? rowEnd += 1 : nil
            columnStart != 0 ? columnStart -= 1 : nil
            columnEnd != gridSize - 1 ? columnEnd += 1 : nil
            for r in rowStart...rowEnd {
                for c in columnStart...columnEnd {
                    if r <= fieldIndex.row && c == fieldIndex.column {
                        continue
                    }
                    tmpFieldIndizes.append((row: r,column: c))
                }
            }
        default:
            fatalError("darf nicht sein")
            break
        }
        
        // die möglichen Felder sind jetzt eingegrenzt oder auch nicht
        return tmpFieldIndizes
    }
    
    func showAllFieldsInZeroRowsOrColumns(game:BattleShipGame) {
        let tileGroups = playFieldTileSet!.tileGroups
        let waterTile = tileGroups.first(where: {$0.name == "Water"})
        var fieldsToShow:[FieldIndex] = []
        for row in 0..<gridSize {
            if game.occupiedFieldsInRows[row] == 0 {
                for c in 0..<gridSize {
                    let fieldIndex = (row:row,column:c)
                    if gamePlayFieldLayer2.tileDefinition(atColumn: c, row: row)?.name == "Water" {
                        continue
                    }
                    fieldsToShow.append(fieldIndex)
                }
            }
        }
        for col in 0..<gridSize {
            if game.occupiedFieldsInColumns[col] == 0 {
                for r in 0..<gridSize {
                    let fieldIndex = (row:r,column:col)
                    if gamePlayFieldLayer2.tileDefinition(atColumn: col, row: r)?.name == "Water" {
                        continue
                    }
                    fieldsToShow.append(fieldIndex)
                }
            }
        }
        for index in fieldsToShow {
            gamePlayFieldLayer2.setTileGroup(waterTile, forColumn: index.column, row: index.row)
            
        }
    }
    
    func createGamePlayFieldWorkingLayer(_ game:BattleShipGame) {
        gamePlayFieldLayer2 = SKTileMapNode(tileSet: playFieldTileSet!, columns: gridSize, rows: gridSize, tileSize: CGSize(width: 80, height: 80))
        gamePlayFieldLayer2.name = "PlayFieldLayer2"
        showRandomUsedShipFields(game: game, numberOfFields: Int.random(in: 4...6))
        gamePlayFieldLayer2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gamePlayFieldLayer2.zPosition = gamePlayField.zPosition + 1
        gamePlayFieldLayer2.xScale = gamePlayField.xScale
        gamePlayFieldLayer2.yScale = gamePlayField.yScale
        gamePlayFieldLayer2.position = gamePlayFieldPosition
        //gamePlayFieldLayer2.isHidden = true
        addChild(gamePlayFieldLayer2)
    }
    
    func changeShipFieldsIfNeeded() {
        let tileGroups = playFieldTileSet!.tileGroups
        let shipMiddleTile = tileGroups.first(where: {$0.name == "ShipMiddle"})
        let shipLeftTile = tileGroups.first(where: {$0.name == "ShipLeft"})
        let shipRightTile = tileGroups.first(where: {$0.name == "ShipRight"})
        let shipUpTile = tileGroups.first(where: {$0.name == "ShipUp"})
        let shipDownTile = tileGroups.first(where: {$0.name == "ShipDown"})

        let waterFields:[FieldIndex] = getAllWaterTiles()
        var rowStart = -1, rowEnd = -1, columnStart = -1, columnEnd = -1
        for index in waterFields {
            rowStart = index.row; rowEnd = index.row; columnStart = index.column; columnEnd = index.column
            rowStart != 0 ? rowStart -= 1 : nil
            rowEnd != gridSize-1 ? rowEnd += 1 : nil
            columnStart != 0 ? columnStart -= 1 : nil
            columnEnd != gridSize - 1 ? columnEnd += 1 : nil
            for r in rowStart...rowEnd {
                for c in columnStart...columnEnd {
                    // ausgeschlossene Felder:
                    if  (c == index.column && r == index.row) ||
                        (r != index.row && c != index.column) {
                        continue
                    }
                    let tile = gamePlayFieldLayer2.tileDefinition(atColumn: c, row: r)
                    if let name = tile?.name {
                    if name.contains("Ship") {
                        if c < index.column {
                            gamePlayFieldLayer2.setTileGroup(shipRightTile, forColumn: c, row: r)
                        }
                        if c > index.column {
                            gamePlayFieldLayer2.setTileGroup(shipLeftTile, forColumn: c, row: r)
                        }
                        if r < index.row {
                            gamePlayFieldLayer2.setTileGroup(shipDownTile, forColumn: c, row: r)
                        }
                        if r > index.row {
                            gamePlayFieldLayer2.setTileGroup(shipUpTile, forColumn: c, row: r)
                        }
                    }
                }
            }
            }
        }
    }
    
    func getAllWaterTiles() -> [FieldIndex] {
        var tmpWaterFields : [FieldIndex] = []
        

        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let fieldIndex = (row:row,column:col)
                if gamePlayFieldLayer2.tileDefinition(atColumn: col, row: row)?.name == "Water" {
                    tmpWaterFields.append(fieldIndex)
                }
            }
        }
        return tmpWaterFields
    }
}
