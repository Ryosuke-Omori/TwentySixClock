//
//  AnalogClockViewController.swift
//  TwentySixClock
//
//  Created by 曽和修平 on 2015/09/18.
//  Copyright (c) 2015年 Nakagawa Ryo. All rights reserved.
//

import UIKit

class AnalogClockViewController: UIViewController {
    let analogClockView = AnalogClockView()
    
    @IBOutlet weak var cameraView: FacialRecognitionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        User.sharedUser.startTime = NSDate()
        User.sharedUser.secTime = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("secTime"))
        print(User.sharedUser.secTime, terminator: "")
        User.sharedUser.lagCount = NSUserDefaults.standardUserDefaults().integerForKey("logCount")
        analogClockView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        analogClockView.makeHand()
        analogClockView.startClock()
        cameraView.facialRecognition.delegate = analogClockView
        self.view.addSubview(analogClockView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
