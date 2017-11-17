//
//  NewFriendsViewController.swift
//  Bold Sports
//
//  Created by Jake Lepere on 8/24/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

class NewFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, KumulosDelegate {
    
    // Outlets
    @IBOutlet var addUserSearchBar: UISearchBar!
    @IBOutlet var addUserTableView: UITableView!
    
    // Kumulos
    let K = Kumulos()
    
    // Additional
    var addUserArray:[UserInfo]!
    let minCharacters = 1
    var predictionUserID: UInt!
    var usernameOfFriendRequested: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Outlets: Search Bar
        self.addUserSearchBar.delegate = self
        
        // Outlets: Table View
        self.addUserTableView.delegate = self
        self.addUserTableView.dataSource = self
        self.addUserTableView.hidden = true
        
        // Kumulos
        K.delegate = self
        
        addUserArray = []
        predictionUserID = 0
        usernameOfFriendRequested = ""
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addUserArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "")
        cell.textLabel?.text = addUserArray[indexPath.row].username
        
        return cell
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let searchText = searchBar.text
        
        if searchText?.characters.count < minCharacters {
        
            let characterLengthAlert = UIAlertController(title: "Error", message: "Please enter at least \(minCharacters) characters.", preferredStyle: .Alert)
            characterLengthAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(characterLengthAlert, animated: true, completion: nil)
            
        } else {
            
            self.addUserArray.removeAll()
            
            K.searchUsernameWithUsername(searchText)
            
        }
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        searchBar.text = ""
        self.addUserTableView.hidden = true
        
    }
    
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, searchUsernameDidCompleteWithResult theResults: [AnyObject]!) {
        
        for userData in theResults {
            
            let userInfo = UserInfo.getUserData(userData)
            addUserArray.append(userInfo)
            
        }
        
        addUserArray.sortInPlace { (UserInfoA, UserInfoB) -> Bool in
            
            if (UserInfoA.username.lowercaseString.compare(UserInfoB.username.lowercaseString)) == NSComparisonResult.OrderedAscending {
                return true
            }
            return false
            
        }
        
        self.addUserTableView.hidden = false
        
        self.view.endEditing(true)
        self.addUserTableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        usernameOfFriendRequested = addUserArray[indexPath.row].username
        
        let requestAlert = UIAlertController(title: "Friend Request", message: "Would you like to send \(usernameOfFriendRequested) a friend request?", preferredStyle: .Alert)
        requestAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (UIAlertAction) in
            self.predictionUserID = UInt(self.addUserArray[indexPath.row].userPollID)
            self.K.checkIfFriendsWithUsername((self.tabBarController as! MainTabBarController).userInfo.username, andFriend: self.predictionUserID)
        }))
        requestAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController(requestAlert, animated: true, completion: nil)
        
    }
    
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, checkIfFriendsDidCompleteWithResult theResults: [AnyObject]!) {
        
        if theResults.count > 0 {
            // Friend request either sent or pending
            
            let requested = theResults[0]["requestAccepted"] as! Bool
            
            if requested {
                // already friends
                let alreadyFriendsAlert = UIAlertController(title: "Already Friends", message: "You are already friends!", preferredStyle: .Alert)
                alreadyFriendsAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alreadyFriendsAlert, animated: true, completion: nil)
                
            } else {
                // pending
                let pendingAlert = UIAlertController(title: "Pending", message: "The status of your friend request with \(usernameOfFriendRequested) is pending.", preferredStyle: .Alert)
                pendingAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(pendingAlert, animated: true, completion: nil)
                
            }
            
        } else {
            
            K.createFriendRequestWithUsername((self.tabBarController as! MainTabBarController).userInfo.username, andFriend: predictionUserID, andRequestedFalse: false)
            
        }
        
    }
    
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, createFriendRequestDidCompleteWithResult newRecordID: NSNumber!) {
        
        let friendRequestSuccess = UIAlertController(title: "Success", message: "You have successfully send \(usernameOfFriendRequested) a friend request!", preferredStyle: .Alert)
        friendRequestSuccess.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(friendRequestSuccess, animated: true, completion: nil)
        
    }
    
}
