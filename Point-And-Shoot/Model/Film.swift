//
//  Film.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 23/11/2018.
//  Copyright © 2018 Erik Hede. All rights reserved.
//
import UIKit
import FirebaseStorage

class Film {
    var name : String = ""
    let creationDate : Date
    let isBw : Bool
    let dateForShowing : Date
    var pictures : [Picture]
    
    
    //Firebase storage
    var imageStorageRef : StorageReference {
        return Storage.storage().reference() .child("images")
    }
    
    
    
    init(name: String, pictures: [Picture], isBw: Bool) {
        
        let delay = Delay()
        

        self.isBw = isBw
        self.name = name
        self.pictures = pictures
        self.creationDate = delay.now
        self.dateForShowing = delay.inThreeDays
        
    }
    
    func downloadImage() {
        
        let filename : String = img + String() + jpg
        
        let downloadImageRef = imageStorageRef.child(filename)
        
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                
                //set whats gonna happen to the ui image here
                
                
                
            }
            print(error ?? "NO ERROR")
        }
        
        downloadtask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        
        downloadtask.resume()
        
    }
    
    func fetchImagesFromStorage() -> Bool {
        //populate pictures with images from firebase sorage
        
        //if successful return true
        return true
    }
}
