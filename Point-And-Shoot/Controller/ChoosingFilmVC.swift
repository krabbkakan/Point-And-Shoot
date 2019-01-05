//
//  ChoosingFilmVC.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 10/12/2018.
//  Copyright © 2018 Erik Hede. All rights reserved.
//

import UIKit

protocol filmSelectionDelegate {
    func didTapChoice(numOfpics: Int, isBW: Bool)
}

class ChoosingFilmVC: UIViewController {
    
    var selectionDelegate : filmSelectionDelegate!
    
    @IBOutlet weak var bw24Button: UIButton!
    @IBOutlet weak var bw36Button: UIButton!
    @IBOutlet weak var color24Button: UIButton!
    
//    //Variables
//    var numberOfPicsChoosen : Int = 24
//    var isBW = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func twentyFourBwTapped(_ sender: Any) {
        selectionDelegate.didTapChoice(numOfpics: 24, isBW: true)
        dismiss(animated: true, completion: nil)
    }
   
    @IBAction func thirtySixBwTapped(_ sender: Any) {
        selectionDelegate.didTapChoice(numOfpics: 36, isBW: true)
        dismiss(animated: true, completion: nil)
    }
  
    @IBAction func twentyFourColorTapped(_ sender: Any) {
        selectionDelegate.didTapChoice(numOfpics: 24, isBW: false)
        dismiss(animated: true, completion: nil)
    }
    
}














