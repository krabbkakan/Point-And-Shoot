//
//  Picture.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 08/02/2019.
//  Copyright © 2019 Erik Hede. All rights reserved.
//

import Foundation

class Picture {
    private(set) var timestamp : Date!
    private(set) var isBw : Bool!
    private(set) var documentId : String!
    
    init(timestamp: Date, isBw: Bool, documentId: String) {
        self.timestamp = timestamp
        self.isBw = isBw
        self.documentId = documentId
    }
}
