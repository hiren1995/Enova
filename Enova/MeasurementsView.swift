//
//  MeasurementsView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 26/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import MBProgressHUD
import SwiftyJSON

var  WaistValues:[Double] = []
var  HipsValues:[Double] = []
var  WristValues:[Double] = []
var  ForearmValues:[Double] = []

var daysWaist:[Int] = []
var daysHips:[Int] = []
var daysWrist:[Int] = []
var daysForearm:[Int] = []

class MeasurementsView: UIViewController,UITextFieldDelegate{
    
    @IBOutlet var HeaderView: UIView!
    
    @IBOutlet var MenuView: UIView!

    @IBOutlet weak var InnerScrollView: UIView!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var newDataAddView: UIView!
    
    @IBOutlet weak var AlphaView: UIView!
    
    @IBOutlet weak var lineChatView: LineChartView!
    
    @IBOutlet weak var txtNewValue: UITextField!
    
    @IBOutlet weak var lblHighWaist: UILabel!
    
    @IBOutlet weak var lblLowWaist: UILabel!
    
    @IBOutlet weak var lblStartHips: UILabel!
    @IBOutlet weak var lblLossHips: UILabel!
    
    @IBOutlet weak var lblStartWrist: UILabel!
    @IBOutlet weak var lblLossWrist: UILabel!
    
    @IBOutlet weak var lblStartForearm: UILabel!
    @IBOutlet weak var lbllossForearm: UILabel!
    
    @IBOutlet weak var txtFrom: UITextField!
    
    @IBOutlet weak var txtTo: UITextField!
    
    @IBOutlet weak var lineChartViewHips: LineChartView!
    
    @IBOutlet weak var lineChartViewWrist: LineChartView!
    
    @IBOutlet weak var lineChartViewForeArm: LineChartView!
    
    @IBOutlet weak var lblAddViewName: UILabel!
    
    var tempDict : JSON = JSON.null
    
    @IBOutlet weak var lblHips: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HeaderView.ShadowHeader()
        MenuView.menuViewBorder()
        MenuView.isHidden = true
        newDataAddView.ShadowHeader()
        newDataAddView.isHidden = true
        AlphaView.isHidden = true
        
        
        txtNewValue.delegate = self
        
        //days = [1,2,3,4,5,6,7]
        //WaistValues = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0,17.0]
        //HipsValues = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0,17.0]
        //WristValues = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0,17.0]
        //ForearmValues = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0,17.0]
        
        //setChart(dataPoints: days,valuesWaist: WaistValues ,  type: 1)
        //setChart(dataPoints: days,valuesWaist: HipsValues ,  type: 2)
        //setChart(dataPoints: days,valuesWaist: WristValues ,  type: 3)
        //setChart(dataPoints: days,valuesWaist: ForearmValues ,  type: 4 )
        
        //lblHighWaist.text = String(describing: WaistValues.max()!)
        //lblLowWaist.text = String(describing: WaistValues.min()!)
        
        addDoneButtonOnDatePicker()
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let to_date = formatter.string(from: currentDate)
        
        //print(result+"23:59:59")
        
        let subtractDays = -7
        var dateComponent = DateComponents()
        dateComponent.day = subtractDays
        
        let temp = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        let from_date = formatter.string(from: temp!)
        
        
        
        txtFrom.text = from_date
        txtTo.text = to_date
        
