//
//  ViewController.swift
//  TwentySixClock
//
//  Created by 中川　諒 on 2015/09/17.
//  Copyright (c) 2015年 Nakagawa Ryo. All rights reserved.
//

import UIKit

class HomeClockViewController: UIViewController {
    
    let homeClockView = HomeClockView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let application = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setUpslideLockLabel", name: UIApplicationDidBecomeActiveNotification, object: application)
        self.setUpslideLockLabel()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool { //ステータスバー非表示
        return true
    }
    
  
    //以下スライドでロック解除実装部分
    func setUpslideLockLabel(){
        let gradientView = UIView(frame: CGRectMake(0, 0, 1000, 1000))
        self.insertGradietLayer(gradientView)
        print(self.view.frame.size.height, terminator: "")
        let label = UILabel(frame: CGRectMake(self.view.frame.size.width-320,self.view.frame.size.height-160,320, 160))
        label.textColor = UIColor.blackColor()
        label.font = UIFont(name: ".HiraKakuInterface-W1", size: 24)
        label.text = "〉スライドでロック解除"
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = UIColor.clearColor()
        
        let maskImage = self.imageFromView(label)
        
        let mask = CALayer()
        mask.contents = maskImage.CGImage
        mask.frame = CGRectMake(0, self.view.frame.size.height-160, maskImage.size.width, maskImage.size.height)
        gradientView.layer.mask = label.layer
        self.view.addSubview(gradientView)
    }
    func imageFromView(view:UIView)->UIImage{
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextTranslateCTM(context, -view.frame.origin.x, -view.frame.origin.y)
        view.layer.renderInContext(context)
        let renderImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return renderImage
    }
    
    func insertGradietLayer(view:UIView){
        let beginColor = UIColor.darkGrayColor()
        let endColor = UIColor.whiteColor()
        let fromColors:[AnyObject] = [beginColor.CGColor,beginColor.CGColor,beginColor.CGColor,endColor.CGColor,beginColor.CGColor,beginColor.CGColor,beginColor.CGColor]
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.duration = 2.5
        animation.repeatCount = 9999999
        animation.fromValue = -220
        animation.toValue = 500
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = fromColors
        gradientLayer.startPoint = CGPointMake(0, 0)
        gradientLayer.endPoint = CGPointMake(1.0, 0)
        gradientLayer.addAnimation(animation, forKey: nil)
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
    }
    
}

