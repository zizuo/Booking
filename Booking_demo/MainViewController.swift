import UIKit
import Popover
import CVCalendarKit
import SideMenu
import CoreLocation
import TTRangeSlider

class MainViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - variables ---------------------
    @IBOutlet weak var rangeSlider: TTRangeSlider!
    @IBOutlet weak var rating: FloatRatingView!
    
    @IBOutlet weak var nearMeHotels: UIButton!
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var numberButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var beginDatеButton: UIButton!
    @IBOutlet weak var searchFind: UIButton!
    @IBOutlet weak var findButton: UIButton!
    
    var locationManager: CLLocationManager?
    var lat : Double!
    var lng : Double!
    
    var mysubView:AlertPopupNew!
    
    private var texts = ["Валюта"]
    private var popover: Popover!
    private var popoverOptions: [PopoverOption] = [
        .Type(.Down),
        .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]


    // MARK:- view main ------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        setButtonOptions()

        //Get location
        updateLocation()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setDate()
        
        //SideMenu Customization
        SideMenuManager.menuWidth = max(round(min(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height) * 0.75), 260)
        
        if User.sharedInstance.geo != "" {
            self.searchTextField.text = User.sharedInstance.geo
        }
        
        // Status bar white font and tintColor
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#003580")
        self.setNavigationBarLogo()
        
        // Additional bar button items
        let alertButton = UIBarButtonItem(image: UIImage(named: "alert.png"), style: .Plain, target: self, action: #selector(MainViewController.methodAlert))
        
        alertButton.tintColor = UIColor.whiteColor()
        
        let optionButton = UIBarButtonItem(image: UIImage(named: "option.png"), style: .Plain, target: self, action: #selector(MainViewController.methodOption))
        optionButton.tintColor = UIColor.whiteColor()
        
        navigationItem.setRightBarButtonItems([alertButton], animated: true)
        
    }

    
    //MARK:- Actions ---------------------
    //Near me hotels
    @IBAction func nearMeHotels(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HotelCollectionViewController") as! HotelCollectionViewController
        vc.lat = self.lat
        vc.lng = self.lng
        vc.callNearHotel()
        vc.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.pushViewController(vc, animated: true)
        print("clicked nearMeHotels...")
    }
    //Search bar
    @IBAction func nearButton(sender: AnyObject) {
        print("clicked...")
    }
    
    //Registration date
    @IBAction func dateButton(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("DatePickerViewController") as! DatePickerViewController
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    //Room, adult and child
    @IBAction func roomAdultChildButton(sender: AnyObject) {
        
        print("roomAdultChild clicked......")
    }
    
    //Find the hotels
    @IBAction func findButton(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HotelCollectionViewController") as! HotelCollectionViewController
        User.sharedInstance.rating = Int(self.rating.rating)
        User.sharedInstance.price = Int(self.rangeSlider.selectedMaximum)
        User.sharedInstance.geo = searchTextField.text!
        vc.getHotels()
        print("\(self.rating.rating).......\(self.rangeSlider.selectedMaximum)<><><><><>")
        vc.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.pushViewController(vc, animated: true)
        print("findButton clicked........")
    }
    
    //Trip purpose: business or travel
    @IBAction func tripPurpose(isRadioButton: ISRadioButton) {
        if isRadioButton.multipleSelectionEnabled{
            for radioButton in isRadioButton.otherButtons! {
                print("\(radioButton.titleLabel?.text) is selected.\n");
            }
        }else{
            print("%@ is selected.\n", isRadioButton.titleLabel?.text);
        }
    }
    
    
    //MARK:- Methods ---------------------f
    
    func setButtonOptions() {
        findButton.layer.cornerRadius = 3
        typeButton.layer.cornerRadius = 3
        numberButton.layer.cornerRadius = 3
        endDateButton.layer.cornerRadius = 3
        beginDatеButton.layer.cornerRadius = 3
        searchFind.layer.cornerRadius = 3
        nearMeHotels.layer.cornerRadius = 3
    }
    
    func setDate() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E - dd MMM"

        self.beginDateLabel.text = "\(formatter.stringFromDate(User.sharedInstance.dateIn))"
        self.endDateLabel.text = "\(formatter.stringFromDate(User.sharedInstance.dateOut))"
        
    }

    
    func updateLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        //self.locationManager.distanceFilter = 10
        self.locationManager!.requestWhenInUseAuthorization()
        self.locationManager!.startUpdatingLocation()
        //self.locationManager?.stopUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        self.lng = location.coordinate.longitude
        self.lat = location.coordinate.latitude
        
        print("didUpdateLocations:  \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
    }
    
    
    func methodAlert() {
        let startPoint = CGPoint(x: self.view.frame.width - 28, y: 55) // old x: -82
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width))
        mysubView = AlertPopupNew(frame : CGRect(x: 10, y: 10, width: self.view.frame.width - 50, height: self.view.frame.height - 90))
        
        
        mysubView.logInButton?.layer.cornerRadius = 3
        mysubView.createAccountButton?.layer.cornerRadius = 3
        mysubView.createAccountButton?.layer.borderWidth = 1
        mysubView.createAccountButton?.layer.borderColor = UIColor(hexString: "#3399FF").CGColor
        
        aView.addSubview(mysubView)
        let popover = Popover()
        popover.show(aView, point: startPoint)
        print("methodAlert")
    }
    
    // function option button
    func methodOption() {
        let startPoint = CGPoint(x: self.view.frame.width - 30, y: 55)
        //let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 2.5 , height: 80))
        let options = [
            .Type(.Down),
            .ArrowSize(CGSizeZero)
            ] as [PopoverOption]

        //let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        //popover.show(aView, point: startPoint)
        
        //////
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        self.popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        self.popover.show(tableView, point: startPoint)
        
        print("methodOption")
    }
}


    //MARK: - Extensions ------------------------
    extension MainViewController : UITableViewDelegate {
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            print("valyuta selected")
            self.popover.dismiss()
        }
    }
    
    extension MainViewController : UITableViewDataSource {
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return 1
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell.textLabel?.text = self.texts[indexPath.row]
            return cell
        }

    }
