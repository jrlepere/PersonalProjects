//
//  ViewController.swift
//  How Far
//
//  Created by Jake Lepere on 6/20/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit
import CoreMotion

/**
 The main View Controller for the application
 */
class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet var resetButton:UIButton! // The button to reset distance flipped
    @IBOutlet var distanceText: UITextField! // The text field representing the distance flipped
    @IBOutlet var setOffset: UIButton! // The Calibration Button
    
    
    // Gyro
    var motion_manager = CMMotionManager()
    var update_interval:Double = 1/1000 // Update interval for Gyro Updates
    
    
    // Arbitrary dimensions for the users device (Always changed)
    var height:Double = 4.9
    var width:Double = 2.33
    var depth:Double = 0.35
    var case_thickness:Double = 0.05
    
    
    // The current point of the user
    var current_point:xyPoint!
    
    
    // Offset information
    var set_offset:UInt8! // Essentially a boolean representing if the user has pressed the calibrate button
    var offset_x:Double! // Offset for the x direction
    var offset_y:Double! // Offset for the y direction
    
    
    /**
     Runs when the view loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     Runs when the view appears
     */
    override func viewDidAppear(animated: Bool) {
        
        current_point = xyPoint() //Creates a new location for the user
        
        // initialize parameters
        offset_x = 0
        offset_y = 0
        set_offset = 0x1
        
        checkDeviceSet() // Checks if the user has set their device make and model
    }
    
    
    /**
     Checks if the user has set the model of their device. Performs additional tasks if necessary.
     */
    func checkDeviceSet() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let device_set:Int = defaults.integerForKey(Keys.device_model) {
            
            if device_set != 0 {
                // User has previously selected their make and model
                
                // Sets the dimensions from user inputed data
                let dimensions:(width: Double, height: Double, depth: Double) = Keys.getDimensions(device_set)
                self.width = dimensions.width
                self.height = dimensions.height
                self.depth = dimensions.depth
                
                self.setCaseSize()
            } else {
                // User has loaded the application but has not selected the make and model of their device
                
                self.beginDeviceSet()
            }
            
        } else {
            // First time user had loaded the application
            
            defaults.setInteger(0, forKey: Keys.device_model)
            self.beginDeviceSet()
        }
    }
    
    
    /**
     Prompts the user for the size of their current Case.
     */
    func setCaseSize() {
        
        let case_alert = UIAlertController(title: "Case Size", message: "Select Your Current Case Size", preferredStyle: UIAlertControllerStyle.Alert)
        case_alert.addAction(UIAlertAction(title: "Thick Case", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            self.case_thickness = 0.1
            self.checkTutorial()
        })
        )
        case_alert.addAction(UIAlertAction(title: "Normal Case", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            self.case_thickness = 0.05
            self.checkTutorial()
        })
        )
        case_alert.addAction(UIAlertAction(title: "No Case", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            self.case_thickness = 0
            self.checkTutorial()
        })
        )
        self.presentViewController(case_alert, animated: true, completion: nil)
        
    }
    
    
    /**
     Presents an Alert prompting the user to set make and model of their iPhone
     */
    func beginDeviceSet() {
        
        let select_device_alert = UIAlertController(title: "Make and Model", message: "Please select the make and model of your iPhone device", preferredStyle: UIAlertControllerStyle.Alert)
        select_device_alert.addAction(UIAlertAction(title: "iPhone 4", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            self.setDevice("iPhone 4")
            self.setCaseSize()
        }))
        select_device_alert.addAction(UIAlertAction(title: "iPhone 4S", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            self.setDevice("iPhone 4S")
            self.setCaseSize()
        }))
        select_device_alert.addAction(UIAlertAction(title: "iPhone 5", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            self.setDevice("iPhone 5")
            self.setCaseSize()
        }))
        select_device_alert.addAction(UIAlertAction(title: "iPhone 5C", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            self.setDevice("iPhone 5C")
            self.setCaseSize()
        }))
        select_device_alert.addAction(UIAlertAction(title: "iPhone 5S", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            self.setDevice("iPhone 5S")
            self.setCaseSize()
        }))
        select_device_alert.addAction(UIAlertAction(title: "iPhone 6", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            self.setDevice("iPhone 6")
            self.setCaseSize()
        }))
        select_device_alert.addAction(UIAlertAction(title: "iPhone 6+", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            self.setDevice("iPhone 6+")
            self.setCaseSize()
        }))
        presentViewController(select_device_alert, animated: true, completion: nil)
    }
    
    
    /**
     Stores a local integer based on the user selected make and model of their device
     @param device_name: the make and model of the device selected by the user
     */
    func setDevice(device_name: String) {
        
        let deviceIntEquivalent = Keys.getModelIntEquivalent(device_name)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(deviceIntEquivalent, forKey: Keys.device_model)
        
        // Sets dimensions from recently selected make and model
        let dimensions:(width: Double, height: Double, depth: Double) = Keys.getDimensions(deviceIntEquivalent)
        self.width = dimensions.width
        self.height = dimensions.height
        self.depth = dimensions.depth
    }
    
    /**
     Checks if the user has completed the tutorial. Performs actions appropriatly
     */
    func checkTutorial() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let tutorial_completed:Bool = defaults.boolForKey(Keys.tutorial_key) {
            
            if tutorial_completed {
                // User has already completed the tutorial
                
                self.beginUpdates()
            } else {
                // User has loaded the application but has not completed the tutorial
                
                self.beginTutorial()
            }
            
        } else {
            // User has loaded the application for the first time
            
            defaults.setBool(false, forKey: Keys.tutorial_key)
            self.beginTutorial()
        }
    }
    
    
    /**
     Begins Updates from the Gyro
     */
    func beginUpdates() {
        
        motion_manager.gyroUpdateInterval = update_interval
        
        motion_manager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!) { (data, error) in
            
            // Raw Gyro Data
            let v_x = data?.rotationRate.x
            let v_y = data?.rotationRate.y
            
            // Checks if the user has recently pressed the Calibrate button
            if (self.set_offset == 0x2) {
                // Sets the x and y offsets to the current x and y rotations rates respectively
                self.offset_x = v_x
                self.offset_y = v_y
                self.set_offset = self.set_offset >> 0x1
            }
            
            // Calculates the distance traveled
            let dx = 2*((self.height + self.depth + self.case_thickness)*2*(v_x! - self.offset_x)*self.update_interval)
            let dy = 2*((self.width + self.depth + self.case_thickness)*2*(v_y! - self.offset_y)*self.update_interval)
            
            print("dx: \(dx)")
            print("dy: \(dy)")
            
            // Selects the largest of the two distances
            var largest_check:UInt8 = 0x1
            var largest = dx
            if (fabs(dy) > fabs(dx)) {
                largest_check = largest_check << 0x1
                largest = dy
            }
            
            // Checks if the largest distance is greater than some threshold
            if (fabs(largest) > 0.0002) {
                // Change in distance
                
                if (largest_check == 0x1) {
                    self.current_point.changeInX(dx)
                } else {
                    self.current_point.changeInY(dy)
                }
                let distance = self.current_point.distanceFromZero()
                self.distanceText.text = "\(distance) in"
            }
        }
    }
    
    
    /**
     Begins the Tutorial
     */
    func beginTutorial() {
        
        let place_flat = UIAlertController(title: "Tutorial", message: "Place your phone on a flat surface", preferredStyle: UIAlertControllerStyle.Alert)
        place_flat.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: {
            (UIAlertAction) in
            self.phaseTwoTutorial()
        }))
        self.presentViewController(place_flat, animated: true, completion: nil)
    }
    
    
    /**
     Phase 2 of the tutorial
     */
    func phaseTwoTutorial() {
        
        let calibrate = UIAlertController(title: "Tutorial", message: "Calibrate your device by pressing the Calibrate Button", preferredStyle: UIAlertControllerStyle.Alert)
        calibrate.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            (UIAlertAction) in
            self.phaseThreeTutorial()
        }))
        self.presentViewController(calibrate, animated: true, completion: nil)
    }
    
    
    /**
     Phase 3 of the tutorial
     */
    func phaseThreeTutorial() {
        
        let reset = UIAlertController(title: "Tutorial", message: "Reset your current position to zero by pressing the Reset Button. Once at zero, begin flipping your device to calculate the distance traveled from the red dot in the middle of the screen.", preferredStyle: UIAlertControllerStyle.Alert)
        reset.addAction(UIAlertAction(title: "OK Got It!", style: UIAlertActionStyle.Default, handler: {
            (UIAlertAction) in
            self.beginUpdates()
            self.updateTutorialCompleted()
        }))
        self.presentViewController(reset, animated: true, completion: nil)
    }
    
    
    /**
     Updates the local variable corresponding to the users tutorial completion boolean
     */
    func updateTutorialCompleted() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: Keys.tutorial_key)
    }
    
    
    /**
     Action for the Reset Button
     */
    @IBAction func resetButtonPressed(sender: UIButton) {
        
        self.current_point.reset()
        let distance = self.current_point.distanceFromZero()
        self.distanceText.text = "\(distance) in"
    }
    
    /**
     Action for the Calibrate Button
     */
    @IBAction func setOffsetPressed(sender: UIButton) {
        
        self.set_offset = self.set_offset << 0x1
    }
    
}

