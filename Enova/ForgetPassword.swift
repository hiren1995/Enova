//
//  ForgetPassword.swift
//  Enova
//
//  Created by APPLE MAC MINI on 13/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ForgetPassword: UIViewController,UITextFieldDelegate {

    @IBOutlet var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtEmail.delegate = self
        
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func btnRequest(_ sender: Any) {
        
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        let ForgetPasswordParameters:Parameters = ["email": txtEmail.text!]
        
        
        Alamofire.request( ForgetPasswordAPI, method: .post, parameters: ForgetPasswordParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                
                print(JSON(response.result.value))
                
                let tempDict = JSON(response.result.value!)
                
                //print(tempDict["data"]["user_id"])
                
                if(tempDict["status"] == "success")
                {
                    spinnerActivity.hide(animated: true)
                    
                    let ForgetPasswordAlert = UIAlertController(title: "Success", message: tempDict["msg"].stringValue, preferredStyle: UIAlertControllerStyle.alert)
                    
                    ForgetPasswordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let signIn = storyboard.instantiateViewController(withIdentifier: "signIn") as! SignIn
                        //self.present(signIn, animated: true, completion: nil)
                        
                        self.fromLeft()
                        self.present(signIn, animated: true, completion: nil)
                        
                    }))
                    
                    
                    self.present(ForgetPasswordAlert, animated: true, completion: nil)
                }
                else if(tempDict["status"] == "error")
                {
                    spinnerActivity.hide(animated: true)
                    self.showAlert(title: "Alert", message: "User not registered to use this Application")
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
