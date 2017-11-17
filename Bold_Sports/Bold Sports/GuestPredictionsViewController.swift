//
//  GuestPredictionsViewController.swift
//  Bold Sports
//
//  Created by Jake Lepere on 8/11/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//


import UIKit

/**
 View controller for the all of the Polls
 */
class GuestPredictionsViewController: UIViewController, KumulosDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {
    
    // Outlets
    @IBOutlet var sportPicker: UIPickerView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var meterView: UIView!
    
    // Kumulos
    let K = Kumulos()
    
    // Swipe Gesture
    var swipeLeftGesture: UISwipeGestureRecognizer!
    
    // Additional
    var selectedSport: String!
    let numberOfRecords = 50
    let predictions = Predictions()
    var scrollViewWidth: CGFloat!
    var scrollViewHeight: CGFloat!
    let predictionTextHeightRatio:CGFloat = 0.75
    var currentPredictionIndex: Int!
    var processingIndicator: UIActivityIndicatorView!
    var previousRandom:UInt32 = 1
    
    /**
     Preforms when the view is loaded
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Kumulos
        K.delegate = self
        
        // Outlets: pickerView
        self.sportPicker.delegate = self
        self.sportPicker.dataSource = self
        
        // Outlets: ScrollView
        self.scrollView.delegate = self
        self.scrollView.layer.borderWidth = 0.5
        self.scrollView.layer.borderColor = UIColor.blackColor().CGColor
        self.meterView.hidden = true
        self.meterView.layer.borderWidth = 0.5
        self.meterView.layer.borderColor = UIColor.blackColor().CGColor
        
        // Swipe Gesture
        swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(PollsViewController.swipedLeft(_:)))
        swipeLeftGesture.direction = .Left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        // Additional
        selectedSport = Sports.anySport
        self.currentPredictionIndex = 0
        
        // Activity Indicator
        let centerPoint = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
        processingIndicator = UIActivityIndicatorView(frame: CGRect(origin: centerPoint, size: CGSize(width: 0, height: 0)))
        processingIndicator.transform = CGAffineTransformMakeScale(2, 2)
        processingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        processingIndicator.hidesWhenStopped = true
        self.view.addSubview(processingIndicator)
        
        // Navigation Controller
        self.navigationItem.title = "Guest Mode"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Preforms when the subviews are loaded.
     */
    override func viewDidLayoutSubviews() {
        
        scrollViewWidth = self.scrollView.frame.width
        scrollViewHeight = self.scrollView.frame.height
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        ProcessingIndicator.startProcessingIndicator(processingIndicator, viewsToHide: [sportPicker])
        
        // Kumulos
        K.getPredictionsAllWithNumberOfRecords(numberOfRecords * 5)
        
    }
    
