//
//  FriendsViewController.swift
//  Bold Sports
//
//  Created by Jake Lepere on 8/21/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, KumulosDelegate {
    
    // Outlets
    @IBOutlet var userFriendsSearchBar: UISearchBar!
    @IBOutlet var userFriendsTableView: UITableView!
    @IBOutlet var pendingRequestsButton: UIButton!
    @IBOutlet var addNewFriendButton: UIButton!
    
    // Kumulos
    let K = Kumulos()
    
    // Activity Indicator
    var processingIndicator: UIActivityIndicatorView!
    
    // Variables
    var allFriendsInfoArray:[UserInfo]!
    var friendsInfoArrayBySearch:[Int]!
    var pendingRequestsArray:[String]!
    var userID: Int!
    var pendingRequestsLoaded:BooleanType!
    var numberOfPendingLabel: UILabel!
    var indexBySearchToDelete:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Kumulos
        K.delegate = self
        
        // Outlets: Search Bar
        self.userFriendsSearchBar.delegate = self
        
        // Outlets: Table View
        self.userFriendsTableView.delegate = self
        self.userFriendsTableView.dataSource = self
        
        // Friends Array
        allFriendsInfoArray = []
        friendsInfoArrayBySearch = []
        pendingRequestsArray = []
        
        // Keyboard
        let removeKeyBoardTap = UITapGestureRecognizer(target: self, action: #selector(FriendsViewController.removeKeyBoardTap(_:)))
        let removeKeyBoardSwipe = UISwipeGestureRecognizer(target: self, action: #selector(FriendsViewController.removeKeyBoardSwipe(_:)))
        removeKeyBoardSwipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(removeKeyBoardTap)
        self.view.addGestureRecognizer(removeKeyBoardSwipe)
        
        // Activity Indicator
        let centerPoint = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        processingIndicator = UIActivityIndicatorView(frame: CGRect(origin: centerPoint, size: CGSize(width: 0, height: 0)))
        processingIndicator.transform = CGAffineTransformMakeScale(2, 2)
        processingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        processingIndicator.hidesWhenStopped = true
        self.view.addSubview(processingIndicator)
        
        // userID
        userID = (self.tabBarController as! MainTabBarController).userInfo.userPollID
        
        // Pending Requests label
        numberOfPendingLabel = UILabel()
        
        // Delete var
        indexBySearchToDelete = 0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        removeTapGestures()
        
        pendingRequestsLoaded = false
        
        ProcessingIndicator.startProcessingIndicator(processingIndicator, viewsToHide: [userFriendsSearchBar, userFriendsTableView, pendingRequestsButton, addNewFriendButton])
        
        self.userFriendsSearchBar.text = ""
        
        allFriendsInfoArray.removeAll()
        friendsInfoArrayBySearch.removeAll()
        pendingRequestsArray.removeAll()
        
        K.getFriendsOfByRequestWithUsername((self.tabBarController as! MainTabBarController).userInfo.username, andRequestAccepted: true)
        
        K.getFriendsByUserWithFriend(UInt(userID), andRequestAccepted: false)
        
        numberOfPendingLabel.hidden = true
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        friendsInfoArrayBySearch.removeAll()
        var count = 0
        
        if searchText == "" {
            
            for _ in allFriendsInfoArray {
                
                friendsInfoArrayBySearch.append(count)
                count += 1
                
            }
            
        } else {
        
            for friend in allFriendsInfoArray {
            
                if (friend.username.lowercaseString.containsString(searchText.lowercaseString)) {
                    friendsInfoArrayBySearch.append(count)
                }
                count += 1
            
            }
        }
        
        userFriendsTableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        removeTapGestures()
        self.userFriendsTableView.userInteractionEnabled = true
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        addTapGestures()
        self.userFriendsTableView.userInteractionEnabled = false
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        removeTapGestures()
        self.userFriendsTableView.userInteractionEnabled = true
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        friendsInfoArrayBySearch.removeAll()
        var count = 0
            
        for _ in allFriendsInfoArray {
                
            friendsInfoArrayBySearch.append(count)
            count += 1
                
        }
        
        removeTapGestures()
        self.userFriendsTableView.userInteractionEnabled = true
        self.view.endEditing(true)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsInfoArrayBySearch.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "")
        cell.textLabel?.text = allFriendsInfoArray[friendsInfoArrayBySearch[indexPath.row]].username
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let userInfo = allFriendsInfoArray[friendsInfoArrayBySearch[indexPath.row]]
        
        let userViewController = self.storyboard?.instantiateViewControllerWithIdentifier("IndividualFriendView") as! IndividualFriendView
        userViewController.userInfo = userInfo
        self.navigationController?.showViewController(userViewController, sender: self)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            indexBySearchToDelete = indexPath.row
            
            let friend = allFriendsInfoArray[friendsInfoArrayBySearch[indexBySearchToDelete]]
            
            let deleteFriendAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete \(friend.username) as a freind?", preferredStyle: .Alert)
            
            deleteFriendAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (UIAlertAction) in
                
                ProcessingIndicator.startProcessingIndicator(self.processingIndicator, viewsToHide: [self.userFriendsSearchBar, self.userFriendsTableView, self.pendingRequestsButton, self.addNewFriendButton])
                
                self.K.deleteFriendOfWithUsername((self.tabBarController as! MainTabBarController).userInfo.username, andFriend: UInt(friend.userPollID))
                
            }))
            deleteFriendAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
            self.presentViewController(deleteFriendAlert, animated: true, completion: nil)
            
        }
        
    }
    
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, deleteFriendOfDidCompleteWithResult affectedRows: NSNumber!) {
        
        allFriendsInfoArray.removeAtIndex(friendsInfoArrayBySearch[indexBySearchToDelete])
        
        userFriendsSearchBar.text = ""
        friendsInfoArrayBySearch.removeAll()
        var count = 0
        for _ in allFriendsInfoArray {
            
            friendsInfoArrayBySearch.append(count)
            count += 1
            
        }
        
        userFriendsTableView.reloadData()
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [userFriendsSearchBar, userFriendsTableView, pendingRequestsButton, addNewFriendButton])
        
    }
    
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getFriendsOfByRequestDidCompleteWithResult theResults: [AnyObject]!) {
        
        var count = 0
        for friend in theResults {
            
            let friendData = friend["friend"]!
            allFriendsInfoArray.append(UserInfo.getUserData(friendData!))
            friendsInfoArrayBySearch.append(count)
            count += 1
            
        }
            
        userFriendsTableView.reloadData()
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [userFriendsSearchBar, userFriendsTableView, pendingRequestsButton, addNewFriendButton])
        
    }
    
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getFriendsByUserDidCompleteWithResult theResults: [AnyObject]!) {
        
        pendingRequestsArray.removeAll()
        
        for friend in theResults {
            
            let friendUsername = friend["username"] as! String
            
            pendingRequestsArray.append(friendUsername)
            
        }
        
        let frame = self.pendingRequestsButton.frame
        let minX = frame.minX
        let minX_2 = minX/2
        numberOfPendingLabel = UILabel(frame: CGRect(x: frame.maxX - minX_2, y: frame.minY - minX_2, width: minX, height: minX))
        numberOfPendingLabel.text = "\(pendingRequestsArray.count)"
        numberOfPendingLabel.textAlignment = NSTextAlignment.Center
        numberOfPendingLabel.adjustsFontSizeToFitWidth = true
        numberOfPendingLabel.layer.backgroundColor = UIColor.redColor().CGColor
        if (pendingRequestsArray.count > 0) {
            numberOfPendingLabel.hidden = false
        } else {
            numberOfPendingLabel.hidden = true
        }
        self.view.addSubview(numberOfPendingLabel)
        
        pendingRequestsLoaded = true
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [userFriendsSearchBar, userFriendsTableView, pendingRequestsButton, addNewFriendButton])
        
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
    
    @IBAction func pendingRequestsPressed(sender: UIButton) {
        
        if pendingRequestsLoaded.boolValue {
            
            let pendingRequestViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PendingRequests") as! PendingRequestViewController
            pendingRequestViewController.pendingRequestsArray = pendingRequestsArray
            self.navigationController?.showViewController(pendingRequestViewController, sender: self)
            
        }
        
    }
    
    @IBAction func addNewUserPressed(sender: UIButton) {
        
        let addNewUserController = self.storyboard?.instantiateViewControllerWithIdentifier("NewFriendsViewController") as! NewFriendsViewController
        
        self.navigationController?.showViewController(addNewUserController, sender: true)
        
    }
    
    func addTapGestures() {
        
        for gesture in self.view.gestureRecognizers! {
            
            gesture.enabled = true
            
        }
        
    }
    
    func removeTapGestures() {
        
        for gesture in self.view.gestureRecognizers! {
            
            gesture.enabled = false
            
        }
        
    }
    
}
