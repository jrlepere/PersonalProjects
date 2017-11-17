//
//  IndividualUserPredictionViewController.swift
//  Bold Sports
//
//  Created by Jake Lepere on 8/8/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

class IndividualUserPredictionViewController: UIViewController {
    
    // Outlets
    @IBOutlet var userPredictionText: UITextView!
    @IBOutlet var barGraphView: UIView!
    @IBOutlet var dateCreatedText: UITextField!
    
    // Additional
    var predictionData: (username: String, prediction: String, sport: String, pollID: Int, noWayCount: Int, maybeCount: Int, obviouslyCount: Int, dateCreated: NSDate, userPollID: Int)!
    
    /**
     Preforms when the view loads.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Outlets: userPredictionText
        self.userPredictionText.text = predictionData.prediction
        self.userPredictionText.layer.borderWidth = 0.5
        self.userPredictionText.layer.borderColor = UIColor.blackColor().CGColor
        
        // Outlets: barGraphView
        self.barGraphView.layer.borderWidth = 0.5
        self.barGraphView.layer.borderColor = UIColor.blackColor().CGColor
        
        // Outlets: dateCreatedText
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        self.dateCreatedText.text = "Date Created: \(dateFormatter.stringFromDate(predictionData.dateCreated))"
        
    }
    
    /**
     Preforms when the view appears
     */
    override func viewDidAppear(animated: Bool) {
        
        if (predictionData.noWayCount + predictionData.maybeCount + predictionData.obviouslyCount != 0) {
            let viewsForGraph = VotesBarGraph.generateViews(predictionData.noWayCount, maybeCount: predictionData.maybeCount, obviouslyCount: predictionData.obviouslyCount, meterViewFrame: self.barGraphView.frame)
        
            self.barGraphView.addSubview(viewsForGraph.maybeBar)
            self.barGraphView.addSubview(viewsForGraph.noWayBar)
            self.barGraphView.addSubview(viewsForGraph.obviouslyBar)
            self.barGraphView.addSubview(viewsForGraph.textView)
        }
        
    }
    
}
