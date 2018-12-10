//
//  BattleShipGame.swift
//  BattleShip iOS
//
//  Created by Christian Muth on 04.12.18.
//  Copyright © 2018 Christian Muth. All rights reserved.
//

import Foundation

// MARK: globale Konstanten

let kGridSize = 12

// MARK: globale Variablen

let numberOfShips       = [0,1,2,2,2,1,1]   // einer,zweier, .. siebener; shipLenghts ist immer index+1
let numberOfShipsFields = [1,2,3,4,5,6,7]   // Schiffslängen


// MARK: enums and typealiasse

// Richtung im Spiel
enum Direction {
    case horizontal,vertical
}

typealias FieldIndex = (row:Int,column:Int)

// MARK: Hilfsklassen

class Ship {
    var startFieldIndex:FieldIndex = (-1,-1)   // verändert sich beim Platzieren
    var direction = Direction.horizontal
    var placed = false
    
    let length : Int
    
    init(length:Int) {
        self.length = length
    }
}

class BattleShipGame {
    var ships:[Ship] = []
    
    let gridSize : Int
    
    var notSuitableFieldsGrid: [[Bool]] = []
    var gameGrid: [[Bool]] = []
    
    // das gleiche brauche ich für jeden einzelnen Versuch
    var possibleHorizontalStartFieldsGrid : [[Bool]] = []
    var possibleVerticalStartFieldsGrid : [[Bool]] = []
    // Hilfsfelder dafür
    var possibleHorizontalStartIndices : [FieldIndex] = []
    var possibleVerticalStartIndices : [FieldIndex] = []

    var occupiedFieldsInColumns:[Int] = []
    var occupiedFieldsInRows:[Int] = []
    
    init(gridSize:Int) {
        self.gridSize = gridSize
    }
    
    // versucht ein Spiel zu erzeugen
    func createGame() {
        createShips()
        // solange versuchen, bis es klappt
        while !setShipsToGameGrid() {
        }
        occupiedFieldsInRows = calculateOccupiedFieldsInRows()
        occupiedFieldsInColumns = calculateOccupiedFieldsInColumns()
    }
    
