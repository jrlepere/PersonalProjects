//
//  Keys.swift
//  How Far
//
//  Created by Jake Lepere on 7/11/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import Foundation


/**
 Struct containg all relevant keys and static functions
*/
struct Keys {
    
    static let tutorial_key = "Completed Tutorial" // Key representing whether or not the tutorial has been completed
    static let device_model = "Device Model" // Key representing the users device make and model
    
    /**
     Returns the integer code for the inputted device
     @param device_name the name of the users device
     @return the integer code for the inputter device
    */
    static func getModelIntEquivalent(device_name: String) -> Int {
        
        switch device_name {
            case "iPhone 4":
                return 1
            case "iPhone 4S":
                return 2
            case "iPhone 5":
                return 3
            case "iPhone 5C":
                return 4
            case "iPhone 5S":
                return 5
            case "iPhone 6":
                return 6
            case "iPhone 6+":
                return 7
            default:
                return 0
        }
        
    }
    
    
    /**
     Returns a tuple containing the width, height, and depth for the inputed device from the integer code
     @param device_set the integer code corresponding to the users device
     @return a tuple containing the inputed devices dimensions
    */
    static func getDimensions(device_set:Int) -> (width:Double,height:Double,depth:Double) {
        
        var width = 0.0
        var height = 0.0
        var depth = 0.0
        
        switch device_set{
        case 1:
            width = 2.31
            height = 4.54
            depth = 0.37
        case 2:
            width = 2.31
            height = 4.5
            depth = 0.37
        case 3:
            width = 2.31
            height = 4.87
            depth = 0.30
        case 4:
            width = 2.33
            height = 4.9
            depth = 0.35
        case 5:
            width = 2.31
            height = 4.87
            depth = 0.37
        case 6:
            width = 2.64
            height = 5.44
            depth = 0.27
        case 7:
            width = 3.06
            height = 6.22
            depth = 0.28
        default:
            width = 2.31
            height = 4.54
            depth = 0.37
        }
        
        return (width: width, height: height, depth: depth)
        
    }
}