//
//  RoundIndicator.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 21/12/2018.
//  Copyright © 2018 Erik Hede. All rights reserved.
//

import UIKit

class RoundCornersWithBorder: UIView {

        @IBInspectable var borderColor: UIColor? {
            didSet {
                setupView()
            }
        }
        
        override func awakeFromNib() {
            setupView()
        }
        
        func setupView() {
            self.layer.cornerRadius = self.frame.width/2
            self.layer.borderWidth = 1.5
            self.layer.borderColor = borderColor?.cgColor
            
        }
}
