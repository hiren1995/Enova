//
//  AddFastView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 02/04/18.
//  Copyright © 2018 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class AddFastView: UIViewController {

    
    @IBOutlet var txtStartDate: UITextField!
    @IBOutlet var txtStartTime: UITextField!
    @IBOutlet var txtEndDate: UITextField!
    @IBOutlet var txtEndTime: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDoneButtonOnDatePicker()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func txtStartDateEditBegin(_ sender: UITextField) {
        
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        
        //datePickerView.maximumDate = Date()
        //datePickerView.minimumDate = minDate()
        
        datePickerView.minimumDate = Date()
        
        datePickerView.addTarget(self, action: #selector(handleDatePickertxtStart), for: UIControlEvents.valueChanged)
        
    }
    @objc func handleDatePickertxtStart(sender: UIDatePicker) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        txtStartDate.text = convertDateFormater(dateFormatter.string(from: sender.date))
        
    }
    
    @IBAction func txtEndDateEditBegin(_ sender: UITextField) {
        
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        
        //datePickerView.maximumDate = Date()
        //datePickerView.minimumDate = minDate()
        
        datePickerView.minimumDate = Date()
        
        datePickerView.addTarget(self, action: #selector(handleDatePickertxtEnd), for: UIControlEvents.valueChanged)
    }
    @objc func handleDatePickertxtEnd(sender: UIDatePicker) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        txtEndDate.text = convertDateFormater(dateFormatter.string(from: sender.date))
        
    }
    
    @IBAction func txtStartTimeEditBegin(_ sender: UITextField) {
        
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(handleDatePickertxtStartTime), for: UIControlEvents.valueChanged)
    }
    @objc func handleDatePickertxtStartTime(sender: UIDatePicker) {
        var dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        txtStartTime.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func txtEndTimeEditBegin(_ sender: UITextField) {
        
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePickertxtEndTime), for: UIControlEvents.valueChanged)
    }
    @objc func handleDatePickertxtEndTime(sender: UIDatePicker) {
        var dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        txtEndTime.text = dateFormatter.string(from: sender.date)
        
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
        
        txtStartDate.inputAccessoryView = doneToolbar
        txtEndDate.inputAccessoryView = doneToolbar
        txtStartTime.inputAccessoryView = doneToolbar
        txtEndTime.inputAccessoryView = doneToolbar
        
    }
    @objc func cancelPicker(){
        self.view.endEditing(true)
        
    }
    
    func compareDates(Start_date: String , End_date : String)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date_start = dateFormatter.date(from: Start_date)
        let date_end = dateFormatter.date(from: End_date)
        
        if(date_start! < date_end!)
        {
            //let startTimeStr = txtStartDate.text! + " " + txtStartTime.text!
            //let endTimeStr = txtEndDate.text! + " " + txtEndTime.text!
            //loadFoodLogs(From_date: dateFormatter.string(from: date_from!), To_date: dateFormatter.string(from: date_to!))
            
            addFast()
            
        }
        else if(date_start! == date_end!)
        {
            compareTime(Start_Time: txtStartTime.text!, End_Time: txtEndTime.text!)
        }
        else
        {
            self.showAlert(title: "Invaild Input", message: "Start Date cannot be greater than To Date")
        }
    }
    func compareTime(Start_Time: String, End_Time : String)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        let start_time = dateFormatter.date(from: Start_Time)
        let end_time = dateFormatter.date(from: End_Time)
        
        if(start_time! < end_time!)
        {
            addFast()
        }
        else
        {
            self.showAlert(title: "Invaild Input", message: "Start Time cannot be greater than End Time")
        }
        
    }
    
    @IBAction func btnStartFast(_ sender: UIButton) {
        
        if(txtStartDate.text == "DATE" || txtStartDate.text == "")
        {
             self.showAlert(title: "Invaild Input", message: "Please Select Start Date")
        }
        else if(txtEndDate.text == "DATE" || txtEndDate.text == "")
        {
            self.showAlert(title: "Invaild Input", message: "Please Select End Date")
        }
        else if(txtStartTime.text == "START TIME" || txtStartTime.text == "")
        {
            self.showAlert(title: "Invaild Input", message: "Please Select Start Time")
        }
        else if(txtEndTime.text == "END TIME" || txtEndTime.text == "")
        {
            self.showAlert(title: "Invaild Input", message: "Please Select End Time")
        }
        else
        {
            compareDates(Start_date: txtStartDate.text!, End_date: txtEndDate.text!)
        }
        
    }
    
    func addFast()
    {
        
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let addFastParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "name" : "iOS Fast Adding" , "fasting_date" : txtStartDate.text! , "from_time" : txtStartTime.text!, "to_time": txtEndTime.text! , "fasting_end_date": txtEndDate.text!]
        
        
        Alamofire.request(AddFastAPI, method: .post, parameters: addFastParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                
                print(JSON(response.result.value))
                
                let tempDict = JSON(response.result.value!)
                
                //print(tempDict["data"]["user_id"])
                
                if(tempDict["status"] == "success")
                {
                   
                    spinnerActivity.hide(animated: true)
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let fastingView = storyboard.instantiateViewController(withIdentifier: "fastingView") as! FastingView
                    
                    self.fromLeft()
                    
                    self.present(fastingView, animated: false, completion: nil)
 
                    
                    //self.dismiss(animated: true, completion: nil)
                }
                else if(tempDict["status"] == "error")
                {
                    spinnerActivity.hide(animated: true)
                    self.showAlert(title: "Alert", message: "Something went wrong while Adding Fast")
                }
                
            }
            else
            {
                spinnerActivity.hide(animated: true)
                self.showAlert(title: "Alert", message: "Please Check Your Internet Connection")
            }
        })
        
        //self.fromLeft()
        //self.dismiss(animated: false, completion: nil)
        
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let fastingView = storyboard.instantiateViewController(withIdentifier: "fastingView") as! FastingView
        //self.present(fastingView, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        //self.fromLeft()
        //self.dismiss(animated: false, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fastingView = storyboard.instantiateViewController(withIdentifier: "fastingView") as! FastingView
        
        self.fromLeft()
        
        self.present(fastingView, animated: false, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
