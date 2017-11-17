//
//  SignUpViewController.swift
//  Bold Sports
//
//  Created by Jake Lepere on 7/26/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

/**
 The view controller for signing up.
 */
class SignUpViewController: UIViewController, KumulosDelegate {
    
    // Outlets
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var reEnterPasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    // Kumulos
    let K = Kumulos()
    
    // Active Indication
    var processingIndicator: UIActivityIndicatorView!
    
    // Character Counts
    private let minUsernameCount = 4
    private let maxUsernameCount = 12
    private let minPasswordCount = 4
    private let maxPasswordCount = 12
    
    /**
     Preforms when the view is loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Kumulos
        K.delegate = self
        
        // Navigation Title
        self.navigationItem.title = "Sign Up"
        
        // Buttons
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.blackColor().CGColor
        
        // Activity Indicator
        let centerPoint = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        processingIndicator = UIActivityIndicatorView(frame: CGRect(origin: centerPoint, size: CGSize(width: 0, height: 0)))
        processingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        processingIndicator.transform = CGAffineTransformMakeScale(2, 2)
        processingIndicator.hidesWhenStopped = true
        self.view.addSubview(processingIndicator)
        
        // Keyboard
        let removeKeyBoardTap = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.removeKeyBoardTap(_:)))
        let removeKeyBoardSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LogInViewController.removeKeyBoardSwipe(_:)))
        removeKeyBoardSwipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(removeKeyBoardTap)
        self.view.addGestureRecognizer(removeKeyBoardSwipe)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signUpPressed(sender: UIButton) {
        
        self.view.endEditing(true)
        
        if invalidUsername() {
            showInvalidUsernameAlert()
        } else if invalidPassword() {
            showInvalidPasswordAlert()
        } else if incorrectReEnterPassword() {
            showReEnterPasswordAlert()
        } else {
            ProcessingIndicator.startProcessingIndicator(processingIndicator, viewsToHide: [usernameTextField, passwordTextField, reEnterPasswordTextField, signUpButton])
            K.uniqueUsernameWithUsername(usernameTextField.text)
        }
        
    }
    
    /**
     Checks if the username text field is empty
     @return true if the username text field is empty, false otherwise
     */
    func invalidUsername() -> Bool {
        
        return (usernameTextField.text?.characters.count < minUsernameCount) || (usernameTextField.text?.characters.count > maxUsernameCount)
        
    }
    
    /**
     The user has tried to log in with an empty username
     */
    func showInvalidUsernameAlert() {
        
        let usernameEmptyAlert = UIAlertController(title: "Invalid Username", message: "Your username must be at least \(minUsernameCount) characters and at most \(maxUsernameCount).", preferredStyle: UIAlertControllerStyle.Alert)
        usernameEmptyAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(usernameEmptyAlert, animated: true, completion: nil)
        
    }
    
    /**
     Checks if the password text field is empty
     @return true if the password text field is empty, false otherwise
     */
    func invalidPassword() -> Bool {
        
        return (passwordTextField.text!.characters.count < minPasswordCount) || (passwordTextField.text!.characters.count > maxPasswordCount)
        
    }
    
    /**
     The user has tried to log in with an empty password
     */
    func showInvalidPasswordAlert() {
        
        let passwordEmptyAlert = UIAlertController(title: "Invalid Password", message: "Your password must be at least \(minPasswordCount) characters and at most \(maxPasswordCount).", preferredStyle: UIAlertControllerStyle.Alert)
        passwordEmptyAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(passwordEmptyAlert, animated: true, completion: nil)
        
    }
    
    /**
     Checks if the re enter password is correct
     @return true if the re enter password deos not matches the initial password, else false
     */
    func incorrectReEnterPassword() -> Bool {
        
        return (reEnterPasswordTextField.text! != passwordTextField.text!)
        
    }
    
    /**
     The user has tried to log in with an empty password
     */
    func showReEnterPasswordAlert() {
        
        let reEnterPasswordEmptyAlert = UIAlertController(title: "Passwords Do Not Match", message: "Please re enter your password.", preferredStyle: UIAlertControllerStyle.Alert)
        reEnterPasswordEmptyAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(reEnterPasswordEmptyAlert, animated: true, completion: nil)
        
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
     Kumulos Delegate. Preforms when the user attempts to sign up. Does not allow the user to sign up if the username is already taken.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, uniqueUsernameDidCompleteWithResult theResults: [AnyObject]!) {
        
        if (theResults.count > 0) {
            // The username is already taken
            
            ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [usernameTextField, passwordTextField, reEnterPasswordTextField, signUpButton])
            
            let usernameTakenAlert = UIAlertController(title: "Username Taken", message: "The username is already taken. Please enter a new username", preferredStyle: UIAlertControllerStyle.Alert)
            usernameTakenAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(usernameTakenAlert, animated: true, completion: nil)
        } else {
            // The username is unique. Create a new User.
            let newUsername = usernameTextField.text
            let newPassword = Secrets.passwordJumble(passwordTextField.text!)
            print(newPassword)
            //let newEmail = emailTextField.text
            K.newUserWithUsername(newUsername, andPassword: newPassword, andCount: 0)
        }
        
    }
    
    /**
     Kumulos Delegate. Preforms when creating a new user.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, newUserDidCompleteWithResult newRecordID: NSNumber!) {
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [usernameTextField, passwordTextField, reEnterPasswordTextField, signUpButton])
        
        let successfulSignUpAlert = UIAlertController(title: "Success!", message: "You have successfully signed up with Bold Sports!", preferredStyle: UIAlertControllerStyle.Alert)
        successfulSignUpAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        self.presentViewController(successfulSignUpAlert, animated: true, completion: nil)
        
    }
    
    /**
     Kumulos Delegate. Preforms when there was an error processing information.
     */
    func kumulosAPI(kumulos: kumulosProxy!, apiOperation operation: KSAPIOperation!, didFailWithError theError: String!) {
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [usernameTextField, passwordTextField, reEnterPasswordTextField, signUpButton])
        
        let errorAlert = UIAlertController(title: "Error", message: "There was an error processing information. Please try again or restart the application.", preferredStyle: .Alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
        
    }
    
}
