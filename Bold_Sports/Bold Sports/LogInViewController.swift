//
//  LogInViewController.swift
//  Bold Sports
//
//  Created by Jake Lepere on 7/26/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

/**
 The view controller for the log in menu
 */
class LogInViewController: UIViewController, KumulosDelegate {
    
    // Outlets for the view controller
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var spectateButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    // Kumulos
    let K = Kumulos()
    
    // Active Indication
    var processingIndicator: UIActivityIndicatorView!
    
    /**
     Preforms when the view is loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Kumulos
        K.delegate = self
        
        // Title Label 
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.allowsDefaultTighteningForTruncation = true
        
        // Buttons
        logInButton.layer.borderWidth = 1
        logInButton.layer.borderColor = UIColor.blackColor().CGColor
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.blackColor().CGColor
        spectateButton.layer.borderWidth = 1
        spectateButton.layer.borderColor = UIColor.blackColor().CGColor
        
        // KeyBoard release
        let removeKeyBoardTap = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.removeKeyBoardTap(_:)))
        let removeKeyBoardSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LogInViewController.removeKeyBoardSwipe(_:)))
        removeKeyBoardSwipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(removeKeyBoardTap)
        self.view.addGestureRecognizer(removeKeyBoardSwipe)
        
        // Activity Indicator
        let centerPoint = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        processingIndicator = UIActivityIndicatorView(frame: CGRect(origin: centerPoint, size: CGSize(width: 0, height: 0)))
        processingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        processingIndicator.transform = CGAffineTransformMakeScale(2, 2)
        processingIndicator.hidesWhenStopped = true
        self.view.addSubview(processingIndicator)
        
        // Navigation Controller
        
        // Direct Log in
        let directLogInInfo: (shouldDirectLogIn: Bool, username: String, userID: Int) = UserDefault.getDirectLogInInfo()
        if (directLogInInfo.shouldDirectLogIn) {
            // Direct Log In the previous user
            let username = directLogInInfo.username
            let userPollID = directLogInInfo.userID
            
            ProcessingIndicator.startProcessingIndicator(self.processingIndicator, viewsToHide: [usernameTextField, passwordTextField, logInButton, signUpButton, spectateButton])
            
            self.usernameTextField.text = username
            let mainTabBar = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBar") as! MainTabBarController
            mainTabBar.userInfo = UserInfo(username: username, password: "", maybeCount: 0, noWayCount: 0, obviouslyCount: 0, totalVotes: 0, dateCreated: NSDate(), userPollID: userPollID)
            self.presentViewController(mainTabBar, animated: true, completion: nil)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Preforms when the view appears
     */
    override func viewDidAppear(animated: Bool) {
        
        self.passwordTextField.text = ""
        ProcessingIndicator.stopProcessingIndicator(self.processingIndicator, viewsToUnHide: [usernameTextField, passwordTextField, logInButton, signUpButton, spectateButton])
        
    }
    
    /**
     Preforms when the user presses the Log In button. Sends the user to the main tab bar controller if the user has signed in correctly.
     */
    @IBAction func logInPressed(sender: UIButton) {
        
        self.view.endEditing(true)
        
        if emptyUsername() {
            
            showEmptyUsernameAlert()
            
        } else if emptyPassword() {
            
            showEmptyPasswordAlert()
            
        } else {
            
            ProcessingIndicator.startProcessingIndicator(self.processingIndicator, viewsToHide: [usernameTextField, passwordTextField, logInButton, signUpButton, spectateButton])
            
            let username = usernameTextField.text
            let password = Secrets.passwordJumble(passwordTextField.text!)
            
            K.getUserWithUsername(username, andPassword: password)
        }
        
    }
    
    /**
     Performs when the user presses the Sign Up button. Sends the user to the sign up view controller.
     */
    @IBAction func signUpViewController(sender: UIButton) {
        
        let signUpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpView")
        self.navigationController?.showViewController(signUpViewController!, sender: self)
        
    }
    
    /**
     Preforms when the user presses the spectator mode button. Sends the user to the spectator screen.
     */
    @IBAction func spectatorModePressed(sender: UIButton) {
        
        let spectatorViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PollsViewGuest")
        self.navigationController?.showViewController(spectatorViewController!, sender: self)
        
    }
    
    /**
     Checks if the username text field is empty
     @return true if the username field is empty, false otherwise
     */
    func emptyUsername() -> Bool {
        
        return usernameTextField.text!.isEmpty
        
    }
    
    /**
     The user has tried to log in with an empty username
     */
    func showEmptyUsernameAlert() {
        
        let usernameEmptyAlert = UIAlertController(title: "Username Empty", message: "Please enter your username or sign up.", preferredStyle: UIAlertControllerStyle.Alert)
        usernameEmptyAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(usernameEmptyAlert, animated: true, completion: nil)
        
    }
    
    /**
     Checks if the password text field is empty
     @return true if the password text field is empty, false otherwise
     */
    func emptyPassword() -> Bool {
        
        return passwordTextField.text!.isEmpty
        
    }
    
    /**
     The user has tried to log in with an empty password
     */
    func showEmptyPasswordAlert() {
        
        let passwordEmptyAlert = UIAlertController(title: "Password Empty", message: "Please enter your password.", preferredStyle: UIAlertControllerStyle.Alert)
        passwordEmptyAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(passwordEmptyAlert, animated: true, completion: nil)
        
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
     Kumulos Delegate. Gets the user data if the user entered their information correctly.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getUserDidCompleteWithResult theResults: [AnyObject]!) {
        
        ProcessingIndicator.stopProcessingIndicator(self.processingIndicator, viewsToUnHide: [usernameTextField, passwordTextField, logInButton, signUpButton, spectateButton])
        
        if (theResults.count == 0) {
            // User entered information incorrectly
            
            let invalidInformationAlert = UIAlertController(title: "Invalid Information", message: "Please enter your correct username and password! Consider signing up if you haven't done so, or check out guest mode.", preferredStyle: .Alert)
            invalidInformationAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(invalidInformationAlert, animated: true, completion: nil)
            
        } else {
            // User sucessfully logged in
            
            let userInfo = UserInfo.getUserData(theResults[0])
            
            UserDefault.directLogInActivate([userInfo.username, String(userInfo.userPollID)])
            
            let mainTabBar = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBar") as! MainTabBarController
            mainTabBar.userInfo = userInfo
            self.presentViewController(mainTabBar, animated: true, completion: nil)
            
        }
        
    }
    
    /**
     Kumulos Delegate. Preforms when direct log in is activated.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getUserByUsernameDidCompleteWithResult theResults: [AnyObject]!) {
        
        let userInfo = UserInfo.getUserData(theResults[0])
        
        ProcessingIndicator.stopProcessingIndicator(self.processingIndicator, viewsToUnHide: [usernameTextField, passwordTextField, logInButton, signUpButton, spectateButton])
        
        let mainTabBar = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBar") as! MainTabBarController
        mainTabBar.userInfo = userInfo
        self.presentViewController(mainTabBar, animated: true, completion: nil)
        
    }
    
    /**
     Kumulos Delegate. Preforms when there was an error processing information.
     */
    func kumulosAPI(kumulos: kumulosProxy!, apiOperation operation: KSAPIOperation!, didFailWithError theError: String!) {
        
        ProcessingIndicator.stopProcessingIndicator(self.processingIndicator, viewsToUnHide: [usernameTextField, passwordTextField, logInButton, signUpButton, spectateButton])
        
        let errorAlert = UIAlertController(title: "Error", message: "There was an error processing information. Please try again or restart the application.", preferredStyle: .Alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
        
    }

}
