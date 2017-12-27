//
//  FoodLogView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 26/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit

class FoodLogView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var HeaderView: UIView!
    
    @IBOutlet var MenuView: UIView!
    
    @IBOutlet weak var txtFrom: UITextField!
    
    @IBOutlet weak var txtTo: UITextField!
    
    @IBOutlet weak var foodLogTableView: UITableView!
    
    let foodType = ["Meal","Snack","Meal","Snack","Meal","Snack","Meal","Snack"]
    let date = ["Today,10:00 AM","Today,2:00 PM","Today,10:00 AM","Today,2:00 PM","Today,10:00 AM","Today,2:00 PM","Today,10:00 AM","Today,2:00 PM"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HeaderView.ShadowHeader()
        MenuView.menuViewBorder()
        MenuView.isHidden = true
        
        addDoneButtonOnDatePicker()
        
        foodLogTableView.delegate = self
        foodLogTableView.dataSource = self
        
        foodLogTableView.allowsSelection = false

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return foodType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodlogcell") as! FoodLogTableCell
        
        cell.MealType.text = foodType[indexPath.row]
        cell.DateTime.text = date[indexPath.row]
        cell.btnView.addTarget(self, action: #selector(openFoodLogInfo), for: .touchUpInside)
        cell.btnViewbig.addTarget(self, action: #selector(openFoodLogInfo), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
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
