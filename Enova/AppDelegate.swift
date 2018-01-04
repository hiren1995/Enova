//
//  AppDelegate.swift
//  Enova
//
//  Created by APPLE MAC MINI on 12/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
            let Login = UserDefaults.standard.bool(forKey: isLogin)
        
            if Login{
                
                let loginParameters:Parameters = ["email": udefault.value(forKey: EmailAddress)! , "password" : udefault.value(forKey: Password)! , "device_token" : "" , "device_type" : 2]
                
                print(loginParameters)
                
                Alamofire.request(LoginAPI, method: .post, parameters: loginParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    if(response.result.value != nil)
                    {
                        
                        print(JSON(response.result.value))
                        
                        let tempDict = JSON(response.result.value!)
                        
                        //print(tempDict["data"]["user_id"])
                        
                        if(tempDict["status"] == "success")
                        {
                            udefault.set(response.result.value, forKey: UserData)
                          
                            
                            //let initialView = self.storyboard.instantiateViewController(withIdentifier: "dashBoard") as! DashBoard
                            //self.window?.rootViewController = initialView
                        }
                        else if(tempDict["status"] == "error")
                        {
                            self.window?.rootViewController?.showAlert(title: "Alert", message: "Invalid Email or Password")
                            let initialView = self.storyboard.instantiateViewController(withIdentifier: "signIn") as! SignIn
                            self.window?.rootViewController = initialView
                        }
                        
                    }
                    else
                    {
                        self.window?.rootViewController?.showAlert(title: "Alert", message: "Please Check Your Internet Connection")
                        
                    }
                })

                //let initialView = storyboard.instantiateViewController(withIdentifier: "dashBoard") as! DashBoard
                //self.window?.rootViewController = initialView
                
            }
            else
            {
                let initialView = storyboard.instantiateViewController(withIdentifier: "signIn") as! SignIn
                self.window?.rootViewController = initialView
            }
        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

