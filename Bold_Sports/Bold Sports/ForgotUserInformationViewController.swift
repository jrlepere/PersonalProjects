//
//  ForgotUserInformationViewController.swift
//  Bold Sports
//
//  Created by Jake Lepere on 7/31/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit
import MessageUI

/**
 A class for the forgot information view controller.
 */
class ForgotUserInformationViewController: UIViewController, KumulosDelegate {
    
    // Outlets
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var sendInformationButton: UIButton!
    
    // Kumulos
    let K = Kumulos()
    
    /**
     Preforms when the view controller is loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Kumulos
        K.delegate = self
        
        // Navigation Title
        self.navigationItem.title = "Forgot Password"
        
        // KeyBoard release
        let removeKeyBoardTap = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.removeKeyBoardTap(_:)))
        let removeKeyBoardSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LogInViewController.removeKeyBoardSwipe(_:)))
        removeKeyBoardSwipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(removeKeyBoardTap)
        self.view.addGestureRecognizer(removeKeyBoardSwipe)
    }
    
    /**
     Preforms when the user taps the send info button. Emails the user their respective information.
     */
    @IBAction func sendInformationPressed(sender: UIButton) {
        
        let inputtedUsername = usernameTextField.text
        let inputtedEmail = emailTextField.text
        
        K.getPasswordWithUsername(inputtedUsername, andEmail: inputtedEmail)
        
    }
    
    /**
     Remove the keyboard from the screen after a tap
     */
    func removeKeyBoardTap(sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        
    }
    
    /**
     Remove the keyboard from the screen after a swipe down
     */
    func removeKeyBoardSwipe(sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        
    }
    
    /**
     Kumulos Delegate. Gets the user data from the inputted username and email.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getPasswordDidCompleteWithResult theResults: [AnyObject]!) {
        
        if theResults.count == 0 {
            // Invalid Input
            
            let invalidInputAlert = UIAlertController(title: "Invalid Input", message: "The username or email you entered was incorrect.", preferredStyle: .Alert)
            invalidInputAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(invalidInputAlert, animated: true, completion: nil)
            
        } else {
            // The user inputted valid information
            
            let data = theResults[0]
            let username = data["username"]
            let password = data["password"]
            print("username: \(username)")
            print("password: \(password)")
            
            
        }
        
    }
    
}
