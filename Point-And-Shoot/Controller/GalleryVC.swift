//
//  GalleryVCViewController.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 28/12/2018.
//  Copyright © 2018 Erik Hede. All rights reserved.
//

import UIKit
import CoreImage



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
        if filmrolls[indexPath.item].isBw {
        cell.filmCell.image = bwRoll
        } else {
           cell.filmCell.image = colorRoll
        }
        
        return cell
    }
    
//    func makeImageBlackAndWhite(image: UIImage) -> UIImage {
//      
//        guard let currentCGImage = image.cgImage else { return }
//        let currentCIImage = CIImage(cgImage: currentCGImage)
//        
//        let filter = CIFilter(name: "CIColorMonochrome")
//        filter?.setValue(currentCIImage, forKey: "inputImage")
//        
//        // set a gray value for the tint color
//        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
//        
//        filter?.setValue(1.0, forKey: "inputIntensity")
//        guard let outputImage = filter?.outputImage else { return }
//        
//        let context = CIContext()
//        
//        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
//            let processedImage = UIImage(cgImage: cgimg)
//            return processedImage
//        }
//        
//    }
    
}

extension GalleryVC: filmCreatorDelegate {
    func didDevelopFilm(date: Date, pictures: [Picture], isBW isBw: Bool, name: String) {
        let film = Film(name: name, pictures: pictures, isBw: isBw)
        filmrolls.append(film)
    }
    
}

