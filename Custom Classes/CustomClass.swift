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
    
    func ShadowMealView(scale: Bool = true) {
        
        
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 5.0
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
    
    func mealClicked()
    {
        if MealClicked
        {
            MealClicked = false
            self.isHidden = true
        }
        else
        {
            MealClicked = true
            self.isHidden = false
            self.layer.zPosition = 1
            
        }
    }
    
    func diabetesClicked()
    {
        if DiabetesClicked
        {
            DiabetesClicked = false
            self.isHidden = true
        }
        else
        {
            DiabetesClicked = true
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
    
    func setborder(colorValue : UIColor)
    {
        self.layer.borderColor = colorValue.cgColor
        self.layer.borderWidth = 1
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
    
    func fromRight()
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    func fromLeft()
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
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
        
        line.circleRadius = 5.0
        
        self.animate(xAxisDuration: 2.0)
        
        //lineChatView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
    }
    
}

extension UIButton{
    
   
    func setbuttonborder(colorValue: UIColor,widthValue: CGFloat,cornerRadiusValue : CGFloat) {
        
        self.layer.borderColor = colorValue.cgColor
        self.layer.borderWidth = widthValue
        self.layer.cornerRadius = cornerRadiusValue
    }
}

extension UIImageView{
    func setImageborder(colorValue: UIColor,widthValue: CGFloat,cornerRadiusValue : CGFloat) {
       
        self.layer.borderColor = colorValue.cgColor
        self.layer.borderWidth = widthValue
        self.layer.cornerRadius = cornerRadiusValue
        self.clipsToBounds = true
    }
    
    func removeImageborder()
    {
        self.layer.borderWidth = 0.0
        self.clipsToBounds = true
    }
    
}
extension Date {
    var currentTimeStamp: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

extension UITableView{
    
    func setTableShadow()
    {
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
    func extractURLs() -> [URL] {
        var urls : [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.characters.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                    urls.append(url)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
}

func convertDateFormater(_ date: String) -> String
{
    let dateFormatter = DateFormatter()
    //dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return  dateFormatter.string(from: date!)
    
}

func dateLanguageFormat(DateValue : Date) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.doesRelativeDateFormatting = true
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mm a"
    
    return "\(dateFormatter.string(from: DateValue)), \(timeFormatter.string(from: DateValue))"
}

func minDate()->Date
{
    let calendar = Calendar.current
    var minDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
    minDateComponent.day = 01
    minDateComponent.month = 01
    minDateComponent.year = 1980
    let minDate = calendar.date(from: minDateComponent)
    
    return minDate!
}


func encodeEmojiMsg(_ s: String) -> String {
    let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
    return String(data: data, encoding: .utf8)!
}

func decodeEmojiMsg(_ s: String) -> String? {
    let data = s.data(using: .utf8)!
    return String(data: data, encoding: .nonLossyASCII)
}


