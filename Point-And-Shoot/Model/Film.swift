//
//  Film.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 23/11/2018.
//  Copyright © 2018 Erik Hede. All rights reserved.
//
import UIKit

class Film {
    var name : String = ""
    let creationDate : Date
    var pictures : [UIImage]
    let isBW : Bool
    
    init(name: String, date: Date, pictures: [UIImage], isBW: Bool) {
        self.name = name
        self.pictures = pictures
        self.creationDate = date
        self.isBW = isBW
    }
}
