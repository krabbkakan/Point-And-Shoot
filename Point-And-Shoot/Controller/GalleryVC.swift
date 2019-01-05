//
//  GalleryVCViewController.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 28/12/2018.
//  Copyright © 2018 Erik Hede. All rights reserved.
//

import UIKit


class GalleryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var filmrolls = [Film]()
    
    let bwRoll = UIImage(named: "BwRoll.png")
    let colorRoll = UIImage(named: "ColorFilm.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.size.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmrolls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmCell", for: indexPath) as! FilmCollectionViewCell
        cell.filmNameLabel.text = filmrolls[indexPath.item].name
        if filmrolls[indexPath.item].isBW {
        cell.filmCell.image = bwRoll
        } else {
           cell.filmCell.image = colorRoll
        }
        
        return cell
    }
    
}

extension GalleryVC: filmCreatorDelegate {
    func didDevelopFilm(date: Date, pictures: [UIImage], isBW: Bool, name: String) {
        let film = Film(name: name, date: date, pictures: pictures, isBW: isBW)
        filmrolls.append(film)
    }
    
}

