//
//  DashBoard.swift
//  Enova
//
//  Created by APPLE MAC MINI on 16/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit



class DashBoard: UIViewController{
    
    @IBOutlet var HeaderView: UIView!
   
    @IBOutlet var MenuView: UIView!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        HeaderView.ShadowHeader()                                       //pls check the CustomClass.swift file for this methods defined..
        
        MenuView.menuViewBorder()

        MenuView.isHidden = true
        
        
        
        // Do any additional setup after loading the view.
    }
   
    @IBAction func btnMenuPress(_ sender: Any) {
       
        MenuView.menuClicked()
        
    }
    
    
    @IBAction func btnGlucose(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let glucoseView = storyboard.instantiateViewController(withIdentifier: "glucoseView") as! GlucoseView
        
        self.present(glucoseView, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnKetones(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let ketonesView = storyboard.instantiateViewController(withIdentifier: "ketonesView") as! KetonesView
        
        self.present(ketonesView, animated: true, completion: nil)
    }
   
    @IBAction func btnWeight(_ sender: Any) {
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let weightView = storyboard.instantiateViewController(withIdentifier: "weightView") as! WeightView
        
        self.present(weightView, animated: true, completion: nil)
    }
    
    @IBAction func btnMeasurements(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let measurementsView = storyboard.instantiateViewController(withIdentifier: "measurementsView") as! MeasurementsView
        
        self.present(measurementsView, animated: true, completion: nil)
    }
    
    @IBAction func btnFoodLog(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let foodLogView = storyboard.instantiateViewController(withIdentifier: "foodLogView") as! FoodLogView
        
        self.present(foodLogView, animated: true, completion: nil)
        
    }
    
    @IBAction func btnProfile(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let profileSettingView = storyboard.instantiateViewController(withIdentifier: "profileSettingView") as! ProfileSettingView
        
        self.present(profileSettingView, animated: true, completion: nil)
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
