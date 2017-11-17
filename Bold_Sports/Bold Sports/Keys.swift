//
//  Keys.swift
//  Bold Sports
//
//  Created by Jake Lepere on 8/11/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import Foundation

struct Keys {
    
    static let directLogInKey = "DirectLogIn"
    static let usernameKey = "usernameKey"
    
}

class UserDefault {
    
    static func directLogInActivate(username: [String]) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setBool(true, forKey: Keys.directLogInKey)
        defaults.setObject(username, forKey: Keys.usernameKey)
        
    }
    
    static func directLogInDeActivate() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setBool(false, forKey: Keys.directLogInKey)
        defaults.setObject(["",""], forKey: Keys.usernameKey)
        
    }
    
    static func getDirectLogInInfo() -> (shouldDirectLogIn: Bool, username: String, userID: Int) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let shouldDirectLogIn = defaults.boolForKey(Keys.directLogInKey)
        if let username = defaults.stringArrayForKey(Keys.usernameKey) {
            if username.count > 1 && username[1] != ""{
                return (shouldDirectLogIn: shouldDirectLogIn, username: username[0], Int(username[1])!)
            } else {
                return (shouldDirectLogIn: false, username: "", 0)
            }
            
        }
        
        return (shouldDirectLogIn: shouldDirectLogIn, username: "", userID: 0)
        
    }
    
}