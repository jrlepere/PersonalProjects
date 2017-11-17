//
//  Coin.swift
//  Box Jump
//
//  Created by Jake Lepere on 5/31/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import SpriteKit

class Coin: SKShapeNode {
    
    var move_timer = NSTimer()
    var special = false
    var can_replicate = true
    
    func move(sender: NSTimer) {
        let d:UInt32 = 1000
        let dx:CGFloat = CGFloat(arc4random_uniform(d)) - CGFloat(d/2)
        let dy:CGFloat = CGFloat(arc4random_uniform(d)) - CGFloat(d/2)
        self.physicsBody?.applyForce(CGVector(dx: dx, dy: dy))
    }
    
}
