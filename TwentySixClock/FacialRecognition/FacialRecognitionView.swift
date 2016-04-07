//
//  FacialRecognitionView.swift
//  TwentySixClock
//
//  Created by 曽和修平 on 2015/09/17.
//  Copyright (c) 2015年 Nakagawa Ryo. All rights reserved.
//

import UIKit
import AVFoundation

class FacialRecognitionView: UIView,AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var photoImageView: UIImageView!
    var videoInput: AVCaptureDeviceInput?
    var videoDataOutput: AVCaptureVideoDataOutput?
    var session: AVCaptureSession?
    let facialRecognition = FacialRecognition()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        comminInit()
    }
    
    private func comminInit() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "FacialRecognitionView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        view.frame = UIScreen.mainScreen().bounds
        addSubview(view)
        self.photoImageView.clipsToBounds = true
        self.initCamera()
        
    }
    func initCamera(){
//        var error: NSError?

        session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSessionPresetHigh;
        
        var camera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Front){
                camera = device as! AVCaptureDevice
            }
        }
      
//        do{
//            videoInput = AVCaptureDeviceInput.deviceInputWithDevice(camera) as? AVCaptureDeviceInput
//        } catch let e as NSError{
//            print("AVCaptureDeviceInputError: \(e)")
//        }
        do{
            videoInput = try AVCaptureDeviceInput(device: camera)
        } catch let e as NSError {
            print("AVCaptureDeviceInputError: \(e)")
        }
        session?.addInput(videoInput)
        
        videoDataOutput = AVCaptureVideoDataOutput()
        session?.addOutput(videoDataOutput)
        
        let queue = dispatch_queue_create("myQueue", nil)
        videoDataOutput?.alwaysDiscardsLateVideoFrames = true;
        videoDataOutput?.setSampleBufferDelegate(self, queue: queue)
        videoDataOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey : NSNumber(integer:Int(kCVPixelFormatType_32BGRA))];
        
//        if(camera.lockForConfiguration()){
        do {
            try camera.lockForConfiguration()
        } catch let e as NSError {
            print("lockForConfigurationError: \(e)")
        }
        camera.activeVideoMinFrameDuration = CMTimeMake(1, 15);
        camera.unlockForConfiguration()
//        }
        session!.startRunning()
    }
    func captureOutput(captureOutput: AVCaptureOutput, didOutputSampleBuffer sampleBuffer: CMSampleBufferRef, fromConnection connection:AVCaptureConnection) {
        let image: UIImage? = self.imageFromSampleBuffer(sampleBuffer)
        dispatch_async(dispatch_get_main_queue(), {
            self.photoImageView.image = image
            if let i = image{
                self.facialRecognition.faceRecognition(i)
            }
        })
    }
    
    private func imageFromSampleBuffer(sampleBuffer :CMSampleBufferRef) -> UIImage? {
        let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let uint: Int = Int(0)
        
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        
        let baseAddress: UnsafeMutablePointer<Void> = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, uint)
        
        let bytesPerRow: Int = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width: Int = CVPixelBufferGetWidth(imageBuffer)
        let height: Int = CVPixelBufferGetHeight(imageBuffer)
        
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        
        let bitsPerCompornent: Int = 8
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue) as UInt32)
        let newContext: CGContextRef = CGBitmapContextCreate(baseAddress, width, height, bitsPerCompornent, bytesPerRow, colorSpace, bitmapInfo.rawValue)! as CGContextRef
        let imageRef: CGImageRef = CGBitmapContextCreateImage(newContext)!
        
        let resultImage: UIImage? = UIImage(CGImage: imageRef, scale: 1.0, orientation: UIImageOrientation.Right)
        
        return resultImage
    }

}
