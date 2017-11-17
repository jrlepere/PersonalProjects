//
//  File.swift
//  Can't Decide
//
//  Created by Jake Lepere on 12/5/15.
//  Copyright © 2015 Jake Lepere. All rights reserved.
//

import UIKit

let choiceMgr:ChoiceManager = ChoiceManager() //Global variable that can be accessed throughout the project

struct Choice {
    var description: String = "Un-Described"
}

class ChoiceManager: NSObject {
    var choices = [Choice]() //Hold all array of tasks
    
    func addChoice(description: String) {
        choices.append(Choice(description: description))
    }
}

