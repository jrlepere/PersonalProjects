//
//  Secrets.swift
//  Bold Sports
//
//  Created by Jake Lepere on 7/31/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import Foundation

class Secrets {
    
    static func passwordJumble(password: String) -> String {
        
        var secret = ""
        let passwordCount = password.characters.count
        
        var index = 0
        
        for char in password.characters {
            
            if (index == 0) {
                
                if (passwordCount % 2 == 0) {
                    
                    secret += "-w"
                    
                } else {
                    
                    secret += "2x"
                    
                }
                
                
            }
            
            secret += "\(char)"
            
            if (index % 2 == 0) {
                
                secret += "-T"
                
            }
            
            if (index % 5 == 0) {
                
                secret += "x"
                if (passwordCount % 3 == 0) {
                    secret += "-"
                }
                
            }
            
            if (index % 7 == 0) {
                
                secret += "7"
                secret += "\(String(char).lowercaseString)"
                
            }
            
            if (index % 4 == 0) {
                
                secret += "\(index - passwordCount)"
                secret += "\(String(char).uppercaseString)"
                
            }
            
            if (index % 3 == 0) {
                
                secret += "_"
                
            }
            
            if (passwordCount % 3 == 0) {
                
                secret += "\(Int(passwordCount / 5))"
                
            }
            
            if (passwordCount % 3 == 0) {
                secret += "'"
            }
         
            index += 1
            
        }
        
        return secret
        
    }
    
}