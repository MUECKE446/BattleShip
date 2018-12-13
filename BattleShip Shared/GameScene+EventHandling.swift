//
//  GameScene+EventHandling.swift
//  Block One
//
//  Created by Christian Muth on 01.10.16.
//  Copyright © 2016 Christian Muth. All rights reserved.
//

import Foundation
import SpriteKit

//TODO: muss angepaßt werden

#if os(iOS)
    // Touch-based event handling
    extension GameScene {
        
        
        @objc func handlePanFrom(recognizer : UIPanGestureRecognizer) {
            var location = recognizer.location(in: recognizer.view)
            if recognizer.state == .began {
                //Swift.print("handlePanFrom: .began")
                // eigentlich gibt es hier nichs zu tun
                location = self.convertPoint(fromView: location)
                
            } else if recognizer.state == .changed {
                //Swift.print("handlePanFrom: .changed")
                location = self.convertPoint(fromView: location)
                
            } else if recognizer.state == .ended {
                //Swift.print("handlePanFrom: .ended")
               location = self.convertPoint(fromView: location)
                
            }
        }
        
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            //Swift.print("touchesBegan",touches.count)
            
            guard let touch = touches.first else {
                return
            }
            
            let location = touch.location(in: self)
            //Swift.print("location",location)
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
            let location = theEvent.location(in: self)
            //Swift.print("mouse down position:",location)
            
        }
        
        override  func mouseDragged(with theEvent: NSEvent) {
            let location = theEvent.location(in: self)
            
        }
        
        override func mouseUp(with theEvent: NSEvent) {
            //Swift.print("mouse up position:",location)
            
        }


    }
#endif

