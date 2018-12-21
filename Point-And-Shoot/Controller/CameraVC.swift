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

class CameraVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var triggerButton: UIButton!
    
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var filmIndicator: RoundCornersWithBorder!
    
    @IBOutlet weak var hatchOpener: RoundCornersWithBorder!
    
    @IBOutlet weak var hatchView: HatchStyling!
    
    //Variables
    var pictures = [Picture]()
    
    var counter : Int = 0
    
    var isFilmLoaded : Bool = false
    
    //AVFoundation
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCamera()
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
        videoPreviewLayer!.connection?.videoOrientation =   AVCaptureVideoOrientation.landscapeLeft
        videoPreviewLayer?.frame = view.layer.bounds
        previewView.layer.addSublayer(videoPreviewLayer!)
    }
    
    func saveImage(image: UIImage) -> Bool {
        
        let filename = "image" + String(counter) + ".png"
        
        
        guard let data = image.jpegData(compressionQuality: 1.0) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(filename)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
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
        
        counter+=1
    }
    
    @IBAction func hatchOpenerPressed(_ sender: Any) {
       hatchView.animateHatch()
        //Destroy 3 images
        
        
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
        
        // Convert photo same buffer to a jpeg image data by using AVCapturePhotoOutput
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        //        AVCapturePhoto fileDataRepresentation]
        
        // Initialise an UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            // Save our captured image to photos album
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





