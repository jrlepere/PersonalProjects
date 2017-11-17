//
//  Box.swift
//  Box Jump
//
//  Created by Jake Lepere on 5/22/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import SpriteKit

class Box: SKSpriteNode {
    
    var move_to_center_timer = NSTimer()
    var dead = false
    
    func moveToMiddleOfScreen(sender: NSTimer) {
        
        let x = Int(self.position.x)
        let y = Int(self.position.y)
        
        let d:Int = 10
        
        let screen_width = Int(screenBounds.width/2)
        let screen_height = Int(screenBounds.height/2)
        
        if (x < screen_width) {
            if (x + d >= screen_width) {
                self.position = CGPoint(x: screen_width, y: y)
            } else {
                self.position = CGPoint(x: x + d, y: y)
            }
        } else if (x > screen_width) {
            if (x - d <= screen_width) {
                self.position = CGPoint(x: screen_width, y: y)
            } else {
                self.position = CGPoint(x: x - d, y: y)
            }
        } else if (y < screen_height) {
            if (y + d >= screen_height) {
                self.position = CGPoint(x: x, y: screen_height)
            } else {
                self.position = CGPoint(x: x, y: y + d)
            }
        } else if (y > screen_height) {
            if (y - d <= screen_height) {
                self.position = CGPoint(x: x, y: screen_height)
            } else {
                self.position = CGPoint(x: x, y: y - d)
            }
        } else {
            move_to_center_timer.invalidate()
            //game_scene.showRestartLabel()
            //(self.parent as! GameScene).showRestartLabel()
            (self.parent as! GameScene).updateUserData()
        }
        
    }
    
}