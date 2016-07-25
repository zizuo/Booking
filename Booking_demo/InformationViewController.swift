//
//  InformationViewController.swift
//  Booking_demo
//
//  Created by Ulukbek Saiipov on 2/29/16.
//  Copyright © 2016 Yaros. All rights reserved.
//

import UIKit
import SideMenu

class InformationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar white font and tintColor
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#003580")
        // Change the color of the navigation bar title text to blue.
        self.setNavigationTitle("Информация")
    }
    
    @IBAction func sideMenu(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("sideMenu") as! UISideMenuNavigationController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
