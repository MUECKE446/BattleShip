//
//  GameViewController.swift
//  Block One
//
//  Created by Christian Muth on 22.09.16.
//  Copyright © 2016 Christian Muth. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var scene:GameScene? = nil
    let battleShipGame = BattleShipGame(gridSize: kGridSize)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // initialisiere die Scene
        JKGame.game.setOrientation(JKOrientation.portrait)
        scene = GameScene(size: JKGame.size)
        scene?.gridSize = kGridSize
        //scene = GameScene(size: CGSize(width: 1536, height: 2048))
        let skView = self.view as! SKView

        //TODO: für Testzwecke wieder einblenden
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        // erzeuge ein neues Spiel
        let activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        view.addSubview(activityIndicator)
        activityIndicator.bringSubviewToFront(view)
        activityIndicator.startAnimating()
        battleShipGame.createGame()
        activityIndicator.stopAnimating()
        scene!.showOccupiedFieldsInRowsAndColumns(game: battleShipGame)
        scene!.showShipsInPlayField(game: battleShipGame)
        scene!.showUsedShipsInGame(battleShipGame)
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
