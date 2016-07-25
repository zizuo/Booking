//
//  NewAccountTVC.swift
//  Booking_demo
//
//  Created by Ulukbek Saiipov on 3/2/16.
//  Copyright © 2016 Yaros. All rights reserved.
//

import UIKit
import SwiftyJSON
import JGProgressHUD
import CryptoSwift

class NewAccountTVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextFieldt: UITextField!
    @IBOutlet weak var sendOutlet: UIButton!
    
    let hud : JGProgressHUD = JGProgressHUD(style: JGProgressHUDStyle.Dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.endEditing(true)
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        self.sendOutlet.layer.cornerRadius = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    
    // MARK: - Actions
    @IBAction func sendAction(sender: AnyObject) {
        if emailTextField.text!.isEmail{
            print("email is correct")
            if passTextFieldt.text! != ""{
                    registerCustomer()
            }
            else{
                JSSAlertView().show(self, title: "error", text: "Пожалуйста, укажите правильный пароль", buttonText: "OK")            }
        }
        else{
            JSSAlertView().show(self, title: "error", text: "Пожалуйста, укажите действительную электронную почту", buttonText: "OK")
        }
        
    }
    
    // MARK: - Methods
    func registerCustomer(){
        
            let password = self.passTextFieldt.text
            let hash = password!.md5()
      
            hud.showInView(view)
            let params: Dictionary<String,AnyObject> = [LANG: "ru", LOGIN: emailTextField.text!, PASSWORD: hash, EMAIL: emailTextField.text!, NAME: "name"]
            
            let request = HTTPTask()
            request.requestSerializer = HTTPRequestSerializer()
            //request.requestSerializer.headers["Authorization"] = "Bearer \(User.sharedInstance.token)"
            
            request.POST("\(API_IP)reg", parameters: params, success: {(response : HTTPResponse) in
                
                if let data = response.responseObject as? NSData {
                    //let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    let json = JSON(data : data)
                    let meta = json["meta"]
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        JSSAlertView().show(self, title: "\(meta["status"])", text: meta["message"].string, buttonText: "OK")
                        self.hud.dismiss()
                        print(json)
                        self.emailTextField.text = ""
                        self.passTextFieldt.text = ""
                        //self.changeStoryBoard()
                        
                    })
                    
                }
                
                }, failure: {(error : NSError, response : HTTPResponse?) in
                    print("error: \(error)")
                    let data = response?.responseObject as? NSData
                    let jsno = JSON(data: data!)
                    let meta = jsno["meta"]
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.hud.dismiss()
                        let statusCode = jsno["meta"]["status"].string
                        
                        JSSAlertView().show(self, title: "ERROR : \(statusCode)", text: meta["message"].string!, buttonText: "OK", color: UIColor.whiteColor())
                    })
                    
            })
            
        }

        
    

}
