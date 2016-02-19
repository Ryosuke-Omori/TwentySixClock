//
//  HomeClockView.swift
//  TwentySixClock
//
//  Created by 大森　亮佑 on 2015/09/17.
//  Copyright (c) 2015年 Nakagawa Ryo. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable


class HomeClockView : UIView {
    var myComponents:NSDateComponents = NSDateComponents()
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    
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
        let nib = UINib(nibName: "HomeClock", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView

        self.opaque = false
        view.backgroundColor = UIColor.clearColor()

        //viewの中にsubViewとしてUIViewクラスのものがあるので
        //forでサブビュー全部を一旦見に行って、UIviewのやつなら背景を透明に（clearColor）にするっていう処理だよ。
        //完成させ切る方が重要だから、時間が余ったらもっとかっこいい実装とか考えてみて！
        //ある程度僕がガチャガチャやった部分は巻き戻しておいたので、引き続き頑張ってください。
        for childView in view.subviews {
            if (childView as NSObject).dynamicType.isEqual(UIView) {
                let tmpView:UIView = childView 
                tmpView.backgroundColor = UIColor.clearColor()
            }
        }

        addSubview(view)
        self.update()
    }
    
    
    func update() {
        NSTimer.scheduledTimerWithTimeInterval(1/60, target: self, selector: "nowTime", userInfo: nil, repeats: true)
    }
    
    func nowTime(){
        
        let myDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        myComponents = myCalendar.components(
            [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Weekday],
            fromDate: myDate)
        
        let weekDayString: Array = ["nil", "月", "火", "水", "木", "金", "土", "日"]
        
        let LagTime = NSDate(timeIntervalSinceNow:NSTimeInterval(User.sharedUser.lagCount))
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "MM"
        monthLabel.text = dateformatter.stringFromDate(LagTime)
        dateformatter.dateFormat = "dd"
        daysLabel.text = dateformatter.stringFromDate(LagTime)
        dateformatter.dateFormat = "E"
        dayOfTheWeekLabel.text = "\(dateformatter.stringFromDate(LagTime))曜日"
        dateformatter.dateFormat = "HH"
        hourLabel.text = dateformatter.stringFromDate(LagTime)
        hourLabel.font = UIFont(name: ".HiraKakuInterface-W1", size:79)
        dateformatter.dateFormat = "mm"
        minutesLabel.text = dateformatter.stringFromDate(LagTime)
        minutesLabel.font = UIFont(name: ".HiraKakuInterface-W1", size:79)

    }
    
}
