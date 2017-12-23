//
//  GlucoseView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 21/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Charts

var  days:[Int] = []
var  GlucoseValues:[Double] = []

class GlucoseView: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var HeaderView: UIView!
    
    @IBOutlet var MenuView: UIView!
    
    
    @IBOutlet weak var newDataAddView: UIView!
    
    @IBOutlet weak var AlphaView: UIView!
    
    
    @IBOutlet weak var lineChatView: LineChartView!
    
    
    @IBOutlet weak var txtNewValue: UITextField!
    
    
    @IBOutlet weak var lblHighGlucose: UILabel!
    
    
    @IBOutlet weak var lblLowGlucose: UILabel!
    
    
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
        GlucoseValues = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0,17.0]
        
        setChart(dataPoints: days,values: GlucoseValues)
        
        lblHighGlucose.text = String(describing: GlucoseValues.max()!)
        lblLowGlucose.text = String(describing: GlucoseValues.min()!)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnMenuPress(_ sender: Any) {
        
        MenuView.menuClicked()
    
        
    }
    
    
    func setChart(dataPoints: [Int] , values: [Double])
    {
        var circleColors: [NSUIColor] = []
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0...dataPoints.count - 1
        {
           
            if(values[i] >= 12.0)
            {
                circleColors.append(NSUIColor.red)
            }
            else
            {
                circleColors.append(NSUIColor.green)
                
            }
            
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i] )
            
            dataEntries.append(dataEntry)
            
            
        }
        
        let line1 = LineChartDataSet(values: dataEntries, label: "Glucose")
        
        
        lineChatView.MakeLineGraph(line: line1, circleColors: circleColors, labelText: "Glucose Graph")   // for Make Graph method check the CustomClass.swift
        
    }

    @IBAction func btnAdd(_ sender: Any) {
        
        AlphaView.isHidden = false
        newDataAddView.isHidden = false
        newDataAddView.layer.zPosition = 1
        //AlphaView.bringSubview(toFront: newDataAddView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        
        AlphaView.isHidden = true
        newDataAddView.isHidden = true
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        if(txtNewValue.text == "")
        {
            self.showAlert(title: "Alert", message: "Please Enter Glucose Level")
        }
        else
        {
            days.append(days.count+1)
            GlucoseValues.append(Double(txtNewValue.text!)!)
            newDataAddView.isHidden = true
            AlphaView.isHidden = true
            setChart(dataPoints: days,values: GlucoseValues)
            lblHighGlucose.text = String(describing: GlucoseValues.max()!)
            lblLowGlucose.text = String(describing: GlucoseValues.min()!)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
