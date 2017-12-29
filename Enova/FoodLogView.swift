//
//  FoodLogView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 26/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class FoodLogView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var HeaderView: UIView!
    
    @IBOutlet var MenuView: UIView!
    
    @IBOutlet weak var txtFrom: UITextField!
    
    @IBOutlet weak var txtTo: UITextField!
    
    @IBOutlet weak var foodLogTableView: UITableView!
    
    var foodLogCount:Int = 0
    var tempDict : JSON = JSON.null
    
    //let foodType = ["Meal","Snack","Meal","Snack","Meal","Snack","Meal","Snack"]
    //let date = ["Today,10:00 AM","Today,2:00 PM","Today,10:00 AM","Today,2:00 PM","Today,10:00 AM","Today,2:00 PM","Today,10:00 AM","Today,2:00 PM"]
    
    var foodType:[String]? = nil
    var date:[String]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HeaderView.ShadowHeader()
        MenuView.menuViewBorder()
        MenuView.isHidden = true
        
        addDoneButtonOnDatePicker()
        
        foodLogTableView.delegate = self
        foodLogTableView.dataSource = self
        
        foodLogTableView.allowsSelection = false
        
        loadFoodLogs()

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return foodLogCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodlogcell") as! FoodLogTableCell
        
        //cell.MealType.text = foodType?[indexPath.row]
        //cell.DateTime.text = date?[indexPath.row]
        
        if(tempDict.count != 0)
        {
        cell.MealType.text = tempDict["data"][indexPath.row]["food_category"].stringValue
        cell.DateTime.text = tempDict["data"][indexPath.row]["created_at"].stringValue
        }
        
        cell.btnView.addTarget(self, action: #selector(openFoodLogInfo), for: .touchUpInside)
        cell.btnViewbig.addTarget(self, action: #selector(openFoodLogInfo), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat(20)
    }
    
    @IBAction func btnMenuPress(_ sender: Any) {
        
        MenuView.menuClicked()
        
        
    }
    
    
    @IBAction func btnAdd(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let addFoodLogView = storyboard.instantiateViewController(withIdentifier: "addFoodLogView") as! AddFoodLogView
        
        self.present(addFoodLogView, animated: true, completion: nil)
        
    }
    
    @objc func openFoodLogInfo()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let foodLogInfoView = storyboard.instantiateViewController(withIdentifier: "foodLogInfoView") as! FoodLogInfoView
        
        self.present(foodLogInfoView, animated: true, completion: nil)
        
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
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        txtFrom.text = convertDateFormater(dateFormatter.string(from: sender.date))
        
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
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        txtTo.text = convertDateFormater(dateFormatter.string(from: sender.date))
        
    }
    //---------------------------------------------- End ------------------------------------------------------------------------------
    
    
    //-------------------------------  code for closing key borad on click of return key ----------------------------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
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
    
    func loadFoodLogs()
    {
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
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        txtFrom.text = from_date
        txtTo.text = to_date
        
        
        let foodLogParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "from_date" : from_date , "to_date" : to_date+"23:59:59"]
        
        print(foodLogParameters)
        
        Alamofire.request(GetFoodLogAPI, method: .post, parameters: foodLogParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                
                print(JSON(response.result.value))
                
                self.tempDict = JSON(response.result.value!)
                
                //print(tempDict["data"]["user_id"])
                
                if(self.tempDict["status"] == "success")
                {
                    self.foodLogCount = self.tempDict["data"].count
                    
                    //print(self.tempDict["data"][0]["food_category"].stringValue)
                    //print(self.tempDict["data"][0]["food_category"].stringValue)
                   
                    
                    self.foodLogTableView.reloadData()
                    
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
