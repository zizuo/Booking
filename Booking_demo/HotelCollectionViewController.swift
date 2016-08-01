import UIKit
import SwiftyJSON
import Kingfisher


class HotelCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var totalEntries: Int = 0
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var currencyButton: UIButton!
    
    var itemJSON : JSON!
    var images : JSON!
    var listCellWidth: CGFloat!
    var listCellHeight: CGFloat!
    
    var productSort = ""
    var productOrder = ""
    var lat : Double!
    var lng : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOptions()
        recalculateCellWidthAndHeight()
        
        productOrder = "ASC"
        productSort = "sort_order"
        


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    //MARK: - JSON Parse --------------------------------------
    //gets last hotels
    func getHotels(){
        let params: Dictionary<String, AnyObject> = ["_id" : User.sharedInstance.id, LANG: "ru", "geo" : User.sharedInstance.geo, "from" : "\(User.sharedInstance.dateIn.year.value())-\(User.sharedInstance.dateIn.month.value())-\(User.sharedInstance.dateIn.day.value())", "to" : "\(User.sharedInstance.dateOut.year.value())-\(User.sharedInstance.dateOut.month.value())-\(User.sharedInstance.dateOut.day.value())", "price" : User.sharedInstance.price, "rating" : User.sharedInstance.rating, "sort" : User.sharedInstance.sort, "limit" : 100]
        
        let request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        
        request.POST("\(API_IP)hotel/filter", parameters: params, success: {(response : HTTPResponse) in
            
            if let data = response.responseObject as? NSData {
                let json = JSON(data : data)
                let dataJSON = json["data"]
                self.itemJSON = dataJSON
                self.images = dataJSON["img"]

                
                dispatch_async(dispatch_get_main_queue(), {
                    self.setNavigationTitle("\(self.itemJSON.count) отелей")
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(CGPointZero, animated: true)
                    
                })
                
            }
            
            }, failure: {(error : NSError, response : HTTPResponse?) in
                dispatch_async(dispatch_get_main_queue(), {

                })
                
        })
    }
    // calls nearMe api
    func getNearHotels() {
        let params: Dictionary<String, AnyObject> = [LANG: "ru", "lat" : self.lat, "lng" : self.lng]
        
        let request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        
        request.POST("\(API_IP)hotel/getnearhotels", parameters: params, success: {(response : HTTPResponse) in
            
            if let data = response.responseObject as? NSData {
                let json = JSON(data : data)
                let dataJSON = json["data"]
                self.itemJSON = dataJSON
                self.images = dataJSON["img"]
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.setNavigationTitle("\(dataJSON.count) отелей")

                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(CGPointZero, animated: true)
                })
                
            }
            
            }, failure: {(error : NSError, response : HTTPResponse?) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                })
                
        })
    }
    
    //MARK: - CollectionView DataSources --------------------------------------
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let items = itemJSON {
            if items.count == 0 {
            }
            return items.count
        } else {
            return 0
        }
            }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        return listCell(indexPath)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return CGSize(width: listCellWidth, height: listCellHeight)
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: HotelCollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! HotelCollectionViewCell
        
            pushChildViewController(cell.productId!, img: cell.img!)
        
    }
    
    

    
    //MARK: - Methods --------------------------------------
    //Get near hotels
    func callNearHotel() {
        getNearHotels()
    }
    
    //List cell view
    func listCell(indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let nibAndIdName = "HotelCollectionViewCell"
        
        let nibName = UINib(nibName: nibAndIdName, bundle: nil)
        collectionView.registerNib(nibName, forCellWithReuseIdentifier: nibAndIdName)
        
        let cell: HotelCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("HotelCollectionViewCell", forIndexPath: indexPath) as! HotelCollectionViewCell
        
        
        if let newJSON: JSON = itemJSON?[indexPath.row] {
            let product_id = newJSON["_id"].intValue
            
            cell.productId = product_id
            cell.img = newJSON["img"]
            cell.labelPrice.text = newJSON["price"].stringValue + SOM
            if let km = newJSON["kilometr"].string{
                cell.kilomtrLabel.text = "\(km) \(KM)"
            }else{
                cell.kilomtrLabel.backgroundColor = UIColor.clearColor()
            }
            cell.labelRating.text = "Рейтинг: \(newJSON["rating"].stringValue)"
            
            cell.labelHotelName.text = newJSON["title"].stringValue
            
            let thumb1_path = newJSON["img"][0].stringValue
            if let url = NSURL(string: thumb1_path){
                cell.thumbImage.kf_setImageWithURL(url)
            }
            
            
            //cell.labelPrice.text = "135 $"//newJSON["price_piece"].stringValue + " TRY"
            
            
        }
        
        cell.updateLayerProperties()
        
        return cell
        
    }
    
    func setOptions() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        self.sortButton.layer.cornerRadius = 3
        self.filterButton.layer.cornerRadius = 3
        self.currencyButton.layer.cornerRadius = 3
    }
    
    func recalculateCellWidthAndHeight() {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            
            listCellWidth = (UIScreen.mainScreen().bounds.width) - 100
            listCellHeight = (UIScreen.mainScreen().bounds.height / 4) - 20
            
        } else {
            
            listCellWidth = (UIScreen.mainScreen().bounds.width) - 10
            listCellHeight = (UIScreen.mainScreen().bounds.height / 2) - 60
            
        }
        
    }
    
    func pushChildViewController(productId: Int, img : JSON) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SingleHotelViewController") as! SingleHotelViewController

        vc.getHotelById(productId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Actions --------------------------------------
    // Sorting type
    @IBAction func onTouchSortHotels(sender: AnyObject) {
        let pickerView = CustomPickerDialog.init()
        
        let arrayDataSource = ["Популярность", "Недавно просмотренные", "Растояние", "Оценка гостей", "Цене, по возрастанию", "Названия А-Я"]
        
        pickerView.setDataSource(arrayDataSource)
        
        pickerView.showDialog("Сортировать:", doneButtonTitle: "Готово", cancelButtonTitle: "Отмена") { (result) -> Void in
            switch result {
                case "Популярность":
                    User.sharedInstance.sort = 1
                case "Недавно просмотренные":
                    User.sharedInstance.sort = 2
                case "Растояние":
                    User.sharedInstance.sort = 3
                case "Оценка гостей":
                    User.sharedInstance.sort = 4
                case "Цене, по возрастанию":
                    User.sharedInstance.sort = 5
                case "Названия А-Я":
                    User.sharedInstance.sort = 6

                default: break

            }
        }
        pickerView.selectRow(User.sharedInstance.sort-1)
    }
    
    // MARK: Button Event
    func clickButton(sender: UIButton!) {
 
        self.getHotels()
 
    }

}
