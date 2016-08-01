import UIKit
import CXTabView
import CXDurationPicker
import CVCalendarKit

class DatePickerViewController: UIViewController, CXTabViewDelegate, CXDurationPickerViewDelegate {

    //MARK: - Outlets --------------------------------------------
    @IBOutlet weak var tabView: CXTabView!
    @IBOutlet weak var picker: CXDurationPickerView!
    @IBOutlet weak var selectedDays: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set picker delegate options
        self.setPicker()
        //Sync components
        self.synchronizeComponents()

    }
    
    //MARK: - tabView delegate --------------------------------------------
    func tabView(tabView: CXTabView, didSelectMode mode: CXTabViewMode) {
        switch mode {
        case CXTabViewMode.Start:
            NSLog("Selected start mode")
            self.picker.mode = CXDurationPickerMode.StartDate
        case CXTabViewMode.End:
            NSLog("Selected end mode")
            self.picker.mode = CXDurationPickerMode.EndDate
        }
        
    }
    
    //MARK: - CXDurationPickerViewDelegate --------------------------------------------
    func durationPicker(durationPicker: CXDurationPickerView, endDateChanged pickerDate: CXDurationPickerDate) {
        self.tabView.durationEndString = CXDurationPickerUtils.stringFromPickerDate(pickerDate)
        User.sharedInstance.dateOut = CXDurationPickerUtils.dateFromPickerDate(pickerDate)
    }
    
    
    func durationPicker(durationPicker: CXDurationPickerView, startDateChanged pickerDate: CXDurationPickerDate) {
        self.tabView.durationStartString = CXDurationPickerUtils.stringFromPickerDate(pickerDate)
        User.sharedInstance.dateIn = CXDurationPickerUtils.dateFromPickerDate(pickerDate)
    }
    
    //MARK: - CXDurationPickerViewDelegate Optionals --------------------------------------------
    func durationPicker(durationPicker: CXDurationPickerView!, invalidStartDateSelected date: CXDurationPickerDate) {
        NSLog("Invalid end date selected.")
    }
    
    //MARK: - Methods --------------------------------------------

    func synchronizeComponents() {
        self.synchronizeRange()
        
    }

    func synchronizeRange() {
        let startDate: CXDurationPickerDate = self.picker.startDate
        self.tabView.durationStartString = CXDurationPickerUtils.stringFromPickerDate(startDate)
        let endDate: CXDurationPickerDate = self.picker.endDate
        self.tabView.durationEndString = CXDurationPickerUtils.stringFromPickerDate(endDate)
    }
    
    func setPicker() {
        self.tabView.delegate = self
        self.picker.delegate = self
        self.picker.gridColor = UIColor.clearColor()
        self.picker.disabledDayBackgroundColor = UIColor.clearColor()
        self.picker.disabledDayForegroundColor = UIColor(hexString: "#CCCCCC")
        self.picker.dayForegroundColor = UIColor(hexString: "#003580")
        self.picker.todayBackgroundColor = UIColor.clearColor()
        self.picker.todayForegroundColor = UIColor(hexString: "#3399FF")
        //self.picker.transitBackgroundColor = UIColor(hexString: "#3399FF")
        
        self.picker.mode = CXDurationPickerMode.StartDate
        self.picker.allowSelectionsInPast = false
        
        var startPickerDate = CXDurationPickerDate()
        startPickerDate.day = UInt(User.sharedInstance.dateIn.day.value())
        startPickerDate.month = UInt(User.sharedInstance.dateIn.month.value())
        startPickerDate.year = UInt(User.sharedInstance.dateIn.year.value())
        
        var endPickerDate = CXDurationPickerDate()
        endPickerDate.day = UInt(User.sharedInstance.dateOut.day.value())
        endPickerDate.month = UInt(User.sharedInstance.dateOut.month.value())
        endPickerDate.year = UInt(User.sharedInstance.dateOut.year.value())
        
        self.picker.startDate = startPickerDate
        self.picker.endDate = endPickerDate
    }
    
    @IBAction func onTouchDissmis(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
}
