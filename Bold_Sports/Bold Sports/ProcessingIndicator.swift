//
//  ProcessingIndicator.swift
//  Bold Sports
//
//  Created by Jake Lepere on 8/15/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

class ProcessingIndicator {
    
    static func startProcessingIndicator(theProcessingIndicator: UIActivityIndicatorView, viewsToHide:[UIView]) {
        
        theProcessingIndicator.startAnimating()
        
        for view in viewsToHide {
            view.userInteractionEnabled = false
        }
        
    }
    
    static func stopProcessingIndicator(theProcessingIndicator: UIActivityIndicatorView, viewsToUnHide:[UIView]) {
        
        theProcessingIndicator.stopAnimating()
        
        for view in viewsToUnHide {
            view.userInteractionEnabled = true
        }
        
    }
    
}