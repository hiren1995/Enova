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
        UIApplication.shared.keyWindow?.bringSubview(toFront: MenuView)
    }
    
    
    @IBAction func btnGlucose(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let glucoseView = storyboard.instantiateViewController(withIdentifier: "glucoseView") as! GlucoseView
        self.fromRight()
        self.present(glucoseView, animated: false, completion: nil)
        
    }
    
    @IBAction func btnKetones(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ketonesView = storyboard.instantiateViewController(withIdentifier: "ketonesView") as! KetonesView
        self.fromRight()
        self.present(ketonesView, animated: false, completion: nil)
    }
   
    @IBAction func btnWeight(_ sender: Any) {
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let weightView = storyboard.instantiateViewController(withIdentifier: "weightView") as! WeightView
        self.fromRight()
        self.present(weightView, animated: false, completion: nil)
    }
    
    @IBAction func btnMeasurements(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let measurementsView = storyboard.instantiateViewController(withIdentifier: "measurementsView") as! MeasurementsView
        self.fromRight()
        self.present(measurementsView, animated: false, completion: nil)
    }
    
    @IBAction func btnFoodLog(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let foodLogView = storyboard.instantiateViewController(withIdentifier: "foodLogView") as! FoodLogView
        self.fromRight()
        self.present(foodLogView, animated: false, completion: nil)
        
    }
    
    @IBAction func btnProfile(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileSettingView = storyboard.instantiateViewController(withIdentifier: "profileSettingView") as! ProfileSettingView
        self.fromRight()
        self.present(profileSettingView, animated: false, completion: nil)
    }
    
    @IBAction func btnLogoutPress(_ sender: Any) {
        
        let LogoutAlert = UIAlertController(title: "Logout", message: "Are You Sure You Want To Logout.", preferredStyle: UIAlertControllerStyle.alert)
        
        LogoutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            udefault.set(false, forKey: isLogin)
            udefault.removeObject(forKey: UserId)
            udefault.removeObject(forKey: EmailAddress)
            udefault.removeObject(forKey: Password)
            udefault.removeObject(forKey: UserData)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signIn = storyboard.instantiateViewController(withIdentifier: "signIn") as! SignIn
            self.fromLeft()
            self.present(signIn, animated: false, completion: nil)
            
        }))
        
        LogoutAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (action: UIAlertAction!) in
            
            print("Logout Cancelled")
            
        }))
        
        present(LogoutAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnChat(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatScreenOutlineView = storyboard.instantiateViewController(withIdentifier: "chatScreenOutlineView") as! ChatScreenOutlineView
        self.fromRight()
        self.present(chatScreenOutlineView, animated: false, completion: nil)
    }
    @IBAction func btnNotification(_ sender: UIButton) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let notificationView = storyboard.instantiateViewController(withIdentifier: "notificationView") as! NotificationView
        self.fromRight()
        self.present(notificationView, animated: false, completion: nil)
    }
    
    @IBAction func btnFasting(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fastingView = storyboard.instantiateViewController(withIdentifier: "fastingView") as! FastingView
        self.fromRight()
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
