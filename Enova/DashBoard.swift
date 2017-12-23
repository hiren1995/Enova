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
        
        self.performSegue(withIdentifier: "DashboardToGlucose", sender: nil)
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