        loadMeasurementsData(From_date : from_date, To_date: to_date)

        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnMenuPress(_ sender: Any) {
       
        /*
        MenuView.menuClicked()
        
        */
    }
    
    
    func setChart(dataPoints: [Int] , values: [Double] , type : Int)
    {
        var circleColors: [NSUIColor] = []
        
        var dataEntries: [ChartDataEntry] = []
        
        let userData = JSON(udefault.value(forKey: UserData)!)
        
        if(dataPoints.count != 0)
        {
            switch type {
            case 1:
                for i in 0...dataPoints.count - 1
                {
                    
                    if(values[i] >= userData["data"]["waist"].doubleValue)
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
                
                let line1 = LineChartDataSet(values: dataEntries, label: "Waist")
                
                
                lineChatView.MakeLineGraph(line: line1, circleColors: circleColors, labelText: " Graph")   // for Make Graph method check the CustomClass.swift
                
            case 2:
                
                for i in 0...dataPoints.count - 1
                {
                    
                    if(values[i] >= userData["data"]["hips"].doubleValue)
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
                
                let line1 = LineChartDataSet(values: dataEntries, label: "Hips")
                
                
                lineChartViewHips.MakeLineGraph(line: line1, circleColors: circleColors, labelText: " Graph")   // for Make Graph method check the CustomClass.swift
                
            case 3:
                
                for i in 0...dataPoints.count - 1
                {
                    
                    if(values[i] >= userData["data"]["wrist"].doubleValue)
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
                
                let line1 = LineChartDataSet(values: dataEntries, label: "Wrist")
                
                
                lineChartViewWrist.MakeLineGraph(line: line1, circleColors: circleColors, labelText: " Graph")   // for Make Graph method check the CustomClass.swift
                
            case 4:
                
                for i in 0...dataPoints.count - 1
                {
                    
                    if(values[i] >= userData["data"]["forearm"].doubleValue)
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
                
                let line1 = LineChartDataSet(values: dataEntries, label: "Forearms")
                
                
                lineChartViewForeArm.MakeLineGraph(line: line1, circleColors: circleColors, labelText: " Graph")   // for Make Graph method check the CustomClass.swift
                
                
            default:
                print("Please give Proper Choice")
            }
        }
        
        
        
        /*
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
        */
       
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        
        AlphaView.isHidden = false
        newDataAddView.isHidden = false
        newDataAddView.layer.zPosition = 1
        
        txtNewValue.text = ""
        
        lblAddViewName.text = "WAIST"
        
        /*
        
         newDataAddView.translatesAutoresizingMaskIntoConstraints = false
         
        let topSpaceWaist = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 165)
        let topSpaceHips = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 619)
        let topSpaceWrist = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1041)
        let topSpaceForearms = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1464)
        
        if(lblAddViewName.text == "HIPS")
        {
            //NSLayoutConstraint.deactivate([topSpaceHips])
            
            newDataAddView.removeConstraint(topSpaceHips)
            
             InnerScrollView.removeConstraint(topSpaceHips)
        }
        else if(lblAddViewName.text == "WRIST")
        {
            //NSLayoutConstraint.deactivate([topSpaceWrist])
            
            newDataAddView.removeConstraint(topSpaceWrist)
            
            InnerScrollView.removeConstraint(topSpaceWrist)
        }
        else
        {
            //NSLayoutConstraint.deactivate([topSpaceForearms])
            
            newDataAddView.removeConstraint(topSpaceForearms)
            
             InnerScrollView.removeConstraint(topSpaceForearms)
        }
        
        NSLayoutConstraint.activate([topSpaceWaist])
        
         */
    }
    
    @IBAction func btnAddHips(_ sender: Any) {
        
        AlphaView.isHidden = false
        newDataAddView.isHidden = false
        newDataAddView.layer.zPosition = 1
        
        txtNewValue.text = ""
        
        lblAddViewName.text = "HIPS"
        
        /*
        
        newDataAddView.translatesAutoresizingMaskIntoConstraints = false
        
        let topSpaceWaist = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 165)
        let topSpaceHips = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 619)
        let topSpaceWrist = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1041)
        let topSpaceForearms = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1464)
        
        if(lblAddViewName.text == "WAIST")
        {
            //NSLayoutConstraint.deactivate([topSpaceWaist])
            
            newDataAddView.removeConstraint(topSpaceWaist)
            
            InnerScrollView.removeConstraint(topSpaceWaist)
            
        }
        else if(lblAddViewName.text == "WRIST")
        {
             //NSLayoutConstraint.deactivate([topSpaceWrist])
            
            newDataAddView.removeConstraint(topSpaceWrist)
            
            InnerScrollView.removeConstraint(topSpaceWrist)
        }
        else
        {
             //NSLayoutConstraint.deactivate([topSpaceForearms])
            
            newDataAddView.removeConstraint(topSpaceForearms)
            
            InnerScrollView.removeConstraint(topSpaceForearms)
        }
        
        
        // activate the constraints
        NSLayoutConstraint.activate([topSpaceHips])
 
        */
    }
    
    @IBAction func btnAddWrist(_ sender: Any) {
        
        AlphaView.isHidden = false
        newDataAddView.isHidden = false
        newDataAddView.layer.zPosition = 1
        
        txtNewValue.text = ""
        
        lblAddViewName.text = "WRIST"
        
        /*
        
        newDataAddView.translatesAutoresizingMaskIntoConstraints = false
        
        let topSpaceWaist = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 165)
        let topSpaceHips = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 619)
        let topSpaceWrist = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1041)
        let topSpaceForearms = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1464)
        
        if(lblAddViewName.text == "WAIST")
        {
            //NSLayoutConstraint.deactivate([topSpaceWaist])
            
            newDataAddView.removeConstraint(topSpaceWaist)
            
            InnerScrollView.removeConstraint(topSpaceWaist)
        }
        else if(lblAddViewName.text == "HIPS")
        {
            //NSLayoutConstraint.deactivate([topSpaceHips])
            
            newDataAddView.removeConstraint(topSpaceHips)
            
            InnerScrollView.removeConstraint(topSpaceHips)
        }
        else
        {
            //NSLayoutConstraint.deactivate([topSpaceForearms])
            
            newDataAddView.removeConstraint(topSpaceForearms)
            
            InnerScrollView.removeConstraint(topSpaceForearms)
        }
       
        // activate the constraints
        NSLayoutConstraint.activate([topSpaceWrist])
 
        */
    }
    
    @IBAction func btnAddForearms(_ sender: Any) {
        
        AlphaView.isHidden = false
        newDataAddView.isHidden = false
        newDataAddView.layer.zPosition = 1
        
        txtNewValue.text = ""
        
        lblAddViewName.text = "FOREARM"
        
        /*
 
        newDataAddView.translatesAutoresizingMaskIntoConstraints = false
        
        let topSpaceWaist = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 165)
        let topSpaceHips = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 619)
        let topSpaceWrist = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1041)
        let topSpaceForearms = NSLayoutConstraint(item: newDataAddView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: InnerScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1464)
        
    
        if(lblAddViewName.text == "WAIST")
        {
            //NSLayoutConstraint.deactivate([topSpaceWaist])
            
            newDataAddView.removeConstraint(topSpaceWaist)
            
            InnerScrollView.removeConstraint(topSpaceWaist)
            
            
        }
        else if(lblAddViewName.text == "HIPS")
        {
            //NSLayoutConstraint.deactivate([topSpaceHips])
            newDataAddView.removeConstraint(topSpaceWaist)
            
            InnerScrollView.removeConstraint(topSpaceWaist)
        }
        else
        {
            //NSLayoutConstraint.deactivate([topSpaceWrist])
            newDataAddView.removeConstraint(topSpaceWrist)
            
            InnerScrollView.removeConstraint(topSpaceWrist)
        }
        
        // activate the constraints
        NSLayoutConstraint.activate([topSpaceForearms])
 
        */
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        
        AlphaView.isHidden = true
        newDataAddView.isHidden = true
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        self.view.endEditing(true)
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        daysWaist = []
        daysHips = []
        daysWrist = []
        daysForearm = []
        
        WaistValues = []
        HipsValues = []
        WristValues = []
        ForearmValues = []
        
        self.setChart(dataPoints: days,values: WaistValues, type: 1)
        self.setChart(dataPoints: days,values: HipsValues, type: 2)
        self.setChart(dataPoints: days,values: WristValues, type: 3)
        self.setChart(dataPoints: days,values: ForearmValues, type: 4)
        
        
        
        if(txtNewValue.text == "")
        {
            self.showAlert(title: "Alert", message: "Please Enter Weight")
        }
        else
        {
            let timeStamp = String(Date().currentTimeStamp)
            
            if(lblAddViewName.text == "WAIST")
            {
                let addWaistParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "waist" : txtNewValue.text! , "timestamp" : timeStamp]
                
                Alamofire.request(AddWaistAPI, method: .post, parameters: addWaistParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    if(response.result.value != nil)
                    {
                        
                        print(JSON(response.result.value))
                        
                        //self.tempDict = JSON(response.result.value!)
                        
                        //print(tempDict["data"]["user_id"])
                        
                        if(self.tempDict["status"] == "success")
                        {
                            self.newDataAddView.isHidden = true
                            self.AlphaView.isHidden = true
                            
                            self.lblHighWaist.text = self.tempDict["diff"]["start_waist"].stringValue
                            self.lblLowWaist.text = self.tempDict["diff"]["waist_diff"].stringValue
                            self.lblStartHips.text = self.tempDict["diff"]["start_hips"].stringValue
                            self.lblLossHips.text = self.tempDict["diff"]["hips_diff"].stringValue
                            self.lblStartWrist.text = self.tempDict["diff"]["start_wrist"].stringValue
                            self.lblLossWrist.text = self.tempDict["diff"]["wrist_diff"].stringValue
                            self.lblStartForearm.text = self.tempDict["diff"]["start_forearm"].stringValue
                            self.lbllossForearm.text = self.tempDict["diff"]["forearm_diff"].stringValue
                            
                            spinnerActivity.hide(animated: true)
                            
                            self.viewDidLoad()
                            
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
            else if(lblAddViewName.text == "HIPS")
            {
                let addHipsParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "hips" : txtNewValue.text! , "timestamp" : timeStamp]
                
                Alamofire.request(AddHipsAPI, method: .post, parameters: addHipsParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    if(response.result.value != nil)
                    {
                        
                        print(JSON(response.result.value))
                        
                        //self.tempDict = JSON(response.result.value!)
                        
                        //print(tempDict["data"]["user_id"])
                        
                        if(self.tempDict["status"] == "success")
                        {
                            self.newDataAddView.isHidden = true
                            self.AlphaView.isHidden = true
                            
                            self.lblHighWaist.text = self.tempDict["diff"]["start_waist"].stringValue
                            self.lblLowWaist.text = self.tempDict["diff"]["waist_diff"].stringValue
                            self.lblStartHips.text = self.tempDict["diff"]["start_hips"].stringValue
                            self.lblLossHips.text = self.tempDict["diff"]["hips_diff"].stringValue
                            self.lblStartWrist.text = self.tempDict["diff"]["start_wrist"].stringValue
                            self.lblLossWrist.text = self.tempDict["diff"]["wrist_diff"].stringValue
                            self.lblStartForearm.text = self.tempDict["diff"]["start_forearm"].stringValue
                            self.lbllossForearm.text = self.tempDict["diff"]["forearm_diff"].stringValue
                            
                            spinnerActivity.hide(animated: true)
                            
                            self.viewDidLoad()
                            
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
            else if(lblAddViewName.text == "WRIST")
            {
                let addWristParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "wrist" : txtNewValue.text! , "timestamp" : timeStamp]
                
                Alamofire.request(AddWristAPI, method: .post, parameters: addWristParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    if(response.result.value != nil)
                    {
                        
                        print(JSON(response.result.value))
                        
                        //self.tempDict = JSON(response.result.value!)
                        
                        //print(tempDict["data"]["user_id"])
                        
                        if(self.tempDict["status"] == "success")
                        {
                            self.newDataAddView.isHidden = true
                            self.AlphaView.isHidden = true
                            
                            self.lblHighWaist.text = self.tempDict["diff"]["start_waist"].stringValue
                            self.lblLowWaist.text = self.tempDict["diff"]["waist_diff"].stringValue
                            self.lblStartHips.text = self.tempDict["diff"]["start_hips"].stringValue
                            self.lblLossHips.text = self.tempDict["diff"]["hips_diff"].stringValue
                            self.lblStartWrist.text = self.tempDict["diff"]["start_wrist"].stringValue
                            self.lblLossWrist.text = self.tempDict["diff"]["wrist_diff"].stringValue
                            self.lblStartForearm.text = self.tempDict["diff"]["start_forearm"].stringValue
                            self.lbllossForearm.text = self.tempDict["diff"]["forearm_diff"].stringValue
                            
                            spinnerActivity.hide(animated: true)
                            
                            self.viewDidLoad()
                            
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
            else
            {
                let addForearmParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "forearm" : txtNewValue.text! , "timestamp" : timeStamp]
                
                Alamofire.request(AddForearmAPI, method: .post, parameters: addForearmParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    if(response.result.value != nil)
                    {
                        
                        print(JSON(response.result.value))
                        
                        //self.tempDict = JSON(response.result.value!)
                        
                        //print(tempDict["data"]["user_id"])
                        
                        if(self.tempDict["status"] == "success")
                        {
                            self.newDataAddView.isHidden = true
                            self.AlphaView.isHidden = true
                            
                            self.lblHighWaist.text = self.tempDict["diff"]["start_waist"].stringValue
                            self.lblLowWaist.text = self.tempDict["diff"]["waist_diff"].stringValue
                            self.lblStartHips.text = self.tempDict["diff"]["start_hips"].stringValue
                            self.lblLossHips.text = self.tempDict["diff"]["hips_diff"].stringValue
                            self.lblStartWrist.text = self.tempDict["diff"]["start_wrist"].stringValue
                            self.lblLossWrist.text = self.tempDict["diff"]["wrist_diff"].stringValue
                            self.lblStartForearm.text = self.tempDict["diff"]["start_forearm"].stringValue
                            self.lbllossForearm.text = self.tempDict["diff"]["forearm_diff"].stringValue
                            
                            spinnerActivity.hide(animated: true)
                            
                            self.viewDidLoad()
                            
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
            
            
            //days.append(days.count+1)
            //WaistValues.append(Double(txtNewValue.text!)!)
            //newDataAddView.isHidden = true
            //AlphaView.isHidden = true
            //setChart(dataPoints: days,values: WaistValues, type: 1)
            //lblHighWaist.text = String(describing: WaistValues.max()!)
            //lblLowWaist.text = String(describing: WaistValues.min()!)
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
        
        txtFrom.text = convertDateFormater(dateFormatter.string(from: sender.date))
        
        compareDates(From_date: txtFrom.text!, To_date: txtTo.text!)
        
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
        
        txtTo.text = convertDateFormater(dateFormatter.string(from: sender.date))
        
        compareDates(From_date: txtFrom.text!, To_date: txtTo.text!)
        
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
    
    
    func loadMeasurementsData(From_date : String , To_date : String)
    {
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let MeasurementsParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "from_date" : From_date , "to_date" : To_date+"23:59:59"]
        
        print(MeasurementsParameters)
        
        
        daysWaist = []
        daysHips = []
        daysWrist = []
        daysForearm = []
        
        WaistValues = []
        HipsValues = []
        WristValues = []
        ForearmValues = []
        
        self.setChart(dataPoints: days,values: WaistValues, type: 1)
        self.setChart(dataPoints: days,values: HipsValues, type: 2)
        self.setChart(dataPoints: days,values: WristValues, type: 3)
        self.setChart(dataPoints: days,values: ForearmValues, type: 4)
        
        Alamofire.request(GetMeasurementsAPI, method: .post, parameters: MeasurementsParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                
                print(JSON(response.result.value))
                
                self.tempDict = JSON(response.result.value!)
                
                //print(tempDict["data"]["user_id"])
                
                let tempUserData = JSON(udefault.value(forKey: UserData))
                
                print(tempUserData)
                
                let userGender = tempUserData["data"]["gender"].stringValue
                
                //print(userGender)
                
                if(self.tempDict["status"] == "success")
                {
                    if(userGender == "Male")
                    {
                        self.lblHighWaist.text = self.tempDict["diff"]["start_waist"].stringValue
                        self.lblLowWaist.text = self.tempDict["diff"]["waist_diff"].stringValue
                        
                        for var i in 0...self.tempDict["waist"].count-1
                        {
                            daysWaist.insert(i+1, at: i)
                            
                            WaistValues.insert(self.tempDict["waist"][i]["waist"].doubleValue, at: i)
                            
                        }
                        
                        self.setChart(dataPoints: daysWaist,values: WaistValues, type: 1)
                        
                        self.lblHips.isHidden = true
                        
                        self.InnerScrollView.frame = CGRect(x: 0, y: 0, width: self.InnerScrollView.frame.width, height: 539)
                        
                        self.InnerScrollView.translatesAutoresizingMaskIntoConstraints = true
                        
                        self.ScrollView.contentSize = CGSize(width: self.ScrollView.contentSize.width, height: self.InnerScrollView.frame.height)
                    }
                    else
                    {
                        
                        self.lblHighWaist.text = self.tempDict["diff"]["start_waist"].stringValue
                        self.lblLowWaist.text = self.tempDict["diff"]["waist_diff"].stringValue
                        self.lblStartHips.text = self.tempDict["diff"]["start_hips"].stringValue
                        self.lblLossHips.text = self.tempDict["diff"]["hips_diff"].stringValue
                        self.lblStartWrist.text = self.tempDict["diff"]["start_wrist"].stringValue
                        self.lblLossWrist.text = self.tempDict["diff"]["wrist_diff"].stringValue
                        self.lblStartForearm.text = self.tempDict["diff"]["start_forearm"].stringValue
                        self.lbllossForearm.text = self.tempDict["diff"]["forearm_diff"].stringValue
                        
                        for var i in 0...self.tempDict["waist"].count-1
                        {
                            daysWaist.insert(i+1, at: i)
                            
                            WaistValues.insert(self.tempDict["waist"][i]["waist"].doubleValue, at: i)
                            
                        }
                        for var i in 0...self.tempDict["hips"].count-1
                        {
                            daysHips.insert(i+1, at: i)
                            
                            HipsValues.insert(self.tempDict["hips"][i]["hips"].doubleValue, at: i)
                        }
                        for var i in 0...self.tempDict["wrist"].count-1
                        {
                            daysWrist.insert(i+1, at: i)
                            
                            WristValues.insert(self.tempDict["wrist"][i]["wrist"].doubleValue, at: i)
                        }
                        for var i in 0...self.tempDict["forearm"].count-1
                        {
                            daysForearm.insert(i+1, at: i)
                            ForearmValues.insert(self.tempDict["forearm"][i]["forearm"].doubleValue, at: i)
                        }
                        
                        
                        self.setChart(dataPoints: daysWaist,values: WaistValues, type: 1)
                        
                        self.setChart(dataPoints: daysHips,values: HipsValues, type: 2)
                        
                        self.setChart(dataPoints: daysWrist,values: WristValues, type: 3)
                        
                        self.setChart(dataPoints: daysForearm,values: ForearmValues, type: 4)
                        
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
        
        if(date_from! < date_to!)
        {
            daysWaist = []
            daysHips = []
            daysWrist = []
            daysForearm = []
            
            WaistValues = []
            HipsValues = []
            WristValues = []
            ForearmValues = []
            
            self.setChart(dataPoints: days,values: WaistValues, type: 1)
            self.setChart(dataPoints: days,values: HipsValues, type: 2)
            self.setChart(dataPoints: days,values: WristValues, type: 3)
            self.setChart(dataPoints: days,values: ForearmValues, type: 4)
            
            loadMeasurementsData(From_date: dateFormatter.string(from: date_from!), To_date: dateFormatter.string(from: date_to!))
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
