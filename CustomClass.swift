//
//  CustomClass.swift
//  Enova
//
//  Created by APPLE MAC MINI on 21/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import Foundation
import UIKit
import Charts

class CustomClass: NSObject {
    
}

extension UIView {
    
    func ShadowHeader(scale: Bool = true) {
        
       
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        //self.layer.shouldRasterize = true  //never use set this to true...the addnewvalue view had bulr text due to this
    }
    
    func menuClicked()
    {
        if MenuClicked
        {
            MenuClicked = false
            self.isHidden = true
        }
        else
        {
            MenuClicked = true
            self.isHidden = false
            self.layer.zPosition = 1
        }
    }
    
    func menuViewBorder(scale: Bool = true)
    {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
    
    func roundCorners(value : Float)
    {
        self.layer.cornerRadius = CGFloat(value)
        self.clipsToBounds = true
    }
    
}

extension UIViewController{
    
    func showAlert(title: String , message : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension LineChartView{
    
    
    func MakeLineGraph(line : LineChartDataSet , circleColors : [NSUIColor] , labelText : String)
    {
        let data = LineChartData()
        data.addDataSet(line)
        
        self.data = data
        self.chartDescription?.text = labelText
        
        self.xAxis.labelTextColor = UIColor.clear   //to make the text color clear means we cannot see the values at x axis...
        
        line.colors = [NSUIColor.black]        //making all lines colours to one specific color
        //line1.colors = circleColors           //for diffrent colors in line formed between points....
        
        
        line.circleColors = circleColors           //for different colors of circle borders...
        //line1.circleColors = [NSUIColor.orange]   //making all circle borders in line graph to single color
        
        
        line.drawCircleHoleEnabled = false         //enabling the hole in the circle...
        //line1.circleHoleColor = NSUIColor.red     //setting the color of the circle hole..
        
        
        self.animate(xAxisDuration: 2.0)
        
        //lineChatView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
    }
    
}

extension UIButton{
    
    func NavigateToNext(nextVC : UIViewController)
    {
        
    }
}

