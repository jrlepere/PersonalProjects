//
//  Block.swift
//  Box Jump
//
//  Created by Jake Lepere on 5/24/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import SpriteKit

class Block: SKSpriteNode {
    
    var movement_timer = NSTimer()
    var maxY: CGFloat = 0
    var box = Box()
    var game_scene = GameScene()
    var remove_bottom_row = false
    var y_pos = 0
    var at_final_pos = false
    
    func moveDown(sender: NSTimer) {
        let dy = sender.userInfo as! CGFloat
        let current_y: CGFloat = self.position.y
        if (current_y - dy <= maxY) {
            self.position = CGPoint(x: self.position.x, y: maxY)
            at_final_pos = true
            self.physicsBody?.dynamic = false
            self.movement_timer.invalidate()
            if (self.frame.contains(box.frame)) {
                game_scene.dead()
            } else if (self.frame.intersects(box.frame)) {
                game_scene.dead()
            } else {
                if (remove_bottom_row) {
                    game_scene.removeBottomRow(self.y_pos, width: self.frame.width)
                }
            }
            sender.invalidate()
        } else {
            self.position = CGPoint(x: self.position.x, y: self.position.y - dy)
        }
    }
    
}


