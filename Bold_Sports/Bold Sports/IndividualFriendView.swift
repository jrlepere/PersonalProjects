//
//  IndividualFriendView.swift
//  Bold Sports
//
//  Created by Jake Lepere on 8/24/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

class IndividualFriendView: UIViewController, UITableViewDelegate, UITableViewDataSource, KumulosDelegate {
    
    // Outlets
    @IBOutlet var dateJoinedTextField: UITextField!
    @IBOutlet var numberOfVotesMadeTextField: UITextField!
    @IBOutlet var numberOfVotesRecievedTextField: UITextField!
    @IBOutlet var predictionTableView: UITableView!
    @IBOutlet var votesRecievedGraphView: UIView!
    
    // Kumulos
    let K = Kumulos()
    
    // Additional
    var userInfo:UserInfo!
    var userPredictionsArray:[(prediction: String, votesRecieved:Int)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar
        self.navigationItem.title = userInfo.username
        
        // Kumulos
        K.delegate = self
        
        // Outlets: Table View
        predictionTableView.delegate = self
        predictionTableView.dataSource = self
        
        // Outlets: Text Views
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dateJoinedTextField.text = "Date Joined: \(formatter.stringFromDate(userInfo.dateCreated))"
        numberOfVotesMadeTextField.text = "Total Votes Made: \(userInfo.totalVotesCount)"
        numberOfVotesRecievedTextField.text = "Total Votes Recieved: \(userInfo.noWayCount + userInfo.maybeCount + userInfo.obviouslyCount)"
        dateJoinedTextField.userInteractionEnabled = false
        numberOfVotesRecievedTextField.userInteractionEnabled = false
        numberOfVotesMadeTextField.userInteractionEnabled = false
        
        // UserPredictionArray
        userPredictionsArray = []
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        K.getPredictionsByUserWithUsername(userInfo.username)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userPredictionsArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let userPredictionData = userPredictionsArray[indexPath.row]
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "")
        cell.textLabel?.text = userPredictionData.prediction
        cell.detailTextLabel?.text = "\(userPredictionData.votesRecieved) Votes Recieved"
        
        return cell
        
    }
    
    func kumulosAPI(kumulos: Kumulos!, apiOperation operation: KSAPIOperation!, getPredictionsByUserDidCompleteWithResult theResults: [AnyObject]!) {
        
        for predictionData in theResults {
            
            let prediction = predictionData["prediction"] as! String
            let noWayCount = predictionData["noWayCount"] as! Int
            let maybeCount = predictionData["maybeCount"] as! Int
            let obviouslyCount = predictionData["obviouslyCount"] as! Int
            
            userPredictionsArray.append((prediction: prediction, votesRecieved: (noWayCount + maybeCount + obviouslyCount)))
            
        }
        
        generateViews()
        
        predictionTableView.reloadData()
        
    }
    
    private func generateViews() {
        
        print(userInfo.noWayCount + userInfo.maybeCount + userInfo.obviouslyCount)
        if (userInfo.noWayCount + userInfo.maybeCount + userInfo.obviouslyCount > 0) {
            // More than one prediction made
            let views = VotesBarGraph.generateViews(userInfo.noWayCount, maybeCount: userInfo.maybeCount, obviouslyCount: userInfo.obviouslyCount, meterViewFrame: votesRecievedGraphView.frame)
            votesRecievedGraphView.addSubview(views.maybeBar)
            votesRecievedGraphView.addSubview(views.noWayBar)
            votesRecievedGraphView.addSubview(views.obviouslyBar)
            votesRecievedGraphView.addSubview(views.textView)
        } else {
            let noPredictionText = UILabel(frame: CGRect(x: 0, y: 0, width: self.votesRecievedGraphView.frame.width, height: votesRecievedGraphView.frame.height))
            noPredictionText.text = "No Votes Recieved!"
            noPredictionText.textAlignment = NSTextAlignment.Center
            noPredictionText.userInteractionEnabled = false
            votesRecievedGraphView.addSubview(noPredictionText)
        }
        
    }
    
}
