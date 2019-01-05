//
//  User.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 04/01/2019.
//  Copyright © 2019 Erik Hede. All rights reserved.
//

import Foundation

class User {
    
    let defaults = UserDefaults.standard
    
    var email : String?
    
    func saveEmailToDefaults() {
        defaults.set(email, forKey: Keys.email)
    }
    
    func getEmailFromDefaults() {
        defaults.string(forKey: Keys.email)
    }
    
}
