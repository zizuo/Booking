//
//  ViewController.swift
//  Booking_demo
//
//  Created by Ulukbek Saiipov on 2/10/16.
//  Copyright © 2016 Yaros. All rights reserved.
//

import UIKit

class SplashScreenViewController : UIViewController {

    let splashScreenDuration = 0.1
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delay(splashScreenDuration, closure: {
        })
        
    }
    
    func endSplashScreen() {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainViewController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
        self.endSplashScreen()
    }

}

