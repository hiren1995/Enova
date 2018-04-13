//
//  FastingView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 28/03/18.
//  Copyright © 2018 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Foundation

//import StretchHeader
//import SRCountdownTimer

class FastingView: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextViewDelegate {

    
    var tableView : UITableView!
    
    @IBOutlet weak var ViewCancel: UIView!
    @IBOutlet weak var ViewAlpha: UIView!
    
    @IBOutlet weak var txtCancelReason: UITextView!
    
    var currentDate = Date()
    let formatter = DateFormatter()
    var to_date = String()
    
    //print(result+"23:59:59")
    
    let subtractDays = -7
    var dateComponent = DateComponents()
   
    var temp = Date()
    var from_date = String()
    
    var tempTxtFrom = UITextField()
    var tempTxtTo = UITextField()
    var tempTimer = UILabel()
    
    var tempDict = JSON()
    
    
    var countdownTimer: Timer!
    
    var totalTime = Int()
    
    var refreshControl = UIRefreshControl()
    
    private var AppForegroundNotification: NSObjectProtocol?
    private var AppBackgroundNotification: NSObjectProtocol?
    
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.dateFormat = "yyyy-MM-dd"
        to_date = formatter.string(from: currentDate)
        dateComponent.day = subtractDays
        temp = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        from_date = formatter.string(from: temp)
        
        
        tableView = UITableView(frame: CGRect(x: 10, y: 80, width: view.bounds.width - 20, height: view.bounds.height - 100), style: .plain)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        ViewCancel.isHidden = true
        ViewAlpha.isHidden = true
        
        //loadFastLog(From_Date : from_date , To_Date : to_date)
        loadFastLog(From_Date : "" , To_Date : "")
        
        txtCancelReason.delegate = self
        txtCancelReason.layer.borderColor = UIColor.lightGray.cgColor
        txtCancelReason.layer.borderWidth = 1
        txtCancelReason.clipsToBounds = true
        txtCancelReason.layer.cornerRadius = 5
        
