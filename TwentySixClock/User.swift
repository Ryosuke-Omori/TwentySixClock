//
//  User.swift
//  TwentySixClock
//
//  Created by 大森　亮佑 on 2015/09/18.
//  Copyright (c) 2015年 Nakagawa Ryo. All rights reserved.
//

import Foundation
import UIKit

class User:NSObject{
    
    static let sharedUser = User()
    var lagCount = 0
    var secTime: CGFloat = 0
    dynamic var  recognize = false
    var startTime: NSDate{
        get {
            if let d =  NSUserDefaults.standardUserDefaults().objectForKey("startTime") as? NSDate{
                return d.dateByAddingTimeInterval(0)
            }else{
                return NSDate()
            }
            
        }
        set(newValue) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "startTime")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    
    func addLagCount() {
        if(lagCount <= 7200){
            lagCount+=3
        }
    }
    
    func calculateTime(secTime: CGFloat) {
        self.secTime = secTime + CGFloat(lagCount)
    }
    
    func resetLagCount() {
        let dateformatter = NSDateFormatter()
        let locale = NSLocale(localeIdentifier: "ja_JP")
        dateformatter.locale = locale
        dateformatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        dateformatter.dateFormat = "yyyy-MM-dd"
        let formattedDateString = dateformatter.stringFromDate(User.sharedUser.startTime)

        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let compareDate:NSDate = dateformatter.dateFromString("\(formattedDateString) 4:00:00")!

        print(User.sharedUser.startTime, terminator: "")
        //前回起動時刻が4時以前
        if User.sharedUser.startTime.compare(compareDate) == .OrderedAscending {
            //かつ今回起動時刻が4時以降
            print("前回起動時刻は四じ以前", terminator: "")
            if NSDate().dateByAddingTimeInterval(9*60*60).compare(compareDate) == .OrderedDescending{
                //経過時間リセット処理
                print("かつ今回起動時刻は4時以降", terminator: "")
                self.lagCount = 0
                NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "lagCount")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
}
