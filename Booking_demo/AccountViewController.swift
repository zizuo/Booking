//
//  AccountViewController.swift
//  Booking_demo
//
//  Created by Ulukbek Saiipov on 2/24/16.
//  Copyright © 2016 Yaros. All rights reserved.
//

import UIKit
import SideMenu
import SwiftyJSON
import JGProgressHUD
import CryptoSwift

class AccountViewController: UIViewController{
    // MARK: - Outlets
    @IBOutlet weak var facebookOutlet: UIButton!
    @IBOutlet weak var logInOutlet: UIButton!
    @IBOutlet weak var createAccountOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var containerViewAccount: UIView!
    
    let hud: JGProgressHUD = JGProgressHUD(style:JGProgressHUDStyle.Dark)

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        // Status bar white font and tintColor
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#003580")
        // Change the color of the navigation bar title text to blue.
        if User.sharedInstance.isLoggedIn {
            print("loggedIn")
        }else{
            self.setNavigationTitle("Мой аккаунт")

        }
        
        self.facebookOutlet.layer.cornerRadius = 3
        self.logInOutlet.layer.cornerRadius = 3
        self.createAccountOutlet.layer.cornerRadius = 3
        
        if  User.sharedInstance.isLoggedIn  {
            containerViewAccount.hidden = false
            changeStoryBoard()
        }
        else{
            containerViewAccount.hidden = true
        }

    }
    
    // MARK: - Actions
    @IBAction func sideMenu(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("sideMenu") as! UISideMenuNavigationController
        self.presentViewController(vc, animated: true, completion: nil)

    }
    
    @IBAction func logInByFacebookAction(sender: AnyObject) {
    }
    
    @IBAction func logInAction(sender: AnyObject) {
        if emailTextField.text!.isEmail {
            if passwordTextField.text! != ""{
                getUserLoginInfo()
            }
            else{
                JSSAlertView().show(self, title: "error", text: "Пожалуйста, укажите правильный пароль", buttonText: "OK")
            }
        }
        else{
            JSSAlertView().show(self, title: "error", text: "Пожалуйста, укажите действительную электронную почту", buttonText: "OK")
        }
    }
    
    @IBAction func forgotPassAction(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("ResetPassword") as! ResetPassword
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func createAccountAction(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("NewAccountTVC") as! NewAccountTVC
        vc.title = "Создайте аккаунт"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - MEthods
    func getUserLoginInfo(){
        
        hud.showInView(view)
        let password = self.passwordTextField.text
        let hash = password!.md5()
        
        let params: Dictionary<String,AnyObject> = [LANG : "ru", LOGIN: emailTextField.text!, PASSWORD: hash]
        
        let request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        
        request.POST("\(API_IP)auth", parameters: params, success: {(response: HTTPResponse) in
            
            if let data = response.responseObject as? NSData {
                
                let originalJson = JSON(data: data)
                let userData = originalJson["data"]
                let userMeta = originalJson["meta"]
                
                if userMeta["status"] == "SUCCESS" {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.containerViewAccount.hidden = false
                        
                        User.sharedInstance.isLoggedIn = true
                        User.sharedInstance.token = userData["token"].stringValue
                        User.sharedInstance.name = userData["name"].stringValue
                        User.sharedInstance.id = userData["_id"].intValue
                        User.sharedInstance.email = userData["email"].stringValue
                        User.sharedInstance.pictureUser = userData["avatar"].stringValue
                        User.sharedInstance.login = userData["login"].stringValue
                        
                        //self.saveUserEmailAndPass()
                        
                        self.passwordTextField.resignFirstResponder()
                        self.passwordTextField.text = ""
                        self.title = ""
                        //HomeViewController().collectionView?.reloadData()
                        
                        
                        self.hud.dismiss()
                        
                        LeftViewController().cellLabels[1] = "name"
                        //let vc = (self.storyboard?.instantiateViewControllerWithIdentifier("LeftViewController")) as! LeftViewController
    
                        self.changeStoryBoard()
                    })
            }
            else{
                    dispatch_async(dispatch_get_main_queue(),{
                        self.hud.dismiss()
                        self.passwordTextField.text = ""
                        JSSAlertView().show(self, title: "Ошибка авторизации", text: "Вы не авторизованы. Пожалуйста, проверьте свои электронный адрес и пароль.", buttonText: "OK")
                        })
                    
                    
                    //JSSAlertView().show(self, title: "Ошибка авторизации", text: "Вы не авторизованы. Пожалуйста, проверьте свои электронный адрес и пароль.", buttonText: "OK")
            }
                
                
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                print("error: \(error)")
                let data = response?.responseObject as? NSData
                let jsno = JSON(data: data!)
                dispatch_async(dispatch_get_main_queue(), {
                    self.hud.dismiss()
                    let statusCode = jsno["meta"]
                    
                    JSSAlertView().show(self, title: "\(statusCode["status"].stringValue)", text: statusCode["message"].string!, buttonText: "OK", color: UIColor.whiteColor())
                })
        })

    }
    
    
    //Changes storyBoard
    func changeStoryBoard(){
        // You can replace the container view with any view by ID
        let vc = (self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController")) as! ProfileViewController
        self.addChildViewController(vc)
        vc.view.frame = self.containerViewAccount.frame
        self.containerViewAccount.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
        
    }
}

