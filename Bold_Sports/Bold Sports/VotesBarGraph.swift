//
//  VotesBarGraph.swift
//  Bold Sports
//
//  Created by Jake Lepere on 8/4/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

class VotesBarGraph {
    
    /**
     Creates the necessary views for the bar graph
     @param noWayCount the number of no way votes
     @param maybeCount the number of maybe votes
     @param obviouslyCount the number of obviously count
     @param meterViewFrame the frame of the background uiview
     @return a tuple containing all relevant views
     */
    static func generateViews(noWayCount: Int, maybeCount: Int, obviouslyCount: Int, meterViewFrame: CGRect) -> (noWayBar: UIView, maybeBar: UIView, obviouslyBar: UIView, textView: UILabel) {
    
        let maxVotes = maybeCount + noWayCount + obviouslyCount
        let noWayRatio: CGFloat = (CGFloat(noWayCount) / CGFloat(maxVotes))
        let maybeRatio: CGFloat = (CGFloat(maybeCount) / CGFloat(maxVotes))
        let obviouslyRatio: CGFloat = (CGFloat(obviouslyCount) / CGFloat(maxVotes))
        
        let meterRatio:CGFloat = 0.25
        let nonMeterRatio:CGFloat = ((1-(meterRatio*3))/4)
        let frameHeight = meterViewFrame.height
        let frameWidth = meterViewFrame.width
        
        let noWayMeter = UIView(frame: CGRect(x: 0, y: frameHeight * nonMeterRatio, width: frameWidth * noWayRatio, height: frameHeight * meterRatio))
        noWayMeter.backgroundColor = UIColor.redColor()
        
        let maybeMeter = UIView(frame: CGRect(x: 0, y: frameHeight * (meterRatio + (nonMeterRatio * 2)), width: frameWidth * maybeRatio, height: frameHeight * meterRatio))
        maybeMeter.backgroundColor = UIColor.yellowColor()
        
        let obviouslyMeter = UIView(frame: CGRect(x: 0, y: frameHeight * ((meterRatio * 2) + (nonMeterRatio * 3)), width: frameWidth * obviouslyRatio, height: frameHeight * meterRatio))
        obviouslyMeter.backgroundColor = UIColor.greenColor()
        
        let totalVotesWidthRatio: CGFloat = 0.25
        let totalVotesHeightRatio: CGFloat = 0.25
        let totalVotesWidth = (frameWidth*totalVotesWidthRatio)
        let totalVotesTextView = UILabel(frame: CGRect(x: frameWidth - totalVotesWidth, y: 0, width: totalVotesWidth-5, height: frameHeight * totalVotesHeightRatio))
        totalVotesTextView.text = "Votes: \(maxVotes)"
        totalVotesTextView.adjustsFontSizeToFitWidth = true
        totalVotesTextView.textAlignment = .Right
        totalVotesTextView.backgroundColor = UIColor.clearColor()
        
        return (noWayBar: noWayMeter, maybeBar: maybeMeter, obviouslyBar: obviouslyMeter, textView: totalVotesTextView)
        
    }
    
}