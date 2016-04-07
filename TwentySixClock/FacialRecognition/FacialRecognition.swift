//
//  FacialRecognition.swift
//  TwentySixClock
//
//  Created by 曽和修平 on 2015/09/17.
//  Copyright (c) 2015年 Nakagawa Ryo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
@objc protocol FacialRecognitionDelegate {
    /***
    顔の認識結果が今までと変わったと判断した時に通知される。
    :isRecognized: trueで顔有、falseで顔無
    */
    func changeFaceRecognized(isRecognized:Bool) -> ()
}
class FacialRecognition {
    
    private let detector:CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyLow])
    private var currentFrames = 0
    var recognizedHistory:[Bool] = []
    var delegate:FacialRecognitionDelegate?
    var currentRecognized = false
    func faceRecognition(faceImg:UIImage){
        currentFrames += 1
        if(currentFrames % 15 == 0){
            let ciImage = CIImage(CGImage: faceImg.CGImage!)
            let imageOptions = [CIDetectorImageOrientation:NSNumber(integer: 6)]
            let array = detector.featuresInImage(ciImage,options:imageOptions)
            insertRecognizedHistory(isPresenceFace(array))
            decisionRecognizedChange()
        }
        if(currentFrames > 60){
            currentFrames = 0
        }
    }
    
    func insertRecognizedHistory(isRecognized:Bool){
        recognizedHistory.append(isRecognized)
        if(recognizedHistory.count > 3){
            recognizedHistory.removeAtIndex(0)
        }
    }
    
    //顔が存在しなくなったかどうかを認識履歴から判断するメソッド
    func decisionRecognizedChange(){
        let beforeRecognized = currentRecognized
        if(recognizedHistory.last == true){
            currentRecognized = true
        }
       
        if(recognizedHistory.count > 2){
            if(recognizedHistory.last==false && recognizedHistory[2]==false){
                currentRecognized = false
            }
        }
        if(beforeRecognized != currentRecognized){
            self.delegate?.changeFaceRecognized(currentRecognized)
        }
        
    }
    func isPresenceFace(features:[AnyObject])->Bool{
        if(features.count == 0){
            return false
        }
        return true
    }
}