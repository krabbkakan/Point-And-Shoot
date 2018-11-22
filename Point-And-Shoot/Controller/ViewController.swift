//
//  ViewController.swift
//  Point-And-Shoot
//
//  Created by Erik Hede on 16/11/2018.
//  Copyright © 2018 Erik Hede. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
 
    @IBOutlet weak var previewView: UIView!
    
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
            
            createPreviewLayer(session: captureSession!)
           
            //start video capture
            captureSession?.startRunning()
        } catch {
            print(error)
        }
    }
    
    func createPreviewLayer(session: AVCaptureSession )  {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer!.connection?.videoOrientation =   AVCaptureVideoOrientation.landscapeLeft
        videoPreviewLayer?.frame = view.layer.bounds
        previewView.layer.addSublayer(videoPreviewLayer!)
    }
    
}




