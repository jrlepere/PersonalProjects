//
//  ProfileViewController.swift
//  Bold Sports
//
//  Created by Jake Lepere on 7/25/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

/**
 View controller for the users profile
 */
class ProfileViewController: UIViewController, KumulosDelegate {

    // User Info
    var userInfo: UserInfo!
    
    // Kumulos
    let K = Kumulos()
    
    // Outlets
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var viewMyPredictions: UIButton!
    @IBOutlet var dateJoined: UITextField!
    @IBOutlet var totalVotesGiven: UITextField!
    @IBOutlet var noWaysRecieved: UITextField!
    @IBOutlet var maybesRecieved: UITextField!
    @IBOutlet var obviouslysRecieved: UITextField!
    @IBOutlet var userBarGraphView: UIView!
    @IBOutlet var logoutButton: UIButton!
    
    // Activity Indicator
    var processingIndicator: UIActivityIndicatorView!
    
    /**
     Preforms when the view is loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Kumulos
        K.delegate = self
        
        // Get userInfo
        userInfo = (self.tabBarController as! MainTabBarController).userInfo
        
        // Outlets: userernameLabel
        self.usernameLabel.text = ""
        
        // Buttons
        viewMyPredictions.layer.borderWidth = 1
        viewMyPredictions.layer.borderColor = UIColor.blackColor().CGColor
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.blackColor().CGColor
        
        // Activity Indicator
        let centerPoint = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        processingIndicator = UIActivityIndicatorView(frame: CGRect(origin: centerPoint, size: CGSize(width: 0, height: 0)))
        processingIndicator.transform = CGAffineTransformMakeScale(2, 2)
        processingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        processingIndicator.hidesWhenStopped = true
        self.view.addSubview(processingIndicator)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Preforms when the view appears
     */
    override func viewDidAppear(animated: Bool) {
        
        for subview in self.userBarGraphView.subviews {
            
            subview.removeFromSuperview()
            
        }
        
        ProcessingIndicator.startProcessingIndicator(processingIndicator, viewsToHide: [viewMyPredictions, logoutButton])
        
        K.getUserByUsernameWithUsername(userInfo.username)
        
    }
    
    /**
     Kumulos Delegate. Updates the view with user info.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getUserByUsernameDidCompleteWithResult theResults: [AnyObject]!) {
        
        let data = theResults[0]
        
        let username = data["username"] as! String
        let password = data["password"] as! String
        let noWayCount = data["noWayCount"] as! Int
        let maybeCount = data["maybeCount"] as! Int
        let obviouslyCount = data["obviouslyCount"] as! Int
        let totalVotesCount = data["totalVotes"] as! Int
        let timeCreated = data["timeCreated"] as! NSDate
        let userPollID = data["userID"] as! Int
        
        userInfo = UserInfo(username: username, password: password, maybeCount: maybeCount, noWayCount: noWayCount, obviouslyCount: obviouslyCount, totalVotes: totalVotesCount, dateCreated: timeCreated, userPollID: userPollID)
        
        updateViews()
        
    }
    
    func updateViews() {
        
        // Outlets
        self.totalVotesGiven.text = "Total Votes Made: \(userInfo.totalVotesCount)"
        self.noWaysRecieved.text = "No Way Votes Recieved: \(userInfo.noWayCount)"
        self.maybesRecieved.text = "Maybe Votes Recieved: \(userInfo.maybeCount)"
        self.obviouslysRecieved.text = "Obviously Votes Recieved: \(userInfo.obviouslyCount)"
        self.userBarGraphView.layer.borderWidth = 0.5
        self.userBarGraphView.layer.borderColor = UIColor.blackColor().CGColor
        
        // Outlets: usernameLabel
        self.usernameLabel.text = userInfo.username
        self.usernameLabel.adjustsFontSizeToFitWidth = true
        self.usernameLabel.allowsDefaultTighteningForTruncation = true
        
        // Outlets: Date Joined
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        let dateJoinedText = formatter.stringFromDate(userInfo.dateCreated)
        self.dateJoined.text = "Date Joined: \(dateJoinedText)"
        
        
        // Updates the bar graph
        if ((userInfo.noWayCount + userInfo.maybeCount + userInfo.obviouslyCount) > 0) {
            let barGraphSubViews = VotesBarGraph.generateViews(userInfo.noWayCount, maybeCount: userInfo.maybeCount, obviouslyCount: userInfo.obviouslyCount, meterViewFrame: userBarGraphView.frame)
            
            self.userBarGraphView.addSubview(barGraphSubViews.noWayBar)
            self.userBarGraphView.addSubview(barGraphSubViews.maybeBar)
            self.userBarGraphView.addSubview(barGraphSubViews.obviouslyBar)
            self.userBarGraphView.addSubview(barGraphSubViews.textView)
        } else {
            let noPredictionText = UILabel(frame: CGRect(x: 0, y: 0, width: self.userBarGraphView.frame.width, height: userBarGraphView.frame.height))
            noPredictionText.text = "No Votes Recieved!"
            noPredictionText.textAlignment = NSTextAlignment.Center
            noPredictionText.userInteractionEnabled = false
            userBarGraphView.addSubview(noPredictionText)
        }
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [viewMyPredictions, logoutButton])
    }
    
    /**
     Action for the log out button. Logs the user out and sends them back to the home screen.
     */
    @IBAction func logoutPressed(sender: UIButton) {
        
        self.navigationController?.navigationBar.hidden = false
        
        UserDefault.directLogInDeActivate()
        
        self.tabBarController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    /**
     Action for the view my predictions
     */
    @IBAction func viewUserPredictions(sender: UIButton) {
        
        ProcessingIndicator.startProcessingIndicator(processingIndicator, viewsToHide: [viewMyPredictions, logoutButton])
        
        // Get predictions by Username
        K.getPredictionsByUserWithUsername(self.userInfo.username)
        
    }
    
    /**
     Kumulos Delegate. Gets all the predictins made by the current user. Occurs after the user presses the view my prediction button.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getPredictionsByUserDidCompleteWithResult theResults: [AnyObject]!) {
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [viewMyPredictions, logoutButton])
        
        if (theResults.isEmpty) {
            
            let noPredictionsAlert = UIAlertController(title: "No Predictions", message: "Whoops, you have not made any predictions. Create one at the 'New' tab.", preferredStyle: .Alert)
            noPredictionsAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(noPredictionsAlert, animated: true, completion: nil)
            
        } else {
            let userPredictions = Predictions()
            
            for result in theResults {
                
                userPredictions.addPrediction(Predictions.extractPredictionData(result))
                
            }
            
            let userPredictionsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserPredictionsView") as! UserPredictionTableViewController
            userPredictionsViewController.userPredictions = userPredictions
            //self.showViewController(userPredictionsViewController, sender: self)
            self.navigationController?.showViewController(userPredictionsViewController, sender: self)
            
        }
        
    }
    
    /**
     Kumulos Delegate. Preforms when there was an error processing information.
     */
    func kumulosAPI(kumulos: kumulosProxy!, apiOperation operation: KSAPIOperation!, didFailWithError theError: String!) {
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [viewMyPredictions, logoutButton])
        
        let errorAlert = UIAlertController(title: "Error", message: "There was an error processing information. Please try again or restart the application.", preferredStyle: .Alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
        
    }
    
}

