import UIKit
import CVCalendarKit
import SwiftyJSON
import SKPhotoBrowser

class SingleHotelViewController: UITableViewController, SKPhotoBrowserDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var endDayButton: UIButton!
    @IBOutlet weak var startDayButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    
    @IBOutlet weak var startDayLabel: UILabel!
    @IBOutlet weak var endDayLabel: UILabel!
    @IBOutlet weak var startWeekNameLabel: UILabel!
    @IBOutlet weak var endWeekNameLabel: UILabel!
    @IBOutlet weak var startMonthLabel: UILabel!
    @IBOutlet weak var endMonthLabel: UILabel!
    

    @IBOutlet weak var descr: UITextView!
    @IBOutlet weak var hotelRoomDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var itemJSON : JSON!
    var hotelId : Int!
    var hotel : Hotel?
    var images = [SKPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupButtonsOPtions()
        setDates()
        setupCollectioniew()
    }


    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("!!!!!!!\(indexPath.row)")
    }
    
    // MARK: - Methods ------------------------------------
    // Set dates
    func setDates(){
        let formatterWeek = NSDateFormatter()
        let formatterMonth = NSDateFormatter()
        formatterWeek.dateFormat = "E"
        formatterMonth.dateFormat = "MMM"
        let dayIn = User.sharedInstance.dateIn.day.value()
        let dayOut = User.sharedInstance.dateOut.day.value()
        let monthIn = formatterMonth.stringFromDate(User.sharedInstance.dateIn)
        let monthOut = formatterMonth.stringFromDate(User.sharedInstance.dateOut)
        
        self.startDayLabel.text = "\(dayIn)"
        self.endDayLabel.text = "\(dayOut)"
        
        self.startWeekNameLabel.text = formatterWeek.stringFromDate(User.sharedInstance.dateIn)
        self.endWeekNameLabel.text = formatterWeek.stringFromDate(User.sharedInstance.dateOut)
        
        self.startMonthLabel.text = monthIn
        self.endMonthLabel.text = monthOut
        
        // Assuming that firstDate and secondDate are defined
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDayForDate(User.sharedInstance.dateIn)
        let date2 = calendar.startOfDayForDate(User.sharedInstance.dateOut)

        switch daysBetweenDate(date1, endDate: date2) {
        case 1:
            self.hotelRoomDateLabel.text = "Цена за \(daysBetweenDate(date1, endDate: date2)) ночь (\(dayIn) \(monthIn) - \(dayOut) \(monthOut))"
        case (2...4):
            self.hotelRoomDateLabel.text = "Цена за \(daysBetweenDate(date1, endDate: date2)) ночи (\(dayIn) \(monthIn) - \(dayOut) \(monthOut))"
        default:
            self.hotelRoomDateLabel.text = "Цена за \(daysBetweenDate(date1, endDate: date2)) ночей (\(dayIn) \(monthIn) - \(dayOut) \(monthOut))"
            break
        }
    }
    
    func daysBetweenDate(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        
        return components.day
    }
    
    // Set button options
    func setupButtonsOPtions() {
        self.setNavigationTitle("Отель")
        self.bookButton.layer.cornerRadius = 3
        self.startDayButton.layer.borderColor = UIColor.blackColor().CGColor
        self.startDayButton.layer.borderWidth = 0.3
        
        self.endDayButton.layer.borderColor = UIColor.blackColor().CGColor
        self.endDayButton.layer.borderWidth = 0.3
    }
    
    //Set CollectionView
    func setupCollectioniew() {
        self.collectionView.dataSource = self
    }
    
    // Parse json
    func getHotelById(hotelId: Int){
        let params: Dictionary<String, AnyObject> = [LANG: "ru", "id" : hotelId, "_id" : User.sharedInstance.id]
        
        let request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        
        request.POST("\(API_IP)hotel/gethotelbyid", parameters: params, success: {(response : HTTPResponse) in
            
            if let data = response.responseObject as? NSData {
                let json = JSON(data : data)
                let dataJSON = json["data"]
                self.itemJSON = dataJSON
                self.hotel = Hotel(hotelJSON: dataJSON)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadDetails()
                    
                    self.setupCollectioniew()
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(CGPointZero, animated: true)
                    
                })
                
            }
            
            }, failure: {(error : NSError, response : HTTPResponse?) in
                print("error: \(error)")
        })

    }

    func loadDetails() {
        if let imagesArray = hotel?.img.arrayValue{
        for i in 0..<(imagesArray.count){
            let url : NSURL = NSURL(string: imagesArray[i].stringValue)!
            let data : NSData = NSData(contentsOfURL: url)!
            let photo = SKPhoto.photoWithImage(UIImage(data: data)!)
            images.append(photo)
            }
            
        self.titleLabel.text = self.hotel?.title
        self.addressLabel.text = self.hotel?.address
        self.ratingLabel.text = "Рейтинг:  \(self.hotel!.rating)"
        self.descr.text = self.hotel?.descr
    }
 }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("exampleCollectionViewCell", forIndexPath: indexPath) as? ExampleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.exampleImageV.image = images[indexPath.row].underlyingImage
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("??????????")
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ExampleCollectionViewCell else {
            return
        }
        guard let originImage = cell.exampleImageV.image else {
            return
        }
        let browser = SKPhotoBrowser(originImage: originImage, photos: images, animatedFromView: cell)
        browser.initializePageIndex(indexPath.row)
        browser.delegate = self
        browser.displayDeleteButton = true
        browser.statusBarStyle = .LightContent
        browser.bounceAnimation = true
        
        // Can hide the action button by setting to false
        browser.displayAction = true
        presentViewController(browser, animated: true, completion: {})
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return CGSize(width: 80, height: 80)
        } else {
            return CGSize(width: 80, height: 80)
        }
    }
    
    // MARK: - SKPhotoBrowserDelegate
    func didShowPhotoAtIndex(index: Int) {
        collectionView.visibleCells().forEach({$0.hidden = false})
        collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))?.hidden = true
    }
    
    func willDismissAtPageIndex(index: Int) {
        collectionView.visibleCells().forEach({$0.hidden = false})
        collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))?.hidden = true
    }
    
    func willShowActionSheet(photoIndex: Int) {
    }
    
    func didDismissAtPageIndex(index: Int) {
        collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))?.hidden = false
    }
    
    func didDismissActionSheetWithButtonIndex(buttonIndex: Int, photoIndex: Int) {
    }
    
    func removePhoto(browser: SKPhotoBrowser, index: Int, reload: (() -> Void)) {
        reload()
    }
    
    func viewForPhoto(browser: SKPhotoBrowser, index: Int) -> UIView? {
        
        return collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))
    }
}




class ExampleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var exampleImageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        exampleImageV.image = nil
    }
    
    override func prepareForReuse() {
        exampleImageV.image = nil
    }
}