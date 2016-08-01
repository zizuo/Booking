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
