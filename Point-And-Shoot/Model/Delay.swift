//
//  Delay.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 08/02/2019.
//  Copyright © 2019 Erik Hede. All rights reserved.
//

import Foundation

public class Delay {
    let now = Date()
    let inThreeDays = Date().addingTimeInterval(259200)
    let test = Date().addingTimeInterval(30)
    
    func isTimeOlderThanThreeDays(date: Date) -> Bool {
        if date > self.inThreeDays {
            return true;
        }
        return false
    }
    
    func getCurrentTime() -> Date {
        return self.now
    }
}

