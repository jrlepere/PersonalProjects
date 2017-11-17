//
//  HomeViewController.swift
//  Box Jump
//
//  Created by Jake Lepere on 5/22/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        
        
        
    }
    
    @IBAction func playGame(sender: UIButton) {
        
        let gameViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        
        navigationController?.pushViewController(gameViewController, animated: true)
        
    }
    
}
