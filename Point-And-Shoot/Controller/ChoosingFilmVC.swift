//
//  ChoosingFilmVC.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 10/12/2018.
//  Copyright © 2018 Erik Hede. All rights reserved.
//

import UIKit

class ChoosingFilmVC: UIViewController {
    
    @IBOutlet weak var bw24Button: UIButton!
    @IBOutlet weak var bw36Button: UIButton!
    @IBOutlet weak var color24Button: UIButton!
    
    //Variables
    var numberOfPicsChoosen : Int = 24
    var isBW = true
    
    var film : Film = Film(name: "", numberOfPics: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func buttonTapped(_ sender: UIButton) {
        switch sender {
        case bw24Button:
            film.name = "myFilm24"
            film.numberOfPics = 24
        case bw36Button:
            film.name = "myFilm36"
            film.numberOfPics = 24
        case color24Button:
            film.name = "myFilmColor"
            film.numberOfPics = 36
        default:
            return
        }
}
}














