//
//  AnalogClockView.swift
//  TwentySixClock
//
//  Created by 大森　亮佑 on 2015/09/17.
//  Copyright (c) 2015年 Nakagawa Ryo. All rights reserved.
//

import Foundation
import UIKit


class AnalogClockView : UIView, FacialRecognitionDelegate {
    
    var backgroundImageView: UIImageView!
    var secImageView: UIImageView!
    var minImageView: UIImageView!
    var hourImageView: UIImageView!
    var isRecognized = false
    
    init(){
        super.init(frame :CGRectZero)
        
    }
    
    func makeHand() {
        
        self.backgroundColor = UIColor.blackColor()
        
        let backgroundImage = UIImage(named: "AnalogClock")
        let imageScale: CGFloat = self.frame.size.width / backgroundImage!.size.width
        backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = CGRectMake(0, 0, backgroundImageView.frame.width * imageScale, backgroundImageView.frame.height * imageScale)
//        backgroundImageView.frame.size = CGSize(width: self.frame.size.width, height: self.frame.size.width)
        backgroundImageView.center = self.center
        
        let secImage = UIImage(named: "secHand")
        secImageView = UIImageView(image: secImage)
        secImageView.frame = CGRectMake(0, 0, secImageView.frame.size.width * imageScale, secImageView.frame.size.height * imageScale)
        secImageView.layer.anchorPoint = CGPointMake(0.5, 0.94)
        secImageView.center = self.center
        
        let minImage = UIImage(named: "minHand")
        minImageView = UIImageView(image: minImage)
        minImageView.frame = CGRectMake(0, 0, minImageView.frame.size.width * imageScale, minImageView.frame.size.height * imageScale)
        minImageView.layer.anchorPoint = CGPointMake(0.5, 0.98)
        minImageView.center = self.center
        
        let hourImage = UIImage(named: "hourHand")
        hourImageView = UIImageView(image: hourImage)
        hourImageView.frame = CGRectMake(0, 0, hourImageView.frame.size.width * imageScale, hourImageView.frame.size.height * imageScale)
        hourImageView.layer.anchorPoint = CGPointMake(0.5, 0.84)
        hourImageView.center = self.center
        
        self.addSubview(backgroundImageView)
        self.addSubview(secImageView)
        self.addSubview(minImageView)
        self.addSubview(hourImageView)
        
        
    }
    
    
    func startClock() {
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "reloadClock", userInfo: nil, repeats: true)
        
    }
    
    
    func reloadClock() {
        
        let myDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let myComponents = myCalendar.components(
            [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second],
            fromDate: myDate)
        
        var minute:CGFloat = 60 * CGFloat(myComponents.hour) + CGFloat(myComponents.minute)
        let second:CGFloat = (60 * 60 * CGFloat(myComponents.hour)) + (60 * CGFloat(myComponents.minute)) + CGFloat(myComponents.second)
        
        if !isRecognized {
            User.sharedUser.addLagCount()
        }
        
        User.sharedUser.calculateTime(second)
        let userSecond = User.sharedUser.secTime
        
        let rotateHour = CGAffineTransformMakeRotation(2 * CGFloat(M_PI) * userSecond / (60*60*12))
//        var rotateMin = CGAffineTransformMakeRotation(2 * CGFloat(M_PI) * CGFloat(myComponents.minute) / 60)
        let rotateMin = CGAffineTransformMakeRotation(2 * CGFloat(M_PI) * (userSecond%(60*60)) / (60*60))
//        var rotateSec = CGAffineTransformMakeRotation(2 * CGFloat(M_PI) * CGFloat(myComponents.second) / 60)
        let rotateSec = CGAffineTransformMakeRotation(2 * CGFloat(M_PI) * (userSecond%(60)) / (60))
        
        UIView.animateWithDuration(0.1,
            animations: {
                self.secImageView.transform = rotateSec
                self.minImageView.transform = rotateMin
                self.hourImageView.transform = rotateHour
        })
    }
    
    
    func changeFaceRecognized(isRecognized: Bool) {
        print("顔認識", terminator: "")
        self.isRecognized = isRecognized
        User.sharedUser.recognize=self.isRecognized
        print(self.isRecognized)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