        addDoneButtonOnTextView()
        addDoneButtonOnDatePicker()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
        AppForegroundNotification = NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: .main) {
            [unowned self] notification in
            
            self.ResumeApp()
        }
        
        AppBackgroundNotification = NotificationCenter.default.addObserver(forName: .UIApplicationDidEnterBackground, object: nil, queue: .main) {
            [unowned self] notification in
            
            self.PauseApp()
        }
        
        startAutoRefreshTimer()
        
        // Do any additional setup after loading the view.
    }
   
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        
        if let appforegroundnotification = AppForegroundNotification {
            NotificationCenter.default.removeObserver(appforegroundnotification)
        }
        if let appbackgroundnotification = AppBackgroundNotification{
            
            NotificationCenter.default.removeObserver(appbackgroundnotification)
        }
        
        stopAutoRefreshTimer()
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //return 20
        
       return  self.tempDict["data"].count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //var cell = UITableViewCell()
        
        if(indexPath.row == 0)
        {
             let cell = Bundle.main.loadNibNamed("FastingTableFirstIndexTableCell", owner: self, options: nil)?.first as! FastingTableFirstIndexTableCell
            
             cell.btnAdd.addTarget(self, action: #selector(openAddFast), for: .touchUpInside)
            
             return cell
            
        }
        else if(indexPath.row == 1)
        {
            
            let cell = Bundle.main.loadNibNamed("FastingTableCountDownTimerTableCell", owner: self, options: nil)?.first as! FastingTableCountDownTimerTableCell
            
            if(self.tempDict["current_fasting"].count != 0)
            {
                cell.lblStartDate.text = self.tempDict["current_fasting"][0]["date"].stringValue
                cell.lblEndDate.text = self.tempDict["current_fasting"][0]["end_date"].stringValue
                cell.lblStartTime.text = self.tempDict["current_fasting"][0]["from_time"].stringValue
                cell.lblEndTime.text = self.tempDict["current_fasting"][0]["to_time"].stringValue
                
                cell.btnCancel.addTarget(self, action: #selector(StopFast), for: .touchUpInside)
                
                tempTimer = cell.lblTimer
                
            }
            
            return cell
            
        }
        else if(indexPath.row == 2)
        {
            let cell = Bundle.main.loadNibNamed("SelectDatesTableCell", owner: self, options: nil)?.first as! SelectDatesTableCell
            
            cell.txtTo.text = to_date
            cell.txtFrom.text = from_date
            
            
            cell.txtFrom.addTarget(self, action: #selector(txtFromEditBegin(sender:)), for: .editingDidBegin)
            cell.txtTo.addTarget(self, action: #selector(txtToEditBegin(sender:)), for: .editingDidBegin)
            
            
            
            var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            
            var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelPicker))
            
            var items = NSMutableArray()
            items.add(flexSpace)
            items.add(done)
            
            doneToolbar.items = items as! [UIBarButtonItem]
            doneToolbar.sizeToFit()
            
            cell.txtFrom.inputAccessoryView = doneToolbar
            cell.txtTo.inputAccessoryView = doneToolbar
 
            tempTxtTo = cell.txtTo
            tempTxtFrom = cell.txtFrom
 
            return cell
        }
        else
        {
            if(indexPath.row % 2 != 0)
            {
               let cell = Bundle.main.loadNibNamed("FastingTableCell", owner: self, options: nil)?.first as! FastingTableCell
                
                cell.lblStartDate.text = self.tempDict["data"][indexPath.row - 3]["date"].stringValue
                cell.lblStartTime.text = self.tempDict["data"][indexPath.row - 3]["from_time"].stringValue
                cell.lblEndDate.text = self.tempDict["data"][indexPath.row - 3]["end_date"].stringValue
                cell.lblEndTime.text = self.tempDict["data"][indexPath.row - 3]["to_time"].stringValue
                
               
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                
                let x = dateFormatter.date(from: self.tempDict["data"][indexPath.row - 3]["date"].stringValue + " " + self.tempDict["data"][indexPath.row - 3]["from_time"].stringValue)
                let y = dateFormatter.date(from: self.tempDict["data"][indexPath.row - 3]["end_date"].stringValue + " " + self.tempDict["data"][indexPath.row - 3]["to_time"].stringValue)
                
                print("x= \(x)")
                print("y= \(y)")
                
                if(x != nil && y != nil)
                {
                    let z = try Int((y?.timeIntervalSince1970)! - (x?.timeIntervalSince1970)!)
                    print("difference \(z)")
                    
                    let minutes: Int = (z / 60) % 60
                    let hours: Int = z / 3600
                    
                    print("minutes \(minutes)")
                    print("hours \(hours)")
                    
                    cell.lblTotalFastTime.text = "\(hours)hr " + "\(minutes)min "
                }
               
               return cell
            }
            else
            {
               let cell = Bundle.main.loadNibNamed("FastingTableCell", owner: self, options: nil)?.first as! FastingTableCell
                //cell.tablecellView.layer.backgroundColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1.0)
                
                cell.backgroundColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1.0)
                
                cell.lblStartDate.text = self.tempDict["data"][indexPath.row - 3]["date"].stringValue
                cell.lblStartTime.text = self.tempDict["data"][indexPath.row - 3]["from_time"].stringValue
                cell.lblEndDate.text = self.tempDict["data"][indexPath.row - 3]["end_date"].stringValue
                cell.lblEndTime.text = self.tempDict["data"][indexPath.row - 3]["to_time"].stringValue
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                
                let x = dateFormatter.date(from: self.tempDict["data"][indexPath.row - 3]["date"].stringValue + " " + self.tempDict["data"][indexPath.row - 3]["from_time"].stringValue)
                let y = dateFormatter.date(from: self.tempDict["data"][indexPath.row - 3]["end_date"].stringValue + " " + self.tempDict["data"][indexPath.row - 3]["to_time"].stringValue)
                
                print("x= \(x)")
                print("y= \(y)")
                
                if(x != nil && y != nil)
                {
                    let z = try Int((y?.timeIntervalSince1970)! - (x?.timeIntervalSince1970)!)
                    print("difference \(z)")
                    
                    let minutes: Int = (z / 60) % 60
                    let hours: Int = z / 3600
                    
                    print("minutes \(minutes)")
                    print("hours \(hours)")
                    
                    cell.lblTotalFastTime.text = "\(hours)hr " + "\(minutes)min "
                }
                
                return cell
                
            }
        }
        
        //return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if(indexPath.row == 0)
        {
            return 60
        }
        else if(indexPath.row == 1)
        {
            
            if(self.tempDict["current_fasting"].count == 0)
            {
                return 0
            }
           
            else
            {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                
                let x = dateFormatter.date(from: self.tempDict["current_fasting"][0]["date"].stringValue + " " + self.tempDict["current_fasting"][0]["from_time"].stringValue)
                let y = dateFormatter.date(from: self.tempDict["current_fasting"][0]["end_date"].stringValue + " " + self.tempDict["current_fasting"][0]["to_time"].stringValue)
                
                //print(x)
                //print(y)
                
                print("This seconds from cureent time")
                print(currentDate.timeIntervalSince1970)
                print(x?.timeIntervalSince1970)
                print(y?.timeIntervalSince1970)
            
                totalTime = Int((y?.timeIntervalSince1970)! - currentDate.timeIntervalSince1970)
                
                print(totalTime)
                
                startTimer()
                
                
                if((x?.currentTimeStamp)! > currentDate.currentTimeStamp)
                {
                    return 0
                }
                else if((y?.currentTimeStamp)! < currentDate.currentTimeStamp)
                {
                    return 0
                }
                else
                {
                    return 210
                }
                
                //return 210
                
            }
            
        }
        else if(indexPath.row == 2)
        {
            //return 63
            
            return 0
        }
        else
        {
            return 88
            
        }
    }
    @IBAction func btnBack1(_ sender: UIButton) {
        
        //self.fromLeft()
        //self.dismiss(animated: false, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashBoard = storyboard.instantiateViewController(withIdentifier: "dashBoard") as! DashBoard
        self.fromLeft()
        self.present(dashBoard, animated: false, completion: nil)
    }
    @IBAction func btnBack2(_ sender: UIButton) {
        
        //self.fromLeft()
        //self.dismiss(animated: false, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashBoard = storyboard.instantiateViewController(withIdentifier: "dashBoard") as! DashBoard
        self.fromLeft()
        self.present(dashBoard, animated: false, completion: nil)
        
    }
    
    @objc func openAddFast()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addFastView = storyboard.instantiateViewController(withIdentifier: "addFastView") as! AddFastView
        self.fromRight()
        self.present(addFastView, animated: false, completion: nil)
    }
    
    
    @objc func txtFromEditBegin(sender: UITextField)
    {
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        //tempTxtFrom = sender
        datePickerView.maximumDate = Date()
        datePickerView.minimumDate = minDate()
        datePickerView.addTarget(self, action: #selector(handleDatePickertxtFrom), for: UIControlEvents.valueChanged)
    }
    
    @objc func txtToEditBegin(sender: UITextField)
    {
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        //tempTxtTo = sender
        datePickerView.maximumDate = Date()
        datePickerView.minimumDate = minDate()
        datePickerView.addTarget(self, action: #selector(handleDatePickertxtTo), for: UIControlEvents.valueChanged)
    }
    
    @objc func handleDatePickertxtFrom(sender: UIDatePicker) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        tempTxtFrom.text = convertDateFormater(dateFormatter.string(from: sender.date))
        
    }
    @objc func handleDatePickertxtTo(sender: UIDatePicker) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        
        tempTxtTo.text = convertDateFormater(dateFormatter.string(from: sender.date))
        
    }
    
    func addDoneButtonOnDatePicker()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelPicker))
        
        var items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as! [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        tempTxtFrom.inputAccessoryView = doneToolbar
        tempTxtTo.inputAccessoryView = doneToolbar
        
        
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
        compareDates(From_date: tempTxtFrom.text!, To_date: tempTxtTo.text!)
    }
   
    func compareDates(From_date: String , To_date : String)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date_from = dateFormatter.date(from: From_date)
        let date_to = dateFormatter.date(from: To_date)
        
        if(date_from! <= date_to!)
        {
            
            loadFastLog(From_Date: dateFormatter.string(from: date_from!), To_Date: dateFormatter.string(from: date_to!))
        }
        else
        {
            self.showAlert(title: "Invaild Input", message: "From Date cannot be greater than To Date")
        }
    }
    
    func addDoneButtonOnTextView()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(canceltextView))
        
        var items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as! [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        
        txtCancelReason.inputAccessoryView = doneToolbar
        
    }
    
    @objc func canceltextView(){
        self.view.endEditing(true)
        
    }
    
    func loadFastLog(From_Date : String , To_Date : String)
    {
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //let FastLogParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "from_date" : From_Date , "to_date" : To_Date + "23:59:59" , "current_date" : To_Date + "23:59:59"]
        
        let FastLogParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "from_date" : From_Date , "to_date" : To_Date , "current_date" : to_date ]
        
        print(FastLogParameters)
        
        Alamofire.request(GetFastAPI, method: .post, parameters: FastLogParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                
                print(JSON(response.result.value))
                
                self.tempDict = JSON(response.result.value!)
                
                //print(tempDict["data"]["user_id"])
                
                if(self.tempDict["status"] == "success")
                {
                    //self.foodLogCount = self.tempDict["data"].count
                    //self.foodLogTableView.reloadData()
                    
                    self.tableView.reloadData()
                    
                    spinnerActivity.hide(animated: true)
                }
                else if(self.tempDict["status"] == "error")
                {
                    spinnerActivity.hide(animated: true)
                    self.showAlert(title: "Alert", message: "Something went Wrong")
                }
                
                
            }
            else
            {
                spinnerActivity.hide(animated: true)
                self.showAlert(title: "Alert", message: "Please Check Your Internet Connection")
            }
        })
        
        
    }
    
    func startTimer() {
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        tempTimer.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
           
        } else {
            
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", hours,minutes, seconds)
 
        
        /*
        let seconds: Int = ((totalSeconds%(1000*60*60))%(1000*60))/1000
        let minutes: Int = (totalSeconds % (1000*60*60))/(1000*60)
        let hours: Int = totalSeconds / (1000*60*60)
        return String(format: "%02d:%02d:%02d", hours,minutes, seconds)
         */
 
        //return String(format: "%02d",totalSeconds)
    }
    
    
    @objc func StopFast()
    {
        ViewCancel.isHidden = false
        ViewAlpha.isHidden = false
        
        self.view.bringSubview(toFront: ViewAlpha)
        self.view.bringSubview(toFront: ViewCancel)
    
    }
    
    @IBAction func btnCloseViewCancel(_ sender: UIButton) {
        
        ViewCancel.isHidden = true
        ViewAlpha.isHidden = true
        self.view.bringSubview(toFront: tableView)
    }
    
    @IBAction func btnSubmitViewCancel(_ sender: UIButton) {
        
        if(txtCancelReason.text == "" || txtCancelReason.text == "Cancel Reason...")
        {
            self.showAlert(title: "Alert", message: "Please enter reason for cancelling your fast")
        }
        else
        {
            let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let CancelFastParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "cancel_reason" : txtCancelReason.text , "fasting_id" : self.tempDict["current_fasting"][0]["fasting_id"].intValue]
            
            
            Alamofire.request(CancelFastAPI, method: .post, parameters: CancelFastParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if(response.result.value != nil)
                {
                    
                    print(JSON(response.result.value))
                    
                    let tempDict = JSON(response.result.value!)
                    
                    //print(tempDict["data"]["user_id"])
                    
                    if(tempDict["status"] == "success")
                    {
                        spinnerActivity.hide(animated: true)
                        
                        self.ViewCancel.isHidden = true
                        self.ViewAlpha.isHidden = true
                        self.view.bringSubview(toFront: self.tableView)
                        
                        //self.viewDidLoad()
                        //self.loadFastLog(From_Date : self.from_date , To_Date : self.to_date)
                        self.loadFastLog(From_Date : "" , To_Date : "")
                      
                    }
                    else if(tempDict["status"] == "error")
                    {
                        spinnerActivity.hide(animated: true)
                        self.showAlert(title: "Alert", message: "Something went wrong while Cancelling Fast")
                    }
                    
                }
                else
                {
                    spinnerActivity.hide(animated: true)
                    self.showAlert(title: "Alert", message: "Please Check Your Internet Connection")
                }
            })
            
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtCancelReason.text == "Cancel Reason..."
        {
            txtCancelReason.text = nil
            txtCancelReason.textColor = UIColor.black
        }
        
        ViewCancel.frame = CGRect(x: ViewCancel.frame.origin.x, y: ViewCancel.frame.origin.y - 150, width: ViewCancel.frame.size.width, height: ViewCancel.frame.size.height)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtCancelReason.text == nil
        {
            txtCancelReason.text = "Cancel Reason..."
            txtCancelReason.textColor = UIColor.lightGray
        }
        
        ViewCancel.frame = CGRect(x: ViewCancel.frame.origin.x, y: ViewCancel.frame.origin.y + 150, width: ViewCancel.frame.size.width, height: ViewCancel.frame.size.height)
    }
    
    @objc func refresh() {
        //  your code to refresh tableView
        
        //self.loadFastLog(From_Date : self.from_date , To_Date : self.to_date)
        
        print("table refresh function called by pilling the table view")
        
        self.loadFastLog(From_Date : "" , To_Date :"")
        
        refreshControl.endRefreshing()
    }
    
    @objc func ResumeApp()
    {
        print("Application running again from background")
        
        currentDate = Date()
        print(currentDate.timeIntervalSince1970)
        
        //self.loadFastLog(From_Date : self.from_date , To_Date : self.to_date)
        
        self.loadFastLog(From_Date : "" , To_Date : "")
        
    }
    
    @objc func PauseApp()
    {
        print("Application is kept in background")
        
        endTimer()
    }
    
    
    func startAutoRefreshTimer() {
        timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        timer = Timer.scheduledTimer(withTimeInterval: 50.0, repeats: true) { [weak self] _ in
            // do something here
            
            self?.loadFastLog(From_Date : "" , To_Date : "")
            
        }
    }
    
    func stopAutoRefreshTimer() {
        timer?.invalidate()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
