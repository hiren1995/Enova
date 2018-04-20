//
//  SignIn.swift
//  Enova
//
//  Created by APPLE MAC MINI on 13/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class SignIn: UIViewController,UITextFieldDelegate {

    
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var ScrollInnerView: UIView!
    
    @IBOutlet weak var copyright: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //NotificationCenter.default.addObserver(self , selector: #selector(loadMessages), name: "MessageNotification", object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(messageReceived(notification:)), name: NSNotification.Name("MessageNotification"), object: nil)
        
        
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        let bounds = UIScreen.main.bounds
        let height  = bounds.height
        print(height)
        
        /*
        if(height == 667)
        {
            copyright.translatesAutoresizingMaskIntoConstraints = false
            let bottomContraint = NSLayoutConstraint(item: copyright, attribute: NSLayoutAttribute.bottom , relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute:NSLayoutAttribute.bottomMargin, multiplier: 1, constant: 30)
            NSLayoutConstraint.activate([bottomContraint])
        }
        */
 
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func btnForgetPassword(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let forgetPassword = storyboard.instantiateViewController(withIdentifier: "forgetPassword") as! ForgetPassword
        
        //self.present(forgetPassword, animated: true, completion: nil)
        
        self.fromRight()
        self.present(forgetPassword, animated: false, completion: nil)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
        if(txtEmail.text == "")
        {
            self.showAlert(title: "Alert", message: "Please Enter Email")
        }
        else if(txtPassword.text == "")
        {
            self.showAlert(title: "Alert", message: "Please Enter Password")
        }
        else
        {
            if isValidEmail(testStr: txtEmail.text!)
            {
                udefault.set(txtEmail.text!, forKey: EmailAddress)
                udefault.set(txtPassword.text!, forKey: Password)
                
                print(udefault.value(forKey: EmailAddress))
                print(udefault.value(forKey: Password))
                
                Authentication()
            }
            else
            {
                self.showAlert(title: "Alert", message: "Please Enter Proper Email Address")
            }
        }
       
    }
    
    func Authentication()
    {
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        let loginParameters:Parameters = ["email": txtEmail.text! , "password" : txtPassword.text! , "device_token" : "" , "device_type" : 2]
        //let loginParameters:Parameters = ["email": txtEmail.text! , "password" : txtPassword.text! , "device_token" : udefault.value(forKey: DeviceToken)! , "device_type" : 2]
        
        
        Alamofire.request(LoginAPI, method: .post, parameters: loginParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                
                print(JSON(response.result.value))
                
                let tempDict = JSON(response.result.value!)
                
                //print(tempDict["data"]["user_id"])
                
                if(tempDict["status"] == "success")
                {
                    udefault.set(true, forKey: isLogin)
                    
                    udefault.set(tempDict["data"]["user_id"].intValue, forKey: UserId)
                    
                    udefault.set(response.result.value, forKey: UserData)
                   
                    spinnerActivity.hide(animated: true)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let dashBoard = storyboard.instantiateViewController(withIdentifier: "dashBoard") as! DashBoard
                    
                    self.fromRight()
                    
                    //self.present(dashBoard, animated: true, completion: nil)
                    
                    self.present(dashBoard, animated: false, completion: nil)
                }
                else if(tempDict["status"] == "error")
                {
                    spinnerActivity.hide(animated: true)
                    self.showAlert(title: "Alert", message: "Invalid Email or Password")
                }
                
            }
            else
            {
                spinnerActivity.hide(animated: true)
                self.showAlert(title: "Alert", message: "Please Check Your Internet Connection")
            }
        })
        
        
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    /*
    func messageReceived (notification : NSNotification)
    {
        print(notification)
        print("Notification Received")
        
        let dataDic = notification.object as? NSDictionary
        let fromId = dataDic?["chat_random_id"] as? String
        print("Notification Chat Random id:\(fromId)")
        print("Chat Random Id is:\(strChatRandomID)")
        if fromId == strChatRandomID
        {
            getAllMessages()
        }
    }
    */
    
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
