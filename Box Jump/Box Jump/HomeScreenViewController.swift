//
//  HomeScreenViewController.swift
//  Box Jump
//
//  Created by Jake Lepere on 6/27/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    @IBOutlet var playGameButton:UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var highScoreLabel: UILabel!
    @IBOutlet var highScoreValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let high_score = defaults.integerForKey(UserData.highscore)
        highScoreValueLabel.text = "\(high_score)"
                
        playGameButton.sizeToFit()
        titleLabel.sizeToFit()
        highScoreLabel.sizeToFit()
        highScoreValueLabel.sizeToFit()
        
        playGameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel.adjustsFontSizeToFitWidth = true
        highScoreLabel.adjustsFontSizeToFitWidth = true
        highScoreValueLabel.adjustsFontSizeToFitWidth = true
        
        playGameButton.titleLabel?.allowsDefaultTighteningForTruncation = true
        titleLabel.allowsDefaultTighteningForTruncation = true
        highScoreLabel.allowsDefaultTighteningForTruncation = true
        highScoreValueLabel.allowsDefaultTighteningForTruncation = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let high_score = defaults.integerForKey(UserData.highscore)
        highScoreValueLabel.text = "\(high_score)"
        
    }
    
    @IBAction func playGame(sender: UIButton) {
        let gameViewController = storyboard?.instantiateViewControllerWithIdentifier("GameViewController")
        self.navigationController?.pushViewController(gameViewController!, animated: true)
    }
}
