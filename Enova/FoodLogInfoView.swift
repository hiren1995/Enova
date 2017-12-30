//
//  FoodLogInfoView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 27/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import MBProgressHUD

class FoodLogInfoView: UIViewController {

    @IBOutlet var HeaderView: UIView!
    
    @IBOutlet var MenuView: UIView!
    
    @IBOutlet weak var NoteView: UIView!
 
    @IBOutlet weak var lblMealType: UILabel!
    
    @IBOutlet weak var txtNote: UITextView!
  
    @IBOutlet weak var foodImg: UIImageView!
    
    @IBOutlet weak var ImgCover: UIView!
   
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HeaderView.ShadowHeader()                                       //pls check the CustomClass.swift file for this methods defined..
        MenuView.menuViewBorder()
        MenuView.isHidden = true
        NoteView.setborder(colorValue: UIColor.lightGray)
        NoteView.roundCorners(value: 5)
        
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnMenuPress(_ sender: Any) {
        
        MenuView.menuClicked()
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBack2(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadData()
    {
        txtNote.text = foodNote_global
        lblMealType.text = foodCategory_global
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.date(from: foodCreatedAt_global!)
        
        print(date)
        
        let normalDateFormatter = DateFormatter()
        normalDateFormatter.dateStyle = .long
        normalDateFormatter.timeStyle = .medium
        
        let tempDateStr = normalDateFormatter.string(from: date!)
        
        let tempDateArray = tempDateStr.components(separatedBy: "at")
        
        lblDate.text = tempDateArray[0]
        lblTime.text = tempDateArray[1]
        
        
        
        KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: foodImgPath + foodImage_global!)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
            
            if(error == nil)
            {
                self.foodImg.image = image
                self.ImgCover.isHidden = true
            }
            else
            {
                self.showAlert(title: "Alert", message: "Something Went Wrong while downloading Profile Image")
            }
            
        })
        
    }
    
    
    @IBAction func deleteLog(_ sender: Any) {
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let removeLogParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "food_log_id" : foodId_global!]
        
        Alamofire.request(RemoveFoodLogAPI, method: .post, parameters: removeLogParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                
                print(JSON(response.result.value))
                
                let tempDict = JSON(response.result.value!)
                
                //print(tempDict["data"]["user_id"])
                
                if(tempDict["status"] == "success")
                {
                    spinnerActivity.hide(animated: true)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let foodLogView = storyboard.instantiateViewController(withIdentifier: "foodLogView") as! FoodLogView
                    
                    self.present(foodLogView, animated: true, completion: nil)
                }
                else if(tempDict["status"] == "error")
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
