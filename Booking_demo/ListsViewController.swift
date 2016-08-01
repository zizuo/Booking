import UIKit
import SideMenu

class ListsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar white font and tintColor
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#003580")
        // Change the color of the navigation bar title text to blue.
        self.setNavigationTitle("Списки")
    }
    
    @IBAction func sideMenu(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("sideMenu") as! UISideMenuNavigationController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
