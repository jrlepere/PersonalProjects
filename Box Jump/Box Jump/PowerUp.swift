//
//  SuperJump.swift
//  Box Jump
//
//  Created by Jake Lepere on 6/20/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import SpriteKit

class PowerUp: SKSpriteNode {
    
    var power_up_name:String = " "
    var start_power_up_timer = NSTimer()
    
    func powerUp(scene: GameScene) {
        if (power_up_name == "Super Jump") {
            scene.jump_dy = 90
            let reset_jump_timer = NSTimer(timeInterval: 10, target: self, selector: #selector(removeJump(_:)), userInfo: scene, repeats: false)
            NSRunLoop.currentRunLoop().addTimer(reset_jump_timer, forMode: NSRunLoopCommonModes)
        }
    }
    
    func removeJump(sender: NSTimer) {
        let scene = sender.userInfo as! GameScene
        scene.jump_dy = 60
    }
}