    /**
     Kumulos Delegate. Preforms when the user selects a new sport to search. Gets new predictions.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getPredictionsAllDidCompleteWithResult theResults: [AnyObject]!) {
        
        kumulosResults(theResults)
        
    }
    
    /**
     Kumulos Delegate. Preforms when the user selects a new sport to search. Gets new predictions by maybe count ascending.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getPredictionsByMaybeCountAscendingDidCompleteWithResult theResults: [AnyObject]!) {
        
        kumulosResults(theResults)
        
    }
    
    /**
     Kumulos Delegate. Preforms when the user selects a new sport to search. Gets new predictions by maybe count descending.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getPredictionsByMaybeCountDescendingDidCompleteWithResult theResults: [AnyObject]!) {
        
        kumulosResults(theResults)
        
    }
    
    /**
     Kumulos Delegate. Preforms when the user selects a new sport to search. Gets new predictions by no way count ascending.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getPredictionsByNoWayCountAscendingDidCompleteWithResult theResults: [AnyObject]!) {
        
        kumulosResults(theResults)
        
    }
    
    /**
     Kumulos Delegate. Preforms when the user selects a new sport to search. Gets new predictions by no way count descending.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getPredictionsByNoWayCountDescendingDidCompleteWithResult theResults: [AnyObject]!) {
        
        kumulosResults(theResults)
        
    }
    
    /**
     Kumulos Delegate. Preforms when the user selects a new sport to search. Gets new predictions by obviously count ascending.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getPredictionsByObviouslyCountAscendingDidCompleteWithResult theResults: [AnyObject]!) {
        
        kumulosResults(theResults)
        
    }
    
    /**
     Kumulos Delegate. Preforms when the user selects a new sport to search. Gets new predictions by obviously count descending.
     */
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getPredictionsByObviouslyCountDescendingDidCompleteWithResult theResults: [AnyObject]!) {
        
        kumulosResults(theResults)
        
    }
    
    /**
     Preforms the necessary steps with the results generated from kumulos.
     @param theResults the results generated by Kumulos
     */
    func kumulosResults(theResults: [AnyObject]) {
        
        var index:Int = predictions.count()
        
        var randomIndecies:[UInt32] = []
        let theResultsCount = UInt32(theResults.count)
        
        for _ in theResults {
            
            var randomIndex = arc4random_uniform(theResultsCount)
            while (randomIndecies.contains(randomIndex)) {
                
                randomIndex = arc4random_uniform(theResultsCount)
                
            }
            randomIndecies.append(randomIndex)
            
            createPredictionView(theResults[Int(randomIndex)], index: index)
            
            index += 1
            
        }
        
        scrollView.contentSize = CGSizeMake(CGFloat(index) * scrollViewWidth, scrollViewHeight)
        
        if processingIndicator.isAnimating() {
            
            ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [sportPicker])
            scroll()
            
        }
        
    }
    
    /**
     Creates the predictionView for the slider view
     */
    func createPredictionView(result: AnyObject, index: Int) {
        
        // Extract Predition Data
        let predictionData = Predictions.extractPredictionData(result)
        predictions.addPrediction(predictionData)
        
        // New xPos for the view
        let xPos = CGFloat(index) * scrollViewWidth
        
        // UIView
        let predictionView = PredictionView(frame: CGRect(x: xPos, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        predictionView.predictionsArrayIndex = index
        predictionView.layer.borderWidth = 0.5
        predictionView.layer.borderColor = UIColor.blackColor().CGColor
        
        // Prediction Text View
        let textHeight = predictionView.frame.height*predictionTextHeightRatio
        let predictionTextView = UITextView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: textHeight))
        predictionTextView.text = "\(predictionData.username):\n\(predictionData.prediction)"
        predictionTextView.layer.borderWidth = 0.5
        predictionTextView.layer.borderColor = UIColor.blackColor().CGColor
        predictionTextView.font = UIFont(name: (predictionTextView.font?.fontName)!, size: 20)
        predictionTextView.userInteractionEnabled = false
        
        // No Way Button
        let noWayButton = VotingButton(type: .System)
        noWayButton.predictionsArrayIndex = index
        noWayButton.frame = CGRect(x: 0, y: predictionTextView.frame.height, width: scrollViewWidth/3, height: scrollViewHeight*(1-predictionTextHeightRatio))
        noWayButton.setTitle("No Way", forState: .Normal)
        noWayButton.backgroundColor = UIColor.redColor()
        noWayButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        noWayButton.layer.borderWidth = 0.2
        noWayButton.layer.borderColor = UIColor.blackColor().CGColor
        noWayButton.addTarget(self, action: #selector(PollsViewController.noWayPressed(_:)), forControlEvents: .TouchUpInside)
        
        // Maybe Button
        let maybeButton = VotingButton(type: .System)
        maybeButton.predictionsArrayIndex = index
        maybeButton.frame = CGRect(x: scrollViewWidth/3, y: predictionTextView.frame.height, width: scrollViewWidth/3, height: scrollViewHeight*(1-predictionTextHeightRatio))
        maybeButton.setTitle("Maybe", forState: .Normal)
        maybeButton.backgroundColor = UIColor.yellowColor()
        maybeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        maybeButton.layer.borderWidth = 0.2
        maybeButton.layer.borderColor = UIColor.blackColor().CGColor
        maybeButton.addTarget(self, action: #selector(PollsViewController.maybePressed(_:)), forControlEvents: .TouchUpInside)
        
        // Obviously Button
        let obviouslyButton = VotingButton(type: .System)
        obviouslyButton.predictionsArrayIndex = index
        obviouslyButton.frame = CGRect(x: (2*scrollViewWidth)/3, y: predictionTextView.frame.height, width: scrollViewWidth/3, height: scrollViewHeight*(1-predictionTextHeightRatio))
        obviouslyButton.setTitle("Obviously", forState: .Normal)
        obviouslyButton.backgroundColor = UIColor.greenColor()
        obviouslyButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        obviouslyButton.layer.borderWidth = 0.2
        obviouslyButton.layer.borderColor = UIColor.blackColor().CGColor
        obviouslyButton.addTarget(self, action: #selector(PollsViewController.obviouslyPressed(_:)), forControlEvents: .TouchUpInside)
        
        // 'Connect Buttons'
        noWayButton.otherButtonOne = maybeButton
        noWayButton.otherButtonTwo = obviouslyButton
        maybeButton.otherButtonOne = noWayButton
        maybeButton.otherButtonTwo = obviouslyButton
        obviouslyButton.otherButtonOne = noWayButton
        obviouslyButton.otherButtonTwo = maybeButton
        
        // Add Subviews
        predictionView.addSubview(predictionTextView)
        predictionView.addSubview(noWayButton)
        predictionView.addSubview(maybeButton)
        predictionView.addSubview(obviouslyButton)
        scrollView.addSubview(predictionView)
        
    }
    
    /**
     PickerView DataSource. The number for components (columns) in the picker view.
     */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    /**
     PickerView DataSource. The number of rows in the picker view.
     */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Sports.sports.count
        
    }
    
    /**
     PickerView Delegate. Assigns the text for the picker view.
     */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 {
            return Sports.anySport
        } else {
            return Sports.sports[row]
        }
        
    }
    
    /**
     PickerView Delegate. Preforms when the user selects item from the picker view. Updates the selectedSport variable to hold the newly selected sport.
     */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        predictions.removeAll()
        
        meterView.hidden = true
        for views in meterView.subviews {
            views.removeFromSuperview()
        }
        
        currentPredictionIndex = -1
        ProcessingIndicator.startProcessingIndicator(processingIndicator, viewsToHide: [sportPicker])
        
        if row == 0 {
            selectedSport = Sports.anySport
        } else {
            selectedSport = Sports.sports[row]
        }
        
        getRecords()
        
    }
    
    /**
     Preformed when the user votes noWay on a prediction.
     */
    func noWayPressed(sender: VotingButton) {
        
        disableButtons(sender)
        updateMeter(0, predictionsArrayIndex: sender.predictionsArrayIndex)
        K.updateNoWayCountWithPollID(UInt(predictions.getPrediction(sender.predictionsArrayIndex).pollID))
        K.increaseNoWayTotalRecievedWithUsername(predictions.getPrediction(sender.predictionsArrayIndex).username)
        
        if (self.tabBarController != nil) {
            K.increaseTotalVotesMadeWithUsername((self.tabBarController as! MainTabBarController).userInfo.username)
        }
        
    }
    
    /**
     Preformed when the user vote maybe on a prediction.
     */
    func maybePressed(sender: VotingButton) {
        
        disableButtons(sender)
        updateMeter(1, predictionsArrayIndex: sender.predictionsArrayIndex)
        K.updateMaybeCountWithPollID(UInt(predictions.getPrediction(sender.predictionsArrayIndex).pollID))
        K.increaseMaybeTotalRecievedWithUsername(predictions.getPrediction(sender.predictionsArrayIndex).username)
        
        if (self.tabBarController != nil) {
            K.increaseTotalVotesMadeWithUsername((self.tabBarController as! MainTabBarController).userInfo.username)
        }
        
    }
    
    /**
     Prefmormed when the user votes obviously on a prediction.
     */
    func obviouslyPressed(sender: VotingButton) {
        
        disableButtons(sender)
        updateMeter(2, predictionsArrayIndex: sender.predictionsArrayIndex)
        K.updateObviouslyCountWithPollID(UInt(predictions.getPrediction(sender.predictionsArrayIndex).pollID))
        K.increaseObviouslyTotalRecievedWithUsername(predictions.getPrediction(sender.predictionsArrayIndex).username)
        
        if (self.tabBarController != nil) {
            K.increaseTotalVotesMadeWithUsername((self.tabBarController as! MainTabBarController).userInfo.username)
        }
        
    }
    
    /**
     Disables the votingButton tapped and its neighbors.
     @param buttonTapped the button that was tapped
     */
    func disableButtons(buttonTapped: VotingButton) {
        
        buttonTapped.userInteractionEnabled = false
        buttonTapped.otherButtonOne.userInteractionEnabled = false
        buttonTapped.otherButtonTwo.userInteractionEnabled = false
        
    }
    
    /**
     Update Meter after Kumulos successfully updates the count
     */
    func updateMeter(vote: UInt8, predictionsArrayIndex: Int) {
        
        var predictionData = predictions.getPrediction(predictionsArrayIndex)
        
        if (vote == 0) {
            // noWay
            predictionData.noWayCount = predictionData.noWayCount + 1
        } else if (vote == 1) {
            // Maybe
            predictionData.maybeCount = predictionData.maybeCount + 1
        } else {
            // Obv
            predictionData.obviouslyCount = predictionData.obviouslyCount + 1
        }
        
        let meterViews = VotesBarGraph.generateViews(predictionData.noWayCount, maybeCount: predictionData.maybeCount, obviouslyCount: predictionData.obviouslyCount, meterViewFrame: self.meterView.frame)
        
        self.meterView.addSubview(meterViews.noWayBar)
        self.meterView.addSubview(meterViews.maybeBar)
        self.meterView.addSubview(meterViews.obviouslyBar)
        self.meterView.addSubview(meterViews.textView)
        self.meterView.hidden = false
        
    }
    
    /**
     Swiped left on the scroll view.
     */
    func swipedLeft(sender: UISwipeGestureRecognizer) {
        
        self.meterView.hidden = true
        
        for view in self.meterView.subviews {
            view.removeFromSuperview()
        }
        
        if (currentPredictionIndex == predictions.count() - 2) {
            
            ProcessingIndicator.startProcessingIndicator(processingIndicator, viewsToHide: [sportPicker])
            getRecords()
            
        } else {
            
            scroll()
        }
        
    }
    
    /**
     Scroll the scroll view
     */
    func scroll() {
        
        currentPredictionIndex = currentPredictionIndex + 1
        
        self.scrollView.scrollRectToVisible(CGRect(x: CGFloat(currentPredictionIndex) * self.scrollView.frame.width, y: 0, width: self.scrollViewWidth, height: self.scrollViewHeight), animated: true)
        
    }
    
    /**
     Gets the records from Kumulos based on the current selected sport.
     */
    func getRecords() {
        if (selectedSport == Sports.anySport) {
            
            K.getPredictionsAllWithNumberOfRecords(numberOfRecords*5)
            
        } else {
            
            var sorterDecider = arc4random_uniform(6) + 1
            if (sorterDecider == previousRandom) {
                if (sorterDecider == 6) {
                    sorterDecider = 1
                } else {
                    sorterDecider = sorterDecider + 1
                }
            }
            
            switch sorterDecider {
            case 1:
                K.getPredictionsByMaybeCountAscendingWithNumberOfRecords(numberOfRecords, andSport: selectedSport)
            case 2:
                K.getPredictionsByMaybeCountDescendingWithNumberOfRecords(numberOfRecords, andSport: selectedSport)
            case 3:
                K.getPredictionsByNoWayCountAscendingWithSport(selectedSport, andNumberOfRecords: numberOfRecords)
            case 4:
                K.getPredictionsByNoWayCountDescendingWithSport(selectedSport, andNumberOfRecords: numberOfRecords)
            case 5:
                K.getPredictionsByObviouslyCountAscendingWithSport(selectedSport, andNumberOfRecords: numberOfRecords)
            case 6:
                K.getPredictionsByObviouslyCountDescendingWithSport(selectedSport, andNumberOfRecords: numberOfRecords)
            default: break
                
            }
            
        }
    }
    
    /**
     Kumulos Delegate. Preforms when there was an error processing information.
     */
    func kumulosAPI(kumulos: kumulosProxy!, apiOperation operation: KSAPIOperation!, didFailWithError theError: String!) {
        
        ProcessingIndicator.stopProcessingIndicator(processingIndicator, viewsToUnHide: [sportPicker])
        
        let errorAlert = UIAlertController(title: "Error", message: "There was an error processing information. Please try again or restart the application.", preferredStyle: .Alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(errorAlert, animated: true, completion: nil)
        
    }
    
}


