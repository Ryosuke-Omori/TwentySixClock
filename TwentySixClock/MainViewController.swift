//
//  MainViewController.swift
//  TwentySixClock
//
//  Created by 曽和修平 on 2015/09/18.
//  Copyright (c) 2015年 Nakagawa Ryo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.pagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool { //ステータスバー非表示
        return true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        setUpViews()
    }
    
    func setUpViews(){
        
        let homeClockSB = UIStoryboard(name: "HomeClock", bundle: NSBundle.mainBundle())
        let homeClockVC = homeClockSB.instantiateInitialViewController() as! HomeClockViewController
        
        let analogClockSB = UIStoryboard(name: "AnalogClockStoryboard", bundle: NSBundle.mainBundle())
        let analogClockVC = analogClockSB.instantiateInitialViewController() as! AnalogClockViewController
        
        
        self.addChildViewController(homeClockVC as UIViewController)
        self.addChildViewController(analogClockVC as UIViewController)
        homeClockVC.didMoveToParentViewController(self)
        analogClockVC.didMoveToParentViewController(self)
        
        let homeview : UIView = homeClockVC.view
        homeview.frame = CGRectMake(UIScreen.mainScreen().bounds.width, 0, UIScreen.mainScreen().bounds.width, self.view.frame.size.height)
        let analogview : UIView = analogClockVC.view
        analogview.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, self.view.frame.size.height)
        self.scrollView.addSubview(analogview)
        self.scrollView.addSubview(homeview)
        self.scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width*2, UIScreen.mainScreen().bounds.height)
        self.scrollView.contentOffset = CGPointMake(UIScreen.mainScreen().bounds.width, 0)
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