    func createPossibleStartFieldGrid(ship:Ship,direction:Direction) -> [[Bool]] {
        var tmpField = Array(repeating: Array(repeating: true, count: gridSize), count: gridSize)
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                // alle berlegten Felder aus notSuitableFieldsGrid sind verbrannt
                if notSuitableFieldsGrid[row][col] {
                    tmpField[row][col] = false
                }
            }
        }
        // jetzt müssen noch die offensichtlich nicht möglichen gefunden werden
        // wie groß ist das Schiff
        let length = ship.length
        // noch mal jedes Feld untersuchen
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                // falls dieses Feld schon verbrannt ist -> nächstes untersuchen
                if tmpField[row][col] == false {
                    continue
                }
                var proofedFieldsIndices : [FieldIndex] = []
                var fits = true
                switch direction {
                case .horizontal:
                    // prüfe, ob hier das Schiff horizontal hinpassen würde
                    for c in 0..<length {
                        if col+c >= gridSize {
                            // ende des Spielfeldes erreicht
                            fits = false
                            break       // überprüfung fehlgeschlagen
                        }
                        proofedFieldsIndices.append((row: row, column:col+c))
                        if tmpField[row][col+c] == false {
                            fits = false
                            break       // überprüfung fehlgeschlagen
                        }
                    }
                    if !fits {
                        // alle untersuchten Felder sind verbrannt
                        for fieldIndex in proofedFieldsIndices {
                            tmpField[fieldIndex.row][fieldIndex.column] = false
                        }
                    }
                case .vertical:
                    // prüfe, ob hier das Schiff vertikal hinpassen würde
                    for r in 0..<length {
                        if row+r >= gridSize {
                            // ende des Spielfeldes erreicht
                            fits = false
                            break       // überprüfung fehlgeschlagen
                        }
                        proofedFieldsIndices.append((row: row+r, column:col))
                        if tmpField[row+r][col] == false {
                            fits = false
                            break       // überprüfung fehlgeschlagen
                        }
                    }
                    if !fits {
                        // alle untersuchten Felder sind verbrannt
                        for fieldIndex in proofedFieldsIndices {
                            tmpField[fieldIndex.row][fieldIndex.column] = false
                        }
                    }
                }
            }
        }
        return tmpField
    }
    
    func getPossibleStartFieldIndices(possibleStartFieldGrid:[[Bool]]) -> [FieldIndex] {
        var tmpPossibleStartFieldIndices:[FieldIndex] = []
        for row in 0..<possibleStartFieldGrid.count {
            for col in 0..<possibleStartFieldGrid.count {
                if possibleStartFieldGrid[row][col] {
                    tmpPossibleStartFieldIndices.append((row,col))
                }
            }
        }
        return tmpPossibleStartFieldIndices
    }
    
    func createShips() {
        // Erzeuge die Schiffe
        for (index,value) in numberOfShips.enumerated() {
            if value > 0 {
                for _ in 1...value {
                    let ship = Ship(length: numberOfShipsFields[index])
                    ships.append(ship)
                }
            }
        }
    }
    
    func setShipsToGameGrid() -> Bool {
        // Vorbereitungen
        // für alle folgenden Versuche ein gültiges Spiel zu erzeugen, benötige ich Information, ob noch ein neuer Versuch gemacht werden kann
        // als Hilfe wird daraus gleich gebildet
        // erzeuge ein leeres Spielfeld
        notSuitableFieldsGrid = Array(repeating: Array(repeating: false, count: gridSize), count: gridSize)
        gameGrid = Array(repeating: Array(repeating: false, count: gridSize), count: gridSize)
        
        // wähle ein StartField
        var direction = Direction.horizontal
        var startFieldIndex = (row:-1,column:-1)
        
        var ship = findNextShip()
        while ship != nil {
            // veruche das Schiff zu platzieren
            while !ship!.placed {
                // neue Anfangswerte für das Schiff
                if !getNewStartValuesFor(ship:ship!,startFieldIndex: &startFieldIndex, direction: &direction) {
                    return false
                }
                if placeShip(ship: ship!, startFieldIndex: startFieldIndex, direction: direction) {
                    break
                }
            }
            ship = findNextShip()
        }
        return true
    }
    
    func getNewStartValuesFor(ship:Ship,startFieldIndex:inout FieldIndex, direction:inout Direction) -> Bool {
        possibleHorizontalStartFieldsGrid = createPossibleStartFieldGrid(ship: ship,direction: .horizontal)
        possibleVerticalStartFieldsGrid = createPossibleStartFieldGrid(ship: ship,direction: .vertical)
        possibleHorizontalStartIndices = getPossibleStartFieldIndices(possibleStartFieldGrid: possibleHorizontalStartFieldsGrid)
        possibleVerticalStartIndices = getPossibleStartFieldIndices(possibleStartFieldGrid: possibleVerticalStartFieldsGrid)
        if possibleHorizontalStartIndices.count == 0 && possibleVerticalStartIndices.count == 0 {
            return false
        }
        if possibleHorizontalStartIndices.count == 0 {
            direction = .vertical
        }
        if possibleVerticalStartIndices.count == 0 {
            direction = .horizontal
        }
        if possibleHorizontalStartIndices.count != 0 && possibleVerticalStartIndices.count != 0 {
            direction = getRandomDirection()
        }
        startFieldIndex = getStartFieldIndex(horizontalStartIndices: possibleHorizontalStartIndices,verticalStartIndices: possibleVerticalStartIndices,direction: direction)
        return true
    }
    
    // suche nach dem nächsten größten Schiff
    func findNextShip() -> Ship? {
        for ship in ships.reversed() {
            if ship.placed {
                continue
            }
            else {
                return ship
            }
        }
        return nil
    }
    
    func placeShip(ship:Ship,startFieldIndex:FieldIndex,direction:Direction) -> Bool {
        ship.direction = direction
        ship.startFieldIndex = startFieldIndex
        // untersuche notSuitableFieldsGrid
        var fieldIndicesForShip : [FieldIndex] = []
        if isFreeInGameGrid(ship: ship, direction: direction, fieldIndicesForShip: &fieldIndicesForShip) {
            // platziere Schiff
            placeShip(ship: ship,fieldIndicesForShip: fieldIndicesForShip)
            return true
        }
        return false
    }
    
    func placeShip(ship:Ship,fieldIndicesForShip:[FieldIndex]) {
        for fieldIndex in fieldIndicesForShip {
            notSuitableFieldsGrid[fieldIndex.row][fieldIndex.column] = true
        }
        switch ship.direction {
        case .horizontal:
            for col in ship.startFieldIndex.column..<ship.startFieldIndex.column+ship.length {
                gameGrid[ship.startFieldIndex.row][col] = true
            }
        case .vertical:
            for row in ship.startFieldIndex.row..<ship.startFieldIndex.row+ship.length {
                gameGrid[row][ship.startFieldIndex.column] = true
            }
        }
        ship.placed = true
    }
    
    func isFreeInGameGrid(ship:Ship, direction:Direction,fieldIndicesForShip: inout [FieldIndex]) -> Bool {
        var controllFieldIndices : [FieldIndex] = []
        let fieldIndex = ship.startFieldIndex
        var up = 0; var down = 0; var left = 0; var right = 0
        
        switch direction {
        case .horizontal:
            // kann das Schiff überhaupt platziert werden
            if fieldIndex.column + (ship.length-1)  >= gridSize {
                // das Schiff ist nicht plazierbar
                return false
            }
            // ist eine Spalte links vorhanden
            if fieldIndex.column - 1 > 0 {
                left += 1
            }
            // ist rechts eine Spalte vorhanden
            if fieldIndex.column + (ship.length-1) + 1 < gridSize {
                right += 1
            }
            // ist eine Reihe oben vorhanden
            if fieldIndex.row - 1 > 0 {
                up += 1
            }
            // ist eine Reihe unten vorhanden
            if fieldIndex.row + 1 < gridSize {
                down += 1
            }
            let startRange = fieldIndex.column - left
            let endRange = fieldIndex.column + (ship.length-1) + right
            for i in startRange...endRange {
                // das Schiff selbst
                let tmpField = (fieldIndex.row,i)
                controllFieldIndices.append(tmpField)
                if up == 1 {
                    let tmpField = (fieldIndex.row-up,i)
                    controllFieldIndices.append(tmpField)
                }
                if down == 1 {
                    let tmpField = (fieldIndex.row+down,i)
                    controllFieldIndices.append(tmpField)
                }
            }
        case .vertical:
            // kann das Schiff überhaupt platziert werden
            if fieldIndex.row + (ship.length-1)  >= gridSize {
                // das Schiff ist nicht plazierbar
                return false
            }
            // ist eine Spalte links vorhanden
            if fieldIndex.column - 1 > 0 {
                left += 1
            }
            // ist rechts eine Spalte vorhanden
            if fieldIndex.column + 1 < gridSize {
                right += 1
            }
            // ist eine Reihe oben vorhanden
            if fieldIndex.row - 1 > 0 {
                up += 1
            }
            // ist eine Reihe unten vorhanden
            if fieldIndex.row + (ship.length-1) + 1 < gridSize {
                down += 1
            }
            let startRange = fieldIndex.row - up
            let endRange = fieldIndex.row + (ship.length-1) + down
            for i in startRange...endRange {
                // das Schiff selbst
                let tmpField = (i,fieldIndex.column)
                controllFieldIndices.append(tmpField)
                if left == 1 {
                    let tmpField = (i,fieldIndex.column-left)
                    controllFieldIndices.append(tmpField)
                }
                if right == 1 {
                    let tmpField = (i,fieldIndex.column+right)
                    controllFieldIndices.append(tmpField)
                }
            }
        }
        // prüfen, ob alle diese Felder frei sind
        for fieldIndex in controllFieldIndices {
            if gameGrid[fieldIndex.row][fieldIndex.column] {
                // leider ist das Feld schon belegt
                return false
            }
        }
        fieldIndicesForShip = controllFieldIndices
        return true
    }
    
    // lege zuerst die Richtung fest
    func getRandomDirection() -> Direction {
        switch Int.random(in: 1..<3) {
        case 1:
            return Direction.horizontal
        case 2:
            return Direction.vertical
        default:
            fatalError()
        }
    }
    
    func getStartFieldIndex(horizontalStartIndices:[FieldIndex],verticalStartIndices:[FieldIndex],direction:Direction) -> FieldIndex {
        switch direction {
        case .horizontal:
            return horizontalStartIndices.randomElement()!
        case .vertical:
            return verticalStartIndices.randomElement()!
        }
    }
    
    // berechne die Anzahl der belegten Felder (rows)
    func calculateOccupiedFieldsInRows() -> [Int] {
        var tmpArr:[Int] = []
        var numberOccupied = 0
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if gameGrid[row][col] {
                    numberOccupied += 1
                }
            }
            tmpArr.append(numberOccupied)
            numberOccupied = 0
        }
        return tmpArr
    }
    
    // berechne die Anzahl der belegten Felder (columns)
    func calculateOccupiedFieldsInColumns() -> [Int] {
        var tmpArr:[Int] = []
        var numberOccupied = 0
        for col in 0..<gridSize {
            for row in 0..<gridSize {
                if gameGrid[row][col] {
                    numberOccupied += 1
                }
            }
            tmpArr.append(numberOccupied)
            numberOccupied = 0
        }
        return tmpArr
    }
    
    func findShip(_ row:Int, _ columun:Int) -> Ship {
        var tmpShip = Ship(length: 0)
        
        for ship in ships {
            switch ship.direction {
            case .horizontal:
                let columnRange = ship.startFieldIndex.column..<ship.startFieldIndex.column+ship.length
                if ship.startFieldIndex.row == row && columun >= columnRange.startIndex && columun <= columnRange.endIndex {
                    tmpShip = ship
                    break
                }
            case .vertical:
                let rowRange = ship.startFieldIndex.row..<ship.startFieldIndex.row+ship.length
                if ship.startFieldIndex.column == columun && row >= rowRange.startIndex && row <= rowRange.endIndex {
                    tmpShip = ship
                    break
                }
            }
        }
        return tmpShip
    }
    
}
