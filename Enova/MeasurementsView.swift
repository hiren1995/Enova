//
//  MeasurementsView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 26/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Charts

var  WaistValues:[Double] = []
var  HipsValues:[Double] = []
var  WristValues:[Double] = []
var  ForearmValues:[Double] = []

class MeasurementsView: UIViewController,UITextFieldDelegate{
    
    @IBOutlet var HeaderView: UIView!
    
    @IBOutlet var MenuView: UIView!
    
    
    @IBOutlet weak var newDataAddView: UIView!
    
    @IBOutlet weak var AlphaView: UIView!
    
    
    @IBOutlet weak var lineChatView: LineChartView!
    
    
    @IBOutlet weak var txtNewValue: UITextField!
    
    
    @IBOutlet weak var lblHighWaist: UILabel!
    
    
    @IBOutlet weak var lblLowWaist: UILabel!
    
    
    @IBOutlet weak var txtFrom: UITextField!
    
    @IBOutlet weak var txtTo: UITextField!
    
    @IBOutlet weak var lineChartViewHips: LineChartView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HeaderView.ShadowHeader()
        MenuView.menuViewBorder()
        MenuView.isHidden = true
        newDataAddView.ShadowHeader()
        newDataAddView.isHidden = true
        AlphaView.isHidden = true
        
        
        txtNewValue.delegate = self
        
        days = [1,2,3,4,5,6,7]
        WaistValues = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0,17.0]
        HipsValues = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0,17.0]
        
        setChart(dataPoints: days,valuesWaist: WaistValues)
        
        lblHighWaist.text = String(describing: WaistValues.max()!)
        lblLowWaist.text = String(describing: WaistValues.min()!)
        
        addDoneButtonOnDatePicker()
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnMenuPress(_ sender: Any) {
        
        MenuView.menuClicked()
        
        
    }
    
    
    func setChart(dataPoints: [Int] , valuesWaist: [Double] )
    {
        var circleColors: [NSUIColor] = []
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0...dataPoints.count - 1
        {
            
            if(valuesWaist[i] >= 12.0)
            {
                circleColors.append(NSUIColor.red)
            }
            else
            {
                circleColors.append(NSUIColor.green)
                
            }
            
            let dataEntry = ChartDataEntry(x: Double(i), y: valuesWaist[i] )
            
            dataEntries.append(dataEntry)
            
            
        }
        
        let line1 = LineChartDataSet(values: dataEntries, label: "Waist")
        
        
        lineChatView.MakeLineGraph(line: line1, circleColors: circleColors, labelText: " Graph")   // for Make Graph method check the CustomClass.swift
        
       
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
            days.append(days.count+1)
            WaistValues.append(Double(txtNewValue.text!)!)
            newDataAddView.isHidden = true
            AlphaView.isHidden = true
            setChart(dataPoints: days,valuesWaist: WaistValues)
            lblHighWaist.text = String(describing: WaistValues.max()!)
            lblLowWaist.text = String(describing: WaistValues.min()!)
        }
    }
    
    //-------------------------------  code for date picker for txtFrom button ----------------------------------------------------------
    
    @IBAction func txtFromClicked(_ sender: UITextField) {
        //code for what to do when date field is tapped
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(handleDatePickertxtFrom), for: UIControlEvents.valueChanged)
        
    }
    
    @objc func handleDatePickertxtFrom(sender: UIDatePicker) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        txtFrom.text = dateFormatter.string(from: sender.date)
        
    }
    
    //---------------------------------------------- End ------------------------------------------------------------------------------
    
    
    //-------------------------------  code for date picker for txtTo button ----------------------------------------------------------
    
    @IBAction func txtToClicked(_ sender: UITextField) {
        
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(handleDatePickertxtTo), for: UIControlEvents.valueChanged)
    }
    
    @objc func handleDatePickertxtTo(sender: UIDatePicker) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        txtTo.text = dateFormatter.string(from: sender.date)
        
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
        
        /*
         if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
         if newDataAddView.frame.origin.y == 165{
         newDataAddView.frame.origin.y -= keyboardSize.height
         }
         }
         */
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        newDataAddView.frame.origin.y += 150
        
        /*
         if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
         if newDataAddView.frame.origin.y != 165{
         newDataAddView.frame.origin.y += keyboardSize.height
         }
         }
         */
    }
    
    //-------------------------------------------------------- End -----------------------------------------------------------------------------------------
    
    
    //---------------------------------------------------- adding a tool bar with done button in swift -----------------------------------------------------
    
    func addDoneButtonOnDatePicker()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelPicker))
        
        var items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as! [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        txtTo.inputAccessoryView = doneToolbar
        txtFrom.inputAccessoryView = doneToolbar
        txtNewValue.inputAccessoryView = doneToolbar
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBack2(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
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
