//
//  NotificationView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 20/03/18.
//  Copyright © 2018 APPLE MAC MINI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD
import Kingfisher
import ActiveLabel


class NotificationView: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var NotificationTable: UITableView!
    
    var tempDict = JSON()
    
    let noti = ["Notificartion1","Notificartion2","Notificartion3","Notificartion4","Notificartion5"]
    
    let date = ["jan 18 2018","jan 18 2018","jan 18 2018","jan 18 2018","jan 18 2018"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: NSNotification.Name("Notification"), object: nil)
        
        
        NotificationTable.delegate = self
        NotificationTable.dataSource = self
        
        NotificationTable.allowsSelection = false
        self.NotificationTable.estimatedRowHeight = 150
        self.NotificationTable.rowHeight = UITableViewAutomaticDimension
        
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return 5
        return tempDict["data"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = NotificationTable.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationTableCell
        
        //cell.lblNotificationTitle.text = noti[indexPath.row]
        //cell.lblNotificationDate.text = date[indexPath.row]
        
        let date = Date(timeIntervalSince1970:  (tempDict["data"][indexPath.row]["time"].doubleValue / 1000.0))
        
        cell.lblNotificationTitle.enabledTypes = [.url]
        cell.lblNotificationTitle.text = tempDict["data"][indexPath.row]["message"].stringValue
        cell.lblNotificationTitle.URLColor = UIColor.blue
        cell.lblNotificationTitle.handleURLTap {
            
            //self.showAlert(title: "Open URL", message: $0.absoluteString)
            
            let urlString = $0.absoluteString
            var openURL = $0.absoluteURL
            
            let LogoutAlert = UIAlertController(title: "Open URL", message: "Are You Sure You Want To open Link.\(urlString)", preferredStyle: UIAlertControllerStyle.alert)
            
            LogoutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                
                /*
                guard let url = URL(string: urlString) else {
                    return //be safe
                }
                */
               
                if urlString.hasPrefix("http://")
                {
                    openURL = URL(string: urlString)!
                }
                else if urlString.hasPrefix("https://")
                {
                    openURL = URL(string: urlString)!
                }
                else
                {
                    openURL = URL(string: "https://" + urlString)!
                }
               
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(openURL)
                }

                
            }))
            
            LogoutAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (action: UIAlertAction!) in
                
                print("open url Cancelled")
                
            }))
            
            self.present(LogoutAlert, animated: true, completion: nil)
            
        }
        
       
        //cell.lblNotificationTitle.sizeToFit()
        //cell.lblNotificationTitle.translatesAutoresizingMaskIntoConstraints = true
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .medium
        let datestr = dateformatter.string(from: date)
        cell.lblNotificationDate.text = datestr
        
        cell.imgNotification.layer.cornerRadius = 30
        
        if(tempDict["data"][indexPath.row]["image"] != JSON.null)
        {
            KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: "\(notificationImgPath)/\(tempDict["data"][indexPath.row]["image"].stringValue)")! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
                
                
                cell.imgNotification.image = image
                
            })
            
        }
        
        
        return cell
        
    }
    
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
   {
     return UITableViewAutomaticDimension
    }

  
    
    func loadData()
    {
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let getNotificationParameters:Parameters = ["user_id": udefault.value(forKey: UserId)!]
        
        Alamofire.request(GetNotificationAPI, method: .post, parameters: getNotificationParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                
                print(JSON(response.result.value))
                
                self.tempDict = JSON(response.result.value!)
                
                //print(tempDict["data"]["user_id"])
                
                if(self.tempDict["status"] == "success")
                {
                    self.NotificationTable.reloadData()
                    
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
    
    
    @IBAction func btnBack1(_ sender: UIButton) {
        
        //self.dismiss(animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let dashBoard = storyboard.instantiateViewController(withIdentifier: "dashBoard") as! DashBoard
        
        self.fromLeft()
        
        //self.present(dashBoard, animated: true, completion: nil)
        
        self.present(dashBoard, animated: false, completion: nil)
    }
    @IBAction func btnBack2(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let dashBoard = storyboard.instantiateViewController(withIdentifier: "dashBoard") as! DashBoard
        
        self.fromLeft()
        
        //self.present(dashBoard, animated: true, completion: nil)
        
        self.present(dashBoard, animated: false, completion: nil)
    }
    
    
    @objc func notificationReceived (notification : NSNotification)
    {
        print(notification)
        print("Notification Received")
        
        /*
         let dataDic = notification.object as? NSDictionary
         let fromId = dataDic?["chat_random_id"] as? String
         print("Notification Chat Random id:\(fromId)")
         print("Chat Random Id is:\(strChatRandomID)")
         if fromId == strChatRandomID
         {
         getAllMessages()
         }
         
         */
        
       loadData()
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
