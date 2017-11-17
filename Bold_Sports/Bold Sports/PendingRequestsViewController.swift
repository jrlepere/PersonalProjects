//
//  PendingRequestsViewController.swift
//  Bold Sports
//
//  Created by Jake Lepere on 8/23/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

class PendingRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, KumulosDelegate {
    
    // Outlets
    @IBOutlet var pendingRequestsTableView: UITableView!
    
    // Kumulos
    let K = Kumulos()
    
    // Additional
    var pendingRequestsArray: [String]!
    var pressedIndex:Int!
    
    // Active Indication
    var processingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Kumulos
        K.delegate = self
        
        // Outlets
        pendingRequestsTableView.delegate = self
        pendingRequestsTableView.dataSource = self
        
        // Navigation Bar
        self.navigationItem.title = "Pending Requests"
        
        // Additional
        pressedIndex = 0
        
        // Activity Indicator
        let centerPoint = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        processingIndicator = UIActivityIndicatorView(frame: CGRect(origin: centerPoint, size: CGSize(width: 0, height: 0)))
        processingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        processingIndicator.transform = CGAffineTransformMakeScale(2, 2)
        processingIndicator.hidesWhenStopped = true
        self.view.addSubview(processingIndicator)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pendingRequestsArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "")
        cell.textLabel?.text = pendingRequestsArray[indexPath.row]
        
        pressedIndex = indexPath.row
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let userPollID = (self.tabBarController as! MainTabBarController).userInfo.userPollID
        let username = pendingRequestsArray[indexPath.row]
        
        let pendingRequestAlert = UIAlertController(title: "Pending Request", message: "What would you like to do with \(username)'s friend request?", preferredStyle: .Alert)
        pendingRequestAlert.addAction(UIAlertAction(title: "Accept", style: .Default, handler: { (UIAlertAction) in
            ProcessingIndicator.startProcessingIndicator(self.processingIndicator, viewsToHide: [self.pendingRequestsTableView])
            
            self.K.acceptFriendRequestWithUsername(username, andFriend: UInt(userPollID), andSetTrue: true)
        }))
        pendingRequestAlert.addAction(UIAlertAction(title: "Decline", style: .Default, handler: { (UIAlertAction) in
            
            self.K.deleteFriendOfWithUsername(username, andFriend: UInt(userPollID))
            
        }))
        pendingRequestAlert.addAction(UIAlertAction(title: "Postpone", style: .Default, handler: nil))
        self.presentViewController(pendingRequestAlert, animated: true, completion: nil)
        
    }
    
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, acceptFriendRequestDidCompleteWithResult affectedRows: NSNumber!) {
        
        // Successfully accepted friends request
        K.getUserByUsernameWithUsername(pendingRequestsArray[pressedIndex])
        
    }
    
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, deleteFriendOfDidCompleteWithResult affectedRows: NSNumber!) {
        
        pendingRequestsArray.removeAtIndex(pressedIndex)
        self.pendingRequestsTableView.reloadData()
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [pendingRequestsTableView])
        
        let successAlert = UIAlertController(title: "Deleted", message: "You have successfully deleted the friend request!", preferredStyle: .Alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(successAlert, animated: true, completion: nil)
        
    }
    
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getUserByUsernameDidCompleteWithResult theResults: [AnyObject]!) {
        
        if theResults.count == 1 {
            
            let userID = theResults[0]["userID"] as! Int
            K.createFriendRequestWithUsername((self.tabBarController as! MainTabBarController).userInfo.username, andFriend: UInt(userID), andRequestedFalse: true)
            
        } else {
            
            let errorAlert = UIAlertController(title: "Error", message: "There was an error processing information.", preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
            
        }
        
    }
    
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, createFriendRequestDidCompleteWithResult newRecordID: NSNumber!) {
        
        pendingRequestsArray.removeAtIndex(pressedIndex)
        self.pendingRequestsTableView.reloadData()
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [pendingRequestsTableView])
        
        let successAlert = UIAlertController(title: "Success", message: "You have successfully accepted the friend request!", preferredStyle: .Alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(successAlert, animated: true, completion: nil)
        
    }
    
    /**
     Kumulos Delegate. Preforms when there was an error processing information.
     */
    func kumulosAPI(kumulos: kumulosProxy!, apiOperation operation: KSAPIOperation!, didFailWithError theError: String!) {
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [pendingRequestsTableView])
        
        let errorAlert = UIAlertController(title: "Error", message: "There was an error processing information. Please try again or restart the application.", preferredStyle: .Alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
        
    }
    
}
