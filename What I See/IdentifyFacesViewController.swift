//
//  IdentifyFacesViewController.swift
//  What I See
//
//  Created by Ibrahim Al-Khatib on 3/28/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit
import AVFoundation

class IdentifyFacesViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {

    lazy var cameraSession: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = AVCaptureSessionPresetPhoto
        return s
    }()
    
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) as AVCaptureDevice
    let dataOutput = AVCapturePhotoOutput()

    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview?.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        preview?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        preview?.videoGravity = AVLayerVideoGravityResize
        return preview!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(takePicture), name: NSNotification.Name(rawValue: "TakePicture"), object: nil)
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            cameraSession.beginConfiguration()
            if (cameraSession.canAddInput(deviceInput) == true) {
                cameraSession.addInput(deviceInput)
            }
//            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)] // 3
//            dataOutput.alwaysDiscardsLateVideoFrames = true
            if (cameraSession.canAddOutput(dataOutput) == true) {
                cameraSession.addOutput(dataOutput)
            }
            cameraSession.commitConfiguration()
//            let queue = DispatchQueue(label: "videoQueue")
//            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
        } catch {
            print(error.localizedDescription)
        }
        
        view.layer.addSublayer(previewLayer)
        
        cameraSession.startRunning()
    }
    
 
    func takePicture() {
        let settings = AVCapturePhotoSettings()
        dataOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard let photoSampleBuffer = photoSampleBuffer else { return }
        
        let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        let image = UIImage(data: data!)

    }
    
}
