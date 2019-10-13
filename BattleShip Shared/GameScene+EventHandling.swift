//
//  GameScene+EventHandling.swift
//  Block One
//
//  Created by Christian Muth on 01.10.16.
//  Copyright © 2016 Christian Muth. All rights reserved.
//

import Foundation
import SpriteKit


//MARK: shared  functions

extension GameScene {
    
    func handleUserAction(location:CGPoint) {
        let tileGroups = playFieldTileSet!.tileGroups
        //TODO: vielleicht brauche ich es später
        /*
        let shipMiddleTile = tileGroups.first(where: {$0.name == "ShipMiddle"})
        let shipLeftTile = tileGroups.first(where: {$0.name == "ShipLeft"})
        let shipRightTile = tileGroups.first(where: {$0.name == "ShipRight"})
        let shipUpTile = tileGroups.first(where: {$0.name == "ShipUp"})
        let shipDownTile = tileGroups.first(where: {$0.name == "ShipDown"})
         */
        let waterTile = tileGroups.first(where: {$0.name == "Water"})
        let shipUndefinedTile = tileGroups.first(where: {$0.name == "ShipUndefined"})

        let column = gamePlayFieldLayer2.tileColumnIndex(fromPosition: location)
        let row = gamePlayFieldLayer2.tileRowIndex(fromPosition: location)
        
        //FIXME: für test
        //print("row=",row,"  column=",column)
        
        if !playGameFieldRectLocal.contains(location) {
            // es wurde ausserhalb des Spielfeldes getippt
            gamePlayFieldLayer1.isHidden = !gamePlayFieldLayer1.isHidden
            gamePlayFieldLayer2.isHidden = !gamePlayFieldLayer2.isHidden
            gamePlaySecuredFieldsLayer.isHidden = !gamePlaySecuredFieldsLayer.isHidden
            return
        }
        
        // hier geht es weiter, wenn location innerhalb des playGameField ist
        if securedFields.contains(where: {return (row:row,column:column) == $0}) {
            return
        }
        
        
        if let tile = gamePlayFieldLayer2.tileDefinition(atColumn: column, row: row) {
            if tile.name!.contains("Ship") {
                gamePlayFieldLayer2.setTileGroup(nil, forColumn: column, row: row)
            }
            if tile.name == "Water" {
                gamePlayFieldLayer2.setTileGroup(shipUndefinedTile, forColumn: column, row: row)
            }
        } else {
            // Feld ist leer
            gamePlayFieldLayer2.setTileGroup(waterTile, forColumn: column, row: row)
        }
        // changeShipFieldsIfNeeded
        changeShipFieldsIfNeeded()
        
    }
}

//TODO: muss angepaßt werden

#if os(iOS)
    // Touch-based event handling
    extension GameScene {
        
        
        @objc func handlePanFrom(recognizer : UIPanGestureRecognizer) {
            var location = recognizer.location(in: recognizer.view)
            if recognizer.state == .began {
                print("handlePanFrom: .began")
                // eigentlich gibt es hier nichs zu tun
                location = self.convertPoint(fromView: location)
                
            } else if recognizer.state == .changed {
                print("handlePanFrom: .changed")
                location = self.convertPoint(fromView: location)
                
            } else if recognizer.state == .ended {
                print("handlePanFrom: .ended")
                location = self.convertPoint(fromView: location)
                
            }
        }
        
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else {
                return
            }
            
            var location = touch.location(in: self)
            //print("touched location:",location)
            location = self.convert(location, to: gamePlayField)
            //print("playField location:",location)
            
            handleUserAction(location: location)
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //Swift.print("touchesEnded")
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            //Swift.print("touchesCancelled")
        }
        
    }
#endif

#if os(OSX)
    // Mouse-based event handling
    extension GameScene {
        
        override func mouseDown(with theEvent: NSEvent) {
            /* Called when a mouse click occurs */
            var location = theEvent.location(in: self)
            //print("location:",location)
            location = self.convert(location, to: gamePlayFieldLayer2)
            //print("playField location:",location)
            
            handleUserAction(location: location)

        }
        
        override  func mouseDragged(with theEvent: NSEvent) {
            //let location = theEvent.location(in: self)
            
        }
        
        override func mouseUp(with theEvent: NSEvent) {
            //Swift.print("mouse up position:",location)
            
        }


    }
#endif

