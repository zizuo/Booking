//
//  ResetPassword.swift
//  Booking_demo
//
//  Created by Ulukbek Saiipov on 3/3/16.
//  Copyright © 2016 Yaros. All rights reserved.
//

import UIKit

class ResetPassword: UIViewController {

    @IBOutlet weak var resetPassword: UIButton!
    @IBOutlet weak var cancel : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        resetPassword.layer.cornerRadius = 3
        
    }
}
