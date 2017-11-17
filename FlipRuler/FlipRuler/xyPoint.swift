//
//  xyzPoint.swift
//  How Far
//
//  Created by Jake Lepere on 7/6/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import Foundation

/**
 An xyPoint
 */
class xyPoint {
    
    var x:Double!
    var y:Double!
    
    init() {
        x = 0
        y = 0
    }
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    func changeInX(dx: Double) {
        x = x + dx
    }
    
    func changeInY(dy: Double) {
        y = y + dy
    }
    
    func changeInXY(dx: Double, dy: Double) {
        x = x + dx
        y = y + dy
    }
    
    func distanceFromZero() -> Double {
        return sqrt((x*x) + (y*y))
    }
    
    func reset() {
        x = 0
        y = 0
    }
    
}