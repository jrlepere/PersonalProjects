//
//  UserInfo.swift
//  Bold Sports
//
//  Created by Jake Lepere on 7/31/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

/**
 A class for the user data after the user logs in successfully.
 */
class UserInfo {
    
    var username: String!
    var password: String!
    var maybeCount: Int!
    var noWayCount: Int!
    var obviouslyCount: Int!
    var totalVotesCount: Int!
    var dateCreated: NSDate!
    var userPollID: Int!
    
    init(username: String, password: String, maybeCount: Int, noWayCount: Int, obviouslyCount: Int, totalVotes: Int, dateCreated: NSDate, userPollID: Int) {
        
        self.username = username
        self.password = password
        self.maybeCount = maybeCount
        self.noWayCount = noWayCount
        self.obviouslyCount = obviouslyCount
        self.totalVotesCount = totalVotes
        self.dateCreated = dateCreated
        self.userPollID = userPollID
        
    }
    
    /**
     Gets the userInfo from Kumulos Data.
     @param data the data from Kumulos
     @return a UserInfo object from provided data
     */
    static func getUserData(data: AnyObject) -> UserInfo {
        
        let username = data["username"] as! String
        let password = data["password"] as! String
        let noWayCount = data["noWayCount"] as! Int
        let maybeCount = data["maybeCount"] as! Int
        let obviouslyCount = data["obviouslyCount"] as! Int
        let totalVotesCount = data["totalVotes"] as! Int
        let timeCreated = data["timeCreated"] as! NSDate
        let userPollID = data["userID"] as! Int
        
        let userInfo = UserInfo(username: username, password: password, maybeCount: maybeCount, noWayCount: noWayCount, obviouslyCount: obviouslyCount, totalVotes: totalVotesCount, dateCreated: timeCreated, userPollID: userPollID)
        
        return userInfo
        
    }

}