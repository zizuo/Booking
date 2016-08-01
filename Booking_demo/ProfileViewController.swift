import UIKit
import APAvatarImageView

class ProfileViewController: UIViewController {

    var items = NSArray()

    
    //MARK: - Outlets
    @IBOutlet weak var avatarImageView: APAvatarImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.cleanNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        items = ["Предпочтения", "Профиль"]
        
        // Do any additional setup after loading the view, typically from a nib.
        self.avatarImageView.image = UIImage(named: "empty_avatar")
        self.avatarImageView.borderColor = UIColor.whiteColor()
        self.avatarImageView.borderWidth = 6.0
        self.title = ""
        self.nameLabel.text = User.sharedInstance.name
        self.emailLabel.text = User.sharedInstance.email
    }
    
    //MARK: - Methods
    func cleanNavigationBar(){
        //self.navigationController!.navigationBar.shadowImage = UIImage()
        //self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.removeShadow()
    }


}
