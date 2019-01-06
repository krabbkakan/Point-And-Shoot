//
//  ViewController.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 16/11/2018.
//  Copyright © 2018 Erik Hede. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation
import SVProgressHUD
import Firebase
import FirebaseStorage

protocol filmCreatorDelegate {
    func didDevelopFilm(date: Date, pictures: [UIImage], isBW: Bool, name: String)
}

class CameraVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var triggerButton: UIButton!
    
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var filmIndicator: RoundCornersWithBorder!
    
    @IBOutlet weak var hatchOpener: RoundCornersWithBorder!
    
    @IBOutlet weak var hatchView: HatchStyling!
    
    //Variables
    var filmName : String = ""
    
    var pictures = [UIImage]()
    
    var isFilmLoaded : Bool = false
    
    var isGalleryButtonActive : Bool = false
    
    var isCurrentFilmBW : Bool = false
    
    var counter : Int = 0
    
    let defaults = UserDefaults.standard
    
    let imageTools = ImageTools()
    
    var creatorDelegate : filmCreatorDelegate!
    
    
    //AVFoundation
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    //Firebase sorage
    var imageStorageRef : StorageReference {
        return Storage.storage().reference() .child("images")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareCamera()
        
        isGalleryButtonActive = checkGalleryButton()
        
        isCurrentFilmBW = checkIfBW()
        
        counter = checkCurrentPic()
        setCounterOnCamera(counterNum: counter)
    }
    
    func prepareCamera() {
        
        captureSession?.sessionPreset = AVCaptureSession.Preset.photo
        startSession()
    }
    
    func startSession() {
      
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            createOutput()
            
            createPreviewLayer(session: captureSession!)
           
            //start video capture
            captureSession?.startRunning()
        } catch {
            print(error)
        }
    }
    
    func createOutput() {
       
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        
        captureSession?.addOutput(capturePhotoOutput!)
    }
    
    func createPreviewLayer(session: AVCaptureSession )  {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
        videoPreviewLayer?.frame = view.layer.bounds
        previewView.layer.addSublayer(videoPreviewLayer!)
    }
    
    func saveImage(image: UIImage) -> Bool {
        
        // saving to directory
        
//        let filename = img + String(checkCurrentPic()) + png
//
//
//        guard let data = image.jpegData(compressionQuality: 1.0) ?? image.pngData() else {
//            return false
//        }
//        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
//            return false
//        }
//        do {
//            try data.write(to: directory.appendingPathComponent(filename)!)
//            return true
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
        
        // saving to firebase storage
        
        var imageData = Data()
        imageData = image.jpegData(compressionQuality: 0.75)!
        
        let filename : String = img + String(checkCurrentPic()) + jpg
        
        let uploadImageRef = imageStorageRef.child(filename)
        
        let uploadImageTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("upload task finished")
            print(metadata ?? "No Metadata")
            print(error ?? "No Error")
            SVProgressHUD.dismiss()
            // enable button
        }
        
        uploadImageTask.observe(.progress) { (snapshot) in
            SVProgressHUD.show()
            // disable butto
            print(snapshot.progress ?? "No more progress")
        }
        
        uploadImageTask.resume()
    
        return true

    }
    
    @IBAction func takeAPhoto(_ sender: Any) {
        
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
      
        // Call capturePhoto method by passing our photo settings and a
        // delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
        
        counter-=1
        setCounterOnCamera(counterNum: counter)
        setCounterInDefaults(picNumber: counter)
        
        if counter <= 1 {
            developFilm()
        }
        
    }
    
//    func saveImageURLToDefaults(url: URL, key: String) {
//        defaults.set(url, forKey: key)
//    }
    
    func setCounterInDefaults(picNumber: Int) {
        
//        var currentPic : Int = checkCurrentPic()
//
//        currentPic += 1
        
        defaults.set(picNumber, forKey: Keys.currentPicNumber)
        
    }
    
    func checkCurrentPic() -> Int {
        
        let int = defaults.integer(forKey: Keys.currentPicNumber)
        
        let currentPic : Int = int
        
        print("currentPic: \(currentPic)")
        
        return currentPic
    }
    
    func setCounterOnCamera(counterNum: Int) {
        let counterNumStringVal = String(counterNum)
        counterLabel.text = counterNumStringVal
    }
    
    func setToBW() {
        defaults.set(true, forKey: Keys.isBW)
    }
    
    func checkIfBW() -> Bool {
        //returns true if BW
        return defaults.bool(forKey: Keys.isBW)
    }
    
    func setGalleryButtonActive() {
        
        if !isGalleryButtonActive {
            defaults.set(true, forKey: Keys.isGalleryButtonActive)
        }
        
        // Show Button on camera
        
    }
    
    func checkGalleryButton() -> Bool {
        return defaults.bool(forKey: Keys.isGalleryButtonActive)
    }
    
    func developFilm() {
        triggerButton.isEnabled = false
        triggerButton.isHidden = true
        
        filmName = nameFilm()
        
        // loop through all pictures taken and create a film roll with them in
       
        for index in 1...36 {
            let picture : UIImage? = imageTools.loadImageFromDocumentDirectory(nameOfImage: img + String(index) + png)
            
            if let pic = picture {
                pictures.append(pic)
            } else{
               return
            }
        }
        

        
        // make a segue to galleryVC
        
        creatorDelegate.didDevelopFilm(date: Date(), pictures: pictures, isBW: isCurrentFilmBW, name: filmName)
        let galleryVC = storyboard?.instantiateViewController(withIdentifier: "galleryVC") as! GalleryVC
        present(galleryVC, animated: true, completion: nil)
        
        // in galleryVC, show filmroll icon with name
        //if roll is pushed, show the containing pictures
        
        setGalleryButtonActive()
        
    }
    
    func nameFilm() -> String {
        var filmname = "Your filmroll"
        
        let alert = UIAlertController(title: "name your film roll:", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Write here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("name: \(name)")
                filmname = name
            }
        }))
        
        self.present(alert, animated: true)
        return filmname
    }
    
    @IBAction func hatchOpenerPressed(_ sender: Any) {
       hatchView.animateHatch()
        
        // if film loaded
        
        //Destroy 3 images
        
        // show message
        
        // if no film
        // segue to choose filmVC
        
        if !isFilmLoaded {
            let filmChoiceVC = storyboard?.instantiateViewController(withIdentifier: "ChoosingFilmVC") as! ChoosingFilmVC
            filmChoiceVC.selectionDelegate = self
            present(filmChoiceVC, animated: true, completion: nil)
        }

    }
    
}

extension CameraVC : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        // Convert photo buffer to jpeg image data by using AVCapturePhotoOutput
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        //        AVCapturePhoto fileDataRepresentation]
        
        // Initialise an UIImage with image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            // Save captured image to photos album
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            //Saving image to directory
            let success = saveImage(image: image)
            
            if success {
                print("image Saved")
            } else {
                print("Image couldnt be saved")
                return
            }
           
        }
    }
}

extension CameraVC: filmSelectionDelegate {
    func didTapChoice(numOfpics: Int, isBW: Bool) {
        counter = numOfpics
        isCurrentFilmBW = isBW

        isFilmLoaded = true
        setCounterOnCamera(counterNum: counter)
        setCounterInDefaults(picNumber: counter)
        hatchView.animateHatchBackToNormal()
        filmIndicator.makeGreen()
    }
}





