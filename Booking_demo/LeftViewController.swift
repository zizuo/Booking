import UIKit

public class LeftViewController: UITableViewController{
    
    public var cellLabels = ["Найти", "Войти или создать аккаунт", "Бронирования", "Просмотренные", "Ваши путеводители", "Списки", "История поиска", "Настройки", "Call centr", "Информация"]
    public var cellImages = ["search.png", "account.png", "case.png", "seen.png", "helper.png", "favor.png", "search.png", "settings.png", "call.png", "info.png"]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarLogo()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if User.sharedInstance.isLoggedIn {
            self.cellLabels[1] = User.sharedInstance.name
        }else{
            self.cellLabels[1] = "Войти или создать аккаунт"
        }
        
        self.tableView.reloadData()
    }


    
    // MARK: Table view data sources
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(hexString: "0896FF")
        cell.selectedBackgroundView = backgroundView
        
        cell.textLabel?.text = cellLabels[indexPath.row]
        cell.imageView?.image = UIImage(named: cellImages[indexPath.row])
        
        return cell
    }

    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc = UIViewController()
        
        switch(indexPath.row){
        case 0:
            vc = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as!MainViewController
        case 1:
            vc = storyboard.instantiateViewControllerWithIdentifier("AccountViewController") as! AccountViewController
        case 2:
            vc = storyboard.instantiateViewControllerWithIdentifier("BookingViewController") as! BookingViewController
        case 3:
            vc = storyboard.instantiateViewControllerWithIdentifier("SeenViewController") as! SeenViewController
        case 4:
            vc = storyboard.instantiateViewControllerWithIdentifier("GuideViewCotroller") as! GuideViewCotroller
        case 5:
            vc = storyboard.instantiateViewControllerWithIdentifier("ListsViewController") as! ListsViewController
        case 6:
            vc = storyboard.instantiateViewControllerWithIdentifier("SearchHistoryViewController") as! SearchHistoryViewController
        case 7:
            vc = storyboard.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
        case 8:
            vc = storyboard.instantiateViewControllerWithIdentifier("ContactUsViewController") as! ContactUsViewController
        case 9:
            vc = storyboard.instantiateViewControllerWithIdentifier("InformationViewController") as! InformationViewController
        default: break
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    public override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        
        return footerView
    }
}