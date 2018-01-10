//
//  WeightView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 25/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import MBProgressHUD
import SwiftyJSON

var  WeightValues:[Double] = []

class WeightView: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var HeaderView: UIView!
    
    @IBOutlet var MenuView: UIView!
    
    
    @IBOutlet weak var newDataAddView: UIView!
    
    @IBOutlet weak var AlphaView: UIView!
    
    
    @IBOutlet weak var lineChatView: LineChartView!
    
    
    @IBOutlet weak var txtNewValue: UITextField!
    
    
    @IBOutlet weak var lblHighWeight: UILabel!
    
    
    @IBOutlet weak var lblLowWeight: UILabel!
    
    
    @IBOutlet weak var txtFrom: UITextField!
    
    @IBOutlet weak var txtTo: UITextField!
    
    var tempDict : JSON = JSON.null

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HeaderView.ShadowHeader()
        MenuView.menuViewBorder()
        MenuView.isHidden = true
        newDataAddView.ShadowHeader()
        newDataAddView.isHidden = true
        AlphaView.isHidden = true
        
        
        txtNewValue.delegate = self
        
        addDoneButtonOnDatePicker()
        addDoneOnTextView()
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let to_date = formatter.string(from: currentDate)
        
        let subtractDays = -7
        var dateComponent = DateComponents()
        dateComponent.day = subtractDays
        
        let temp = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        let from_date = formatter.string(from: temp!)
       
        txtFrom.text = from_date
        txtTo.text = to_date
        
        loadWeightData(From_date : from_date, To_date: to_date)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnMenuPress(_ sender: Any) {
        /*
        MenuView.menuClicked()
        */
        
    }
    
    
    func setChart(dataPoints: [Int] , values: [Double])
    {
        var circleColors: [NSUIColor] = []
        
        var dataEntries: [ChartDataEntry] = []
        
        let userData = JSON(udefault.value(forKey: UserData)!)
        
        if(dataPoints.count != 0)
        {
            for i in 0...dataPoints.count - 1
            {
                
                if(values[i] >= userData["data"]["weight"].doubleValue)
                {
                    circleColors.append(NSUIColor.red)
                }
                else
                {
                    circleColors.append(NSUIColor.init(red: 50/255, green: 153/255, blue: 50/255, alpha: 1.0))
                    
                }
                
                let dataEntry = ChartDataEntry(x: Double(i), y: values[i] )
                
                dataEntries.append(dataEntry)
                
                
            }
            
            let line1 = LineChartDataSet(values: dataEntries, label: "Weight")
            
            
            lineChatView.MakeLineGraph(line: line1, circleColors: circleColors, labelText: " Graph")   // for Make Graph method check the CustomClass.swift
            
        }
        
       
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        
        AlphaView.isHidden = false
        newDataAddView.isHidden = false
        newDataAddView.layer.zPosition = 1
        
        txtNewValue.text = ""
        
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        
        AlphaView.isHidden = true
        newDataAddView.isHidden = true
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        self.view.endEditing(true)
        
        
        if(txtNewValue.text == "")
        {
            self.showAlert(title: "Alert", message: "Please Enter Weight")
        }
        else
        {
            let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            days = []
            WeightValues = []
            
            self.setChart(dataPoints: days,values: WeightValues)
            
            let timeStamp = String(Date().currentTimeStamp)
            
            let addWeightParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "weight" : txtNewValue.text! , "timestamp" : timeStamp]
            
            Alamofire.request(AddWeightAPI, method: .post, parameters: addWeightParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if(response.result.value != nil)
                {
                    
                    print(JSON(response.result.value))
                    
                    let tempDictweight = JSON(response.result.value!)
                    
                    //print(tempDict["data"]["user_id"])
                    
                    if(tempDictweight["status"] == "success")
                    {
                        self.newDataAddView.isHidden = true
                        self.AlphaView.isHidden = true
                    
                        spinnerActivity.hide(animated: true)
                        
                        self.viewDidLoad()
                        
                    }
                    else if(tempDictweight["status"] == "error")
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
    }
    
    //-------------------------------  code for date picker for txtFrom button ----------------------------------------------------------
    
    @IBAction func txtFromClicked(_ sender: UITextField) {
        //code for what to do when date field is tapped
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.maximumDate = Date()
        datePickerView.minimumDate = minDate()
        datePickerView.addTarget(self, action: #selector(handleDatePickertxtFrom), for: UIControlEvents.valueChanged)
        
    }
    
    @objc func handleDatePickertxtFrom(sender: UIDatePicker) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        txtFrom.text = convertDateFormater(dateFormatter.string(from: sender.date))
        
    }
    
    //---------------------------------------------- End ------------------------------------------------------------------------------
    
    
    //-------------------------------  code for date picker for txtTo button ----------------------------------------------------------
    
    @IBAction func txtToClicked(_ sender: UITextField) {
        
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.maximumDate = Date()
        datePickerView.minimumDate = minDate()
        datePickerView.addTarget(self, action: #selector(handleDatePickertxtTo), for: UIControlEvents.valueChanged)
    }
    
    @objc func handleDatePickertxtTo(sender: UIDatePicker) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        txtTo.text = convertDateFormater(dateFormatter.string(from: sender.date))
        
    }
    //---------------------------------------------- End ------------------------------------------------------------------------------
    
    
    //-------------------------------  code for closing key borad on click of return key ----------------------------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //---------------------------------- Code for adjusting view depending upon the keyboard open and close...------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        newDataAddView.frame.origin.y -= 150
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        newDataAddView.frame.origin.y += 150
        
    }
    
    //-------------------------------------------------------- End -----------------------------------------------------------------------------------------
    
    
    //---------------------------------------------------- adding a tool bar with done button in swift -----------------------------------------------------
    
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
        
        txtTo.inputAccessoryView = doneToolbar
        txtFrom.inputAccessoryView = doneToolbar
        //txtNewValue.inputAccessoryView = doneToolbar
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
        compareDates(From_date: txtFrom.text!, To_date: txtTo.text!)
        
    }
    
    func addDoneOnTextView()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelTextPicker))
        
        var items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as! [UIBarButtonItem]
        doneToolbar.sizeToFit()
        txtNewValue.inputAccessoryView = doneToolbar
    }
    
    @objc func cancelTextPicker(){
        self.view.endEditing(true)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.fromLeft()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBack2(_ sender: UIButton) {
       
        self.fromLeft()
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadWeightData(From_date : String , To_date : String)
    {
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let WeightParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "from_date" : From_date , "to_date" : To_date+"23:59:59"]
        
        print(WeightParameters)
        
        days = []
        WeightValues = []
        
        self.setChart(dataPoints: days,values: WeightValues)
        
        Alamofire.request(GetWeightAPI, method: .post, parameters: WeightParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                
                print(JSON(response.result.value))
                
                self.tempDict = JSON(response.result.value!)
                
                //print(tempDict["data"]["user_id"])
                
                if(self.tempDict["status"] == "success")
                {
                    if(self.tempDict["data"].count != 0)
                    {
                        self.lblHighWeight.text = self.tempDict["start_weight"].stringValue
                        self.lblLowWeight.text = self.tempDict["weight_diff"].stringValue
                        
                        for var i in 0...self.tempDict["data"].count-1
                        {
                            days.insert(i+1, at: i)
                            WeightValues.insert(self.tempDict["data"][i]["weight"].doubleValue, at: i)
                            
                        }
                        
                        
                        self.setChart(dataPoints: days,values: WeightValues)
                    }
                    
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
    
    func compareDates(From_date: String , To_date : String)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date_from = dateFormatter.date(from: From_date)
        let date_to = dateFormatter.date(from: To_date)
        
        print(From_date)
        print(To_date)
        
        if(date_from! <= date_to!)
        {
            days = []
            WeightValues = []
            
            self.setChart(dataPoints: days,values: WeightValues)
            
            loadWeightData(From_date: dateFormatter.string(from: date_from!), To_date: dateFormatter.string(from: date_to!))
        }
        else
        {
            self.showAlert(title: "Invaild Input", message: "From Date cannot be greater than To Date")
        }
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
