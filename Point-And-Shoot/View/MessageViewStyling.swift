//
//  MessageViewStyling.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 29/12/2018.
//  Copyright © 2018 Erik Hede. All rights reserved.
//

import UIKit

class MessageViewStyling: UIView {
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        
        //size
        self.frame.size.width = screenSize.width * 0.7
        self.frame.size.height = screenSize.height * 0.7
        
        //rounded corners
        self.layer.cornerRadius = 5
        
        //Shadows
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        
        //Opacity
        self.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        
                
    }
}
