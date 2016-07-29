import UIKit

class AlertPopupNew: UIView {

    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    
    @IBAction func logIn(sender: AnyObject) {
        print("login.......")
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        print("createAccount.......")
    }

}
