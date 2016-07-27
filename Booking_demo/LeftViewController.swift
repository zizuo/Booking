//
//  LeftViewController.swift
//  Booking_demo
//
//  Created by Ulukbek Saiipov on 2/11/16.
//  Copyright © 2016 Yaros. All rights reserved.
//

import UIKit

// comment for git commit test
// comment for branch test
public class LeftViewController: UITableViewController{
    
    public var cellLabels = ["Найти", "Войти или создать аккаунт", "Бронирования", "Просмотренные", "Ваши путеводители", "Списки", "История поиска", "Настройки", "Salman", "Iskender"]
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
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        print("\(cell!.textLabel?.text) selected>>>")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch(indexPath.row){
        case 0:
            print("case 0 working")
            let find = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as!MainViewController
            self.navigationController?.pushViewController(find, animated: true)
        case 1:
            let account = storyboard.instantiateViewControllerWithIdentifier("AccountViewController") as! AccountViewController
            self.navigationController?.pushViewController(account, animated: true)
        case 2:
            let booking = storyboard.instantiateViewControllerWithIdentifier("BookingViewController") as! BookingViewController
            self.navigationController?.pushViewController(booking, animated: true)
        case 3:
            let seen = storyboard.instantiateViewControllerWithIdentifier("SeenViewController") as! SeenViewController
            self.navigationController?.pushViewController(seen, animated: true)
        case 4:
            let feedBack = storyboard.instantiateViewControllerWithIdentifier("GuideViewCotroller") as! GuideViewCotroller
            self.navigationController?.pushViewController(feedBack, animated: true)
        case 5:
            let lists = storyboard.instantiateViewControllerWithIdentifier("ListsViewController") as! ListsViewController
            self.navigationController?.pushViewController(lists, animated: true)
        case 6:
            let searchHistory = storyboard.instantiateViewControllerWithIdentifier("SearchHistoryViewController") as! SearchHistoryViewController
            self.navigationController?.pushViewController(searchHistory, animated: true)
        case 7:
            let settings = storyboard.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
            self.navigationController?.pushViewController(settings, animated: true)
        case 8:
            let contactUs = storyboard.instantiateViewControllerWithIdentifier("ContactUsViewController") as! ContactUsViewController
            self.navigationController?.pushViewController(contactUs, animated: true)
        case 9:
            let information = storyboard.instantiateViewControllerWithIdentifier("InformationViewController") as! InformationViewController
            self.navigationController?.pushViewController(information, animated: true)
        default:
            print("default")
        }
    }
    
    
    public override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        
        return footerView
    }
}