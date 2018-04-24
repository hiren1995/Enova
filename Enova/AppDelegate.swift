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
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?

    var storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //-------------------------------- Making app register for Remotw Notification --------------------------------------
        
        if #available(iOS 10.0, *) {
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
            
            
        } else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            
        }
        
        application.registerForRemoteNotifications()
        
        //-------------------------------------------------------------------------------------------------------------------
        
        
        
        FirebaseApp.configure()
        
        
        
        //----------------------------- Launching application from notification touch or by simple opening application from panel----------------------------
        
        if (launchOptions?[.remoteNotification] as? [String: AnyObject]) != nil
        {
            // Parse Notification Data
            let launchDict = launchOptions! as NSDictionary
            let userInfo = launchDict.object(forKey: UIApplicationLaunchOptionsKey.remoteNotification) as? NSDictionary
            
            let aps = userInfo?["gcm.notification.data"] as? String
            // print(aps)
            
            let data = aps?.data(using: .utf8)
            
            var jsonDictionary : NSDictionary = [:]
            do {
                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
            } catch {
                print(error)
            }
            print(jsonDictionary)
            let strType = jsonDictionary["notification_from"] as? String
            if strType == "receive_message"
            {
                
                let chatScreenView = storyboard.instantiateViewController(withIdentifier: "chatScreenView") as! ChatScreenView
                self.window?.rootViewController = chatScreenView
            }
            else{
                
                let notificationView = storyboard.instantiateViewController(withIdentifier: "notificationView") as! NotificationView
                self.window?.rootViewController = notificationView
            }
        }
        else
        {
            let Login = UserDefaults.standard.bool(forKey: isLogin)
            
            if Login{
                
                if let fcmToken = UserDefaults.standard.value(forKey: DeviceToken)
                {
                    //for version 1 the fcm token is nil so it would crash when we need to get fcm token from userdefault so this code helps in saving app from crashing..!
                    
                    print(fcmToken)
                    
                    //let loginParameters:Parameters = ["email": udefault.value(forKey: EmailAddress)! , "password" : udefault.value(forKey: Password)! , "device_token" : "" , "device_type" : 2]
                    let loginParameters:Parameters = ["email": udefault.value(forKey: EmailAddress)! , "password" :  udefault.value(forKey: Password)! , "device_token" : udefault.value(forKey: DeviceToken)! , "device_type" : 2]
                    
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
                }
                else
                {
                    print("nil")
                    let initialView = self.storyboard.instantiateViewController(withIdentifier: "signIn") as! SignIn
                    self.window?.rootViewController = initialView
                }
                
                
                
            }
            else
            {
                let initialView = storyboard.instantiateViewController(withIdentifier: "signIn") as! SignIn
                self.window?.rootViewController = initialView
            }
            
        }
        
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    //--------------------------------------- Push Notification module Start ---------------------------------------------------------------------------------------------------
    
    
    //To get Device Token or Firebase Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        // FCM Token
        if let refreshedToken = InstanceID.instanceID().token(){
            print("InstanceID token: \(refreshedToken)")
            
            let device_id = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
            print("The device Token is = \(device_id)")
            
            udefault.set(refreshedToken, forKey: DeviceToken)
            
        }
        connectToFcm()
        
    }
    
    func connectToFcm() {
        
        Messaging.messaging().connect{ (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
                
            } else {
                print("Connected to FCM.")
                //self.Authenicate()
            }
        }
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")
        
        udefault.set(fcmToken, forKey: DeviceToken)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        print(JSON(userInfo))
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Print full message.
        print(JSON(userInfo))
        
    }
    
    
    //Called if unable to register for APNS.
    private func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        let aps = userInfo["gcm.notification.data"] as? String
        // print(aps)
        
        let data = aps?.data(using: .utf8)
        
        var jsonDictionary : NSDictionary = [:]
        do {
            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
        } catch {
            print(error)
        }
        print("Notification Data is:\(jsonDictionary)")
        
        let strType = jsonDictionary["notification_from"] as? String
        if strType == "receive_message"{
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MessageNotification"), object: jsonDictionary)
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notification"), object: jsonDictionary)
        }
        
        
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    //--------------------------------------- Push Notification module End ---------------------------------------------------------------------------------------------------
    


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

