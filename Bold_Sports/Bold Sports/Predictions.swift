//
//  Predictions.swift
//  Bold Sports
//
//  Created by Jake Lepere on 8/2/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import Foundation

/**
 A class to hold the predictions.
 */
class Predictions {
    
    // Variable to hold the predictions
    var predictions: [(username: String, prediction: String, sport: String, pollID: Int, noWayCount: Int, maybeCount: Int, obviouslyCount: Int, dateCreated: NSDate, userPollID: Int)]
    
    /**
     A blank initializer for the Prediction Class
     */
    init() {
        predictions = []
    }
    
    /**
     Appends a arediction to the array.
     @param predictionData A tuple containing all the necessary prediction data
     */
    func addPrediction(predictionData: (username: String, prediction: String, sport: String, pollID: Int, noWayCount: Int, maybeCount: Int, obviouslyCount: Int, dateCreated: NSDate, userPollID: Int)) {
        
        predictions.append(predictionData)
        
    }
    
    /**
     Returns the prediction at the given index.
     @param index the desired index
     @return the prediction at the given index.
     */
    func getPrediction(index: Int) -> (username: String, prediction: String, sport: String, pollID: Int, noWayCount: Int, maybeCount: Int, obviouslyCount: Int, dateCreated: NSDate, userPollID: Int) {
        
        return predictions[index]
        
    }
    
    /**
     Removes all the predictions from the current array.
     */
    func removeAll() {
        
        predictions.removeAll()
        
    }
    
    /**
     Removes the prediction as the inputted index.
     @param index the index to remove
     */
    func remove(index: Int) {
        
        predictions.removeAtIndex(index)
        
    }
    
    /**
     Gets the count of the predictions array.
     @return the number of elements in the array
     */
    func count() -> Int {
        return predictions.count
    }
    
    /**
     Extracts the prediction data from the anyObject returned from Kumulos APIs
     */
    static func extractPredictionData(result: AnyObject) -> (username: String, prediction: String, sport: String, pollID: Int, noWayCount: Int, maybeCount: Int, obviouslyCount: Int, dateCreated: NSDate, userPollID: Int) {
        
        let username = result["username"] as! String
        let prediction = result["prediction"] as! String
        let sport = result["sport"] as! String
        let pollID = result["pollID"] as! Int
        let noWayCount = result["noWayCount"] as! Int
        let maybeCount = result["maybeCount"] as! Int
        let obviousltCount = result["obviouslyCount"] as! Int
        let dateCreated = result["timeCreated"] as! NSDate
        let userPollID = result["userPollID"] as! Int
        
        return (username: username, prediction: prediction, sport: sport, pollID: pollID, noWayCount: noWayCount, maybeCount: maybeCount, obviouslyCount: obviousltCount, dateCreated: dateCreated, userPollID: userPollID)
        
        
    }
    
}
