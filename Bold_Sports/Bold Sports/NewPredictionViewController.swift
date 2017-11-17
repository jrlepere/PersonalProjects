//
//  NewPredictionViewController.swift
//  Bold Sports
//
//  Created by Jake Lepere on 7/25/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

/**
 View Controller for view to create a new prediction
 */
class NewPreditionViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, KumulosDelegate {
    
    // Outlets
    @IBOutlet var boldPredictionText: UITextView!
    @IBOutlet var sportPicker: UIPickerView!
    @IBOutlet var postPredictionButton: UIButton!
    
    // Kumulos
    let K = Kumulos()
    
    // Activity Indicator
    var processingIndicator: UIActivityIndicatorView!
    
    // Additional
    let maxPredictionCharacters = 512
    var currentSport = Sports.selectSport
    let boldPrediction = "Bold Prediction"
    var username:String!
    var userPollID:UInt!
    
    /**
     Preforms when the view is loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Kumulos
        K.delegate = self
        
        // Username
        username = (self.tabBarController as! MainTabBarController).userInfo.username
        userPollID = UInt((self.tabBarController as! MainTabBarController).userInfo.userPollID)
        
        // Outlets
        self.boldPredictionText.delegate = self
        self.boldPredictionText.layer.borderWidth = 1
        self.boldPredictionText.layer.borderColor = UIColor.blackColor().CGColor
        self.sportPicker.delegate = self
        self.sportPicker.dataSource = self
        postPredictionButton.layer.borderWidth = 1
        postPredictionButton.layer.borderColor = UIColor.blackColor().CGColor
        
        // Keyboard
        let removeKeyBoardTap = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.removeKeyBoardTap(_:)))
        let removeKeyBoardSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LogInViewController.removeKeyBoardSwipe(_:)))
        removeKeyBoardSwipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(removeKeyBoardTap)
        self.view.addGestureRecognizer(removeKeyBoardSwipe)
        
        // Activity Indicator
        let centerPoint = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        processingIndicator = UIActivityIndicatorView(frame: CGRect(origin: centerPoint, size: CGSize(width: 0, height: 0)))
        processingIndicator.transform = CGAffineTransformMakeScale(2, 2)
        processingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        processingIndicator.hidesWhenStopped = true
        self.view.addSubview(processingIndicator)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Remove the keyboard from the screen after a tap
     */
    func removeKeyBoardTap(sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        
    }
    
    /**
     Remove the keyboard from the screen after a swipe down
     */
    func removeKeyBoardSwipe(sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        
    }
    
    /**
     TextView Delegate. Removes the default text from the predictions text field. Preforms the first time the user presses the field.
     */
    func textViewDidBeginEditing(textView: UITextView) {
        
        if (self.boldPredictionText.text == boldPrediction) {
            self.boldPredictionText.text = ""
        }
        
    }
    
    /**
     TextView Delegate. Sets the default text to the text field if the user exits editing with a blank text field.
     */
    func textViewDidEndEditing(textView: UITextView) {
        
        if self.boldPredictionText.text.isEmpty {
            self.boldPredictionText.text = boldPrediction
        }
        
    }
    
    /**
     TextView Delegate. Removes the keyboard when the user presses the return key.
     */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /**
     PickerView DataSource. The number of components (columns) for the picker view.
     */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /**
     PickerView DataSource. THe number of rows for the picker view
     */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Sports.sports.count
        
    }
    
    /**
     PickerView Delegate. Sets the strings for the picker view.
     */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Sports.sports[row]
        
    }
    
    /**
     PickerView Delegate. Sets the currentSport variable to the selected sport.
     */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        currentSport = Sports.sports[row]
        
    }
    
    /**
     The Action for when the user taps the Post Prediciton Button. Checks for validity and posts the prediction.
     */
    @IBAction func postPredictionPressed(sender: UIButton) {
        
        let userPrediction = self.boldPredictionText.text
        
        if (userPrediction == boldPrediction) {
            noPredictionAlert()
        } else if (currentSport == Sports.selectSport) {
            noSportAlert()
        } else if (userPrediction.characters.count >= maxPredictionCharacters) {
            tooManyCharacters()
        } else {
            // Valid
            
            ProcessingIndicator.startProcessingIndicator(processingIndicator, viewsToHide: [boldPredictionText, sportPicker, postPredictionButton])
            
            K.createPredictionWithPrediction(userPrediction, andSport: currentSport, andUsername: username, andCount: 0, andUserPollID: userPollID)
        }
        
    }
    
    /**
     Kumulos Delegate. Successfully Created the prediction.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, createPredictionDidCompleteWithResult newRecordID: NSNumber!) {
        
         ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [boldPredictionText, sportPicker, postPredictionButton])
        
        let successfulPrediction = UIAlertController(title: "Success!", message: "Your prediction was successfully posted. Create another or cast your vote on some of the other BOLD predictions!", preferredStyle: .Alert)

        successfulPrediction.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
            // Reset the view
            self.boldPredictionText.text = self.boldPrediction
            self.sportPicker.selectRow(0, inComponent: 0, animated: true)
            
        }))
        self.presentViewController(successfulPrediction, animated: true, completion: nil)
    }
    
    /**
     An Alert for when the user does not enter a prediction.
     */
    func noPredictionAlert() {
        
        let noPredictionAlert = UIAlertController(title: "No Prediction", message: "Please make your BOLD prediction.", preferredStyle: .Alert)
        noPredictionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(noPredictionAlert, animated: true, completion: nil)
        
    }
    
    /**
     An Alert for when the user does not select a sport.
     */
    func noSportAlert() {
        
        let noSportAlert = UIAlertController(title: "No Sport Selected", message: "Please select the sport for your BOLD prediction.", preferredStyle: .Alert)
        noSportAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(noSportAlert, animated: true, completion: nil)
        
    }
    
    /**
     An Alert for when the user enters too many characters for their prediction.
     */
    func tooManyCharacters() {
        
        let tooManyCharacters = UIAlertController(title: "Too Many Characters", message: "You have entered too many characters for your BOLD prediction.", preferredStyle: .Alert)
        tooManyCharacters.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(tooManyCharacters, animated: true, completion: nil)
        
    }
    
    /**
     Kumulos Delegate. Preforms when there was an error processing information.
     */
    func kumulosAPI(kumulos: kumulosProxy!, apiOperation operation: KSAPIOperation!, didFailWithError theError: String!) {
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [boldPredictionText, sportPicker, postPredictionButton])
        
        let errorAlert = UIAlertController(title: "Error", message: "There was an error processing information. Please try again or restart the application.", preferredStyle: .Alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
        
    }
}