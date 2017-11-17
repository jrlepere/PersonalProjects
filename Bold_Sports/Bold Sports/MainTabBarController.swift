//
//  MainTabBarController.swift
//  Bold Sports
//
//  Created by Jake Lepere on 7/26/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

/**
 A class for the main tab bar.
 */
class MainTabBarController: UITabBarController {
    
    // User Data
    var userInfo: UserInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor(red: 19/255, green: 128/255, blue: 0/255, alpha: 1)
        
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        
    }
    
}
