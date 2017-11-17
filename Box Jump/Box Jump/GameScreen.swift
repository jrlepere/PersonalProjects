//
//  GameScreen.swift
//  Box Jump
//
//  Created by Jake Lepere on 5/24/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import SpriteKit
import CoreMotion
import Foundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var parentController = UIViewController()
    
    let motionManager: CMMotionManager = CMMotionManager()
    var contentCreated = false
    
    var box:Box!
    var block_timer = NSTimer()
    
    var score_label = SKLabelNode()
    var score_timer = NSTimer()
    var score_addition = 10
    
    var number_of_blocks:CGFloat = 8
    var smaller_blocks:Bool = false
    
    let box_category: UInt32 = 0x1 << 0
    let block_category: UInt32 = 0x1 << 1
    let coin_category: UInt32 = 0x1 << 2
    let power_up_category:UInt32 = 0x1 << 3
    
    var max_block_difference = 1
    var block_pos_array = [Int]()
    var array_of_block_heights = [CGFloat]()
    
    var power_up_array = [PowerUp]()
    
    // Scene Setup and Content Creation
    override func didMoveToView(view: SKView) {
        
        if (!self.contentCreated) {
            self.createContent()
            self.contentCreated = true
        }
        
        self.physicsWorld.contactDelegate = self
        
    }
    
    // sender: UITap
    func startGame() {
        
        self.start_game_label.removeFromParent()
        
        box.physicsBody!.dynamic = true
        
        let jump_tap_gesture = UITapGestureRecognizer(target: self, action: #selector(GameScene.jump(_:)))
        self.view?.addGestureRecognizer(jump_tap_gesture)
        
        motionManager.accelerometerUpdateInterval = 1/20
        
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (data, error) in
            
            if let acceleration_data = self.motionManager.accelerometerData?.acceleration {
                if (!self.box.dead) {
                    if (fabs(acceleration_data.x) > 0.075) {
                        let dx:CGFloat = CGFloat(12.5*acceleration_data.x)
                        self.box.physicsBody?.applyForce(CGVector(dx: dx, dy: 0))
                    }
                }
            }
        }
        
        for _ in 0...Int(number_of_blocks-1) {
            block_pos_array.append(0)
            array_of_block_heights.append(0)
        }
        
        block_timer = NSTimer.init(timeInterval: 2, target: self, selector: #selector(GameScene.generateBlock(_:)), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(block_timer, forMode: NSRunLoopCommonModes)
        
        //coin = createCoin()
        self.addChild(createCoin(true))
        
        score_label.position = CGPoint(x: screenBounds.width/2, y: screenBounds.height-60)
        score_label.text = "0"
        score_label.physicsBody?.dynamic = false
        score_label.zPosition = 2
        score_label.fontSize = score_label.fontSize + 20
        self.addChild(score_label)
        score_timer = NSTimer(timeInterval: 1, target: self, selector: #selector(GameScene.increaseScore(_:)), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(score_timer, forMode: NSRunLoopCommonModes)
        
        let power_up = PowerUp()
        power_up.size = box.size
        power_up.color = UIColor.redColor()
        power_up.power_up_name = "Super Jump"
        let power_up_timer_interval = Double(arc4random_uniform(10) + 10)
        power_up.start_power_up_timer = NSTimer(timeInterval: power_up_timer_interval, target: self, selector: #selector(powerUpActivate(_:)), userInfo: power_up, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(power_up.start_power_up_timer, forMode: NSRunLoopCommonModes)

        power_up_array.append(power_up)
        
    }
    
    var start_game_label = SKLabelNode(text: "Tap To Begin")
    
    func createContent() {
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.backgroundColor = SKColor.blackColor()
        
        box = createBox()
        self.addChild(box)
        /*
        start_game_label.position = CGPoint(x: screenBounds.width/2, y: screenBounds.height/2)
        start_game_label.fontSize = 20
        self.addChild(start_game_label)
        
        let startGameRecogniser = UITapGestureRecognizer(target: self, action: #selector(startGame(_:)))
        self.view?.addGestureRecognizer(startGameRecogniser)
 */
        startGame()
    }
    
    func powerUpActivate(sender: NSTimer) {
        let power_up = sender.userInfo as! PowerUp
        power_up.start_power_up_timer.invalidate()
        power_up.position = CGPoint(x: screenBounds.width/2, y: screenBounds.height/2)
        power_up.zPosition = 4
        power_up.physicsBody = SKPhysicsBody(rectangleOfSize: power_up.size)
        power_up.physicsBody?.affectedByGravity = false
        power_up.physicsBody?.allowsRotation = false
        power_up.physicsBody?.categoryBitMask = power_up_category
        power_up.physicsBody?.collisionBitMask = power_up_category
        power_up.physicsBody?.contactTestBitMask = power_up_category | box_category
        self.addChild(power_up)
        let power_up_movement_timer = NSTimer(timeInterval: 2, target: self, selector: #selector(movePowerUp(_:)), userInfo: power_up, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(power_up_movement_timer, forMode: NSRunLoopCommonModes)
    }
    
    func movePowerUp(sender: NSTimer) {
        let power_up = sender.userInfo as! SKSpriteNode
        let dx = CGFloat(arc4random_uniform(100)) - 50.0
        let dy = CGFloat(arc4random_uniform(100)) - 60.0
        power_up.physicsBody?.applyForce(CGVector(dx: dx, dy: dy))
    }
    
    func createBox() -> Box {
        
        let box = Box(color: UIColor.blueColor(), size: CGSize(width: ((screenBounds.width)/number_of_blocks)/3, height: ((screenBounds.width)/number_of_blocks)/3))
        
        box.position = CGPoint(x: screenBounds.width/2, y:screenBounds.height/2)
        box.zPosition = 1
        
        box.physicsBody = SKPhysicsBody(rectangleOfSize: box.frame.size)
        box.physicsBody!.dynamic = false
        box.physicsBody!.affectedByGravity = true
        box.physicsBody?.allowsRotation = false
        box.physicsBody!.density = box.frame.width/60
        box.physicsBody?.usesPreciseCollisionDetection = true
        box.physicsBody?.categoryBitMask = box_category
        box.physicsBody?.collisionBitMask = box_category | block_category
        box.physicsBody?.contactTestBitMask = box_category | block_category | coin_category | power_up_category
                
        return box
    }
    
    var jump_count = 0
    
    func jump(sender: UITapGestureRecognizer) {
        if (fabs((box.physicsBody?.velocity.dy)!) <= 0.05) {
            box.physicsBody?.velocity.dy = 0
            box.physicsBody?.applyForce(CGVector(dx: 0, dy: jump_dy))
            jump_count += 1
            print("jumpcount \(jump_count)")
        }
    }
    
    var jump_dy = 60
    
    func generateBlock(sender: NSTimer) {
        
        let block_width = (screenBounds.width)/number_of_blocks
        
        let block:Block = Block(color: UIColor.brownColor(), size: CGSize(width: CGFloat(block_width + 2), height: CGFloat(block_width)))
        
        var block_pos = arc4random_uniform(UInt32(number_of_blocks))
        
        while (block_pos_array[Int(block_pos)] + 1 - block_pos_array.minElement()! > max_block_difference) {
            if (block_pos < UInt32(number_of_blocks) - 1) {
                block_pos += 1
            } else {
                block_pos = 0
            }
        }
        
        let helper = block_pos_array[Int(block_pos)] + 1
        block_pos_array[Int(block_pos)] = helper
        
        let helper_2:CGFloat = array_of_block_heights[Int(block_pos)] + block_width
        array_of_block_heights[Int(block_pos)] = helper_2
        
        block.maxY = CGFloat(array_of_block_heights[Int(block_pos)]) - block_width/2
        
        block.position = CGPoint(x: CGFloat(block_pos)*block_width + (block_width/2), y: screenBounds.height - block_width)
        block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
        block.physicsBody?.dynamic = true
        block.physicsBody?.affectedByGravity = false
        block.physicsBody?.allowsRotation = false
        block.physicsBody?.density = 10000
        block.physicsBody?.usesPreciseCollisionDetection = true
        block.physicsBody?.categoryBitMask = block_category
        block.physicsBody?.collisionBitMask = box_category
        block.physicsBody?.contactTestBitMask = box_category

        let dy = block_velocity
        block.movement_timer = NSTimer(timeInterval: 0.1, target: block, selector: #selector(block.moveDown(_:)), userInfo: dy, repeats: true)
        block.box = box
        block.game_scene = self
        block.y_pos = block_pos_array[Int(block_pos)]
        
        self.addChild(block)
        NSRunLoop.currentRunLoop().addTimer(block.movement_timer, forMode: NSRunLoopCommonModes)
        
        if (block_pos_array.minElement() == block.y_pos) {
            block.remove_bottom_row = true
            for i in 0...(array_of_block_heights.count-1) {
                let helper = array_of_block_heights[i]
                array_of_block_heights[i] = helper - block_width
            }
        }
        
    }
    
    func removeBottomRow(y_pos: Int, width: CGFloat) {
        number_of_row_removals += 1
        if (number_of_row_removals % 2 == 0) {
            max_block_difference += 1
        }
        if (number_of_row_removals % 3 == 0) {
            block_velocity += 10
        }
        for child in self.children {
            if (child.physicsBody?.categoryBitMask == block_category) {
                let b = child as! Block
                if (b.y_pos == y_pos) {
                    child.removeFromParent()
                } else {
                    b.position = CGPoint(x: b.position.x, y: b.position.y - width)
                }
            }
        }
    }
    
    func createCoin(canSpecial: Bool) -> Coin {
        let coin = Coin(circleOfRadius: box.frame.width)
        coin.position = CGPoint(x: screenBounds.width/2, y: screenBounds.height - (screenBounds.height/30))
        if (canSpecial) {
            let special = arc4random_uniform(10)
            if (special == 0) {
                coin.fillColor = UIColor.blueColor()
                coin.special = true
            } else {
                coin.fillColor = UIColor.yellowColor()
            }
        } else {
            coin.fillColor = UIColor.greenColor()
        }
        coin.physicsBody = SKPhysicsBody(circleOfRadius: box.frame.width)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = coin_category
        coin.physicsBody?.collisionBitMask = coin_category
        coin.physicsBody?.contactTestBitMask = box_category | coin_category
        coin.zPosition = 2.0
        
        coin.move_timer = NSTimer(timeInterval: 5, target: coin, selector: #selector(Coin.move(_:)), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(coin.move_timer, forMode: NSRunLoopCommonModes)
        coin.move_timer.fire()
        
        return coin
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask == box_category && contact.bodyB.categoryBitMask == coin_category) {
            
            if (!(contact.bodyA.node as! Box).dead) {
                let c = contact.bodyB.node as! Coin
                c.move_timer.invalidate()
                if (!c.can_replicate ) {
                    var score = Int (score_label.text!)!
                    score += 100
                    score_label.text = "\(score)"
                } else {
                    var score = Int (score_label.text!)!
                    score += (coin_score)
                    score_label.text = "\(score)"
                    coin_score += 100
                }
                if (c.can_replicate) {
                    if (c.special) {
                        for _ in 0...8 {
                            let c_special_child = createCoin(false)
                            c_special_child.can_replicate = false
                            self.addChild(c_special_child)
                        }
                    }
                    self.addChild(createCoin(true))
                }
                contact.bodyB.node?.removeAllActions()
                contact.bodyB.node?.removeFromParent()
            }
        }
        
        if (contact.bodyA.categoryBitMask == box_category && contact.bodyB.categoryBitMask == power_up_category) {
            if (!(contact.bodyA.node as! Box).dead) {
                let power_up = contact.bodyB.node as! PowerUp
                power_up.removeFromParent()
                power_up.powerUp(self)
                let new_power_up = PowerUp(color: UIColor.redColor(), size: box.size)
                new_power_up.color = UIColor.redColor()
                new_power_up.power_up_name = "Super Jump"
                new_power_up.power_up_name = "Super Jump"
                let new_power_up_timer_interval = Double(arc4random_uniform(10) + 10)
                new_power_up.start_power_up_timer = NSTimer(timeInterval: new_power_up_timer_interval, target: self, selector: #selector(powerUpActivate(_:)), userInfo: power_up, repeats: false)
                NSRunLoop.currentRunLoop().addTimer(new_power_up.start_power_up_timer, forMode: NSRunLoopCommonModes)
                
                power_up_array.append(new_power_up)
            }
        }
        /*
        if (contact.bodyA.categoryBitMask == box_category && contact.bodyB.categoryBitMask == block_category) {
            var contact_box = contact.bodyA.node as! Box
            var contact_block = contact.bodyB.node as! Block
            if (contact_block.at_final_pos) {
                contact_box.position = CGPoint(x: contact_box.position.x, y: (contact_block.maxY + contact_block.frame.height/2 + contact_box.frame.height/2))
            }
        }*/
    }
    
    var coin_score = 100
    
    func dead() {
        
        box.dead = true
        
        box.physicsBody?.affectedByGravity = false
        box.physicsBody?.dynamic = false
        
        box.physicsBody?.collisionBitMask = box_category
        
        print("gesture count: \(self.view?.gestureRecognizers?.count)")
        
        for gesture in (self.view?.gestureRecognizers)! {
            self.view?.removeGestureRecognizer(gesture)
        }
        
        block_timer.invalidate()
        for child in self.children {
            if (child.physicsBody?.categoryBitMask == block_category) {
                array_of_blocks_to_remove.append(child as! Block)
                (child as! Block).physicsBody?.collisionBitMask = 0
            } else if (child.physicsBody?.categoryBitMask == power_up_category) {
                child.removeFromParent()
                child.removeAllActions()
            } else if (child.physicsBody?.categoryBitMask == coin_category) {
                child.physicsBody?.collisionBitMask = coin_category
                child.physicsBody?.contactTestBitMask = coin_category
            }
        }
        
        box.move_to_center_timer = NSTimer(timeInterval: 0.1, target: box, selector: #selector(box.moveToMiddleOfScreen(_:)), userInfo: self, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(box.move_to_center_timer, forMode: NSRunLoopCommonModes)
        
        let remove_blocks_timer = NSTimer(timeInterval: 0.05, target: self, selector: #selector(GameScene.removeBlockAction(_:)), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(remove_blocks_timer, forMode: NSRunLoopCommonModes)
        
    }
    
    func updateUserData() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let previous_high_score = defaults.integerForKey(UserData.highscore)
        if (Int(score_label.text!)! > previous_high_score) {
            
            let new_high_score = SKLabelNode(text: "NEW HIGH SCORE!")
            new_high_score.position = CGPoint(x: screenBounds.width/2, y: 100)
            new_high_score.fontSize = 30
            new_high_score.color = UIColor.greenColor()
            self.addChild(new_high_score)
            
            defaults.setInteger(Int(score_label.text!)!, forKey: UserData.highscore)
            print(Int(score_label.text!)!)
        }
        
        let back_to_home_timer = NSTimer(timeInterval: 3.5, target: self, selector: #selector(backToHomeScreen(_:)), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(back_to_home_timer, forMode: NSRunLoopCommonModes)
    }
    
    var array_of_blocks_to_remove = [Block]()
    
    func increaseScore(sender: NSTimer) {
        var score = Int (score_label.text!)!
        score += (number_of_row_removals * score_multiplier)
        score_label.text = "\(score)"
    }
    
    func removeBlockAction(sender: NSTimer) {
        
        if (array_of_blocks_to_remove.count > 0) {
            let b = array_of_blocks_to_remove.removeLast()
            b.removeFromParent()
            increaseScorePerBlock()
            score_timer.invalidate()
        } else {
            sender.invalidate()
        }
        
    }
    
    func increaseScorePerBlock() {
        var score = Int (score_label.text!)!
        score += (number_of_row_removals * score_multiplier)
        score_label.text = "\(score)"
    }
    
    var number_of_row_removals = 1
    var score_multiplier = 20
    var block_velocity = 20
    
    func backToHomeScreen(sender: NSTimer) {
        
        jump_dy = 60
        
        for child in children {
            child.removeAllActions()
        }
        
        self.removeAllActions()
        self.removeFromParent()
        self.removeAllChildren()
        
        (self.parentController as! GameViewController).restart()
    }
    
}
