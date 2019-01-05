//
//  HatchStyling.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 21/12/2018.
//  Copyright © 2018 Erik Hede. All rights reserved.
//

import UIKit

class HatchStyling: UIView {

    @IBInspectable var borderColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 3
        self.layer.borderColor = borderColor?.cgColor
        
    }
    
    func animateHatch() {
        // Make hatch shadow grow and skew hatch
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        
    }
    
    func animateHatchBackToNormal() {
        self.layer.masksToBounds = true
    }
    
    

}
