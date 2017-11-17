//
//  GameViewController.swift
//  Box Jump
//
//  Created by Jake Lepere on 5/22/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit
import SpriteKit

let screenBounds = UIScreen.mainScreen().bounds

class GameViewController: UIViewController {
    
    var previous_x_acceleration:Double = 0
    @IBOutlet var play_game_button: UIButton!
    var skView: SKView = SKView()
    var scene: GameScene!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        
        skView = (self.view as? SKView)!
        // Configure the view.
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    func handleApplicationWillResignActive (note: NSNotification) {
        
        let skView = self.view as! SKView
        skView.paused = true
    }
    
    func handleApplicationDidBecomeActive (note: NSNotification) {
        
        let skView = self.view as! SKView
        skView.paused = false
    }
    
    @IBAction func pressedPlay(sender: UIButton) {
        
        // Create and configure the scene.
        scene = GameScene(size: skView.frame.size)
        scene.parentController = self
        skView.presentScene(scene)
        
        // Pause the view (and thus the game) when the app is interrupted or backgrounded
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.handleApplicationWillResignActive(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.handleApplicationDidBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func restart() {
        
        skView.presentScene(nil)
        
        // Create and configure the scene.
        scene = GameScene(size: skView.frame.size)
        scene.parentController = self
        skView.presentScene(scene)
        
        // Pause the view (and thus the game) when the app is interrupted or backgrounded
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.handleApplicationWillResignActive(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.handleApplicationDidBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
}
