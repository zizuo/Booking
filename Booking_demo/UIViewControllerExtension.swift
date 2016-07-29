import UIKit
import BBBadgeBarButtonItem

extension UINavigationBar {
    
    func removeShadow() {
        if let view = removeShadowFromView(self) {
            view.removeFromSuperview()
            print("Removed Shadow: \(view)")
        }
    }
    func removeShadowFromView(view: UIView) -> UIImageView? {
        if (view.isKindOfClass(UIImageView) && view.bounds.size.height <= 1) {
            print("Found Shadow")
            return view as? UIImageView
        }
        for subView in view.subviews {
            if let imageView = removeShadowFromView(subView as UIView) {
                return imageView
            }
        }
        return nil
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

public class buttons{
    var button : UIButton = UIButton(type: UIButtonType.System) as UIButton
    var button2 : UIButton = UIButton(type: UIButtonType.System) as UIButton
}

public class appButton : UIButton{
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 3
        self.tintColor = UIColor.whiteColor()
        self.backgroundColor = UIColor(hexString: "#0896FF")
    }
}

extension String {
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
}

extension UIViewController {

    // Setting Navigation Bar Logo
    func setNavigationBarLogo() {
        //let logo = UIImage(named: "booking_logo.png")
        //let imageView = UIImageView(image:logo)
        //self.navigationItem.titleView = imageView
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "booking_logo.png")
        imageView.image = image
        self.navigationItem.titleView?.center
        self.navigationItem.titleView = imageView
    }
    
    // Setting Navigation Back Bar button
    func setBackBarButton(){
        self.navigationItem.backBarButtonItem?.image = UIImage(named: "back_button")
    }
    
    // Setting Navigation Bar Title Name
    func setNavigationTitle(name: String){
        self.navigationItem.title = name
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    // Setting Navigation Bar alert
    func setNavigationBarAlert() {
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, 0, 30, 40)
        
        //let customButton = UIButton(0, 0, 30, 40)
        button.setImage(UIImage(named: "alert.png"), forState: .Normal)
        button.tintColor = UIColor.whiteColor()
        //button.addTarget(self, action: Selector("cleanCart"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = BBBadgeBarButtonItem(customUIButton: button)
        buttons().button2 = button
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    // Setting Navigation Bar Option Button
    func setNavigationBarOptionButton() {
        let buttonOption = UIButton(type: UIButtonType.System) as UIButton
        buttonOption.frame = CGRectMake(0, 0, 30, 40)
        buttonOption.setImage(UIImage(named: "option.png"), forState: .Normal)
        buttonOption.tintColor = UIColor.whiteColor()
        let barOptionButton = BBBadgeBarButtonItem(customUIButton: buttonOption)
        buttons().button = buttonOption
        self.navigationItem.rightBarButtonItem = barOptionButton
    }
}