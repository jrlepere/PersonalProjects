//
//  SecondViewController.swift
//  Can't Decide
//
//  Created by Jake Lepere on 12/4/15.
//  Copyright © 2015 Jake Lepere. All rights reserved.
//

import UIKit

class SecondViewController_AddChoice: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var choiceText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Executes the code when the Add Choice button is pressed
    @IBAction func addChoiceButtonPressed(sender: UIButton) {
        if choiceText.text != "" {
            choiceMgr.addChoice(choiceText.text!)
            choiceText.text = ""
        }
    }
    
    //Removes the keyboard when you press outside the text input area
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

