//
//  AddFoodLogView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 26/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CropViewController
import MBProgressHUD

class AddFoodLogView: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate {

    
    @IBOutlet var HeaderView: UIView!
    
    @IBOutlet var MenuView: UIView!
    
    @IBOutlet weak var NoteView: UIView!
    
    @IBOutlet weak var NoteText: UITextView!
    
    @IBOutlet weak var btnMealChoose: UIButton!
    
    @IBOutlet weak var lblFoodLabel: UILabel!
    
    @IBOutlet weak var MealSelectView: UIView!
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var foodImg: UIImageView!
    
    @IBOutlet weak var coverImg: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HeaderView.ShadowHeader()
        MenuView.menuViewBorder()
        MenuView.isHidden = true
        NoteView.setborder(colorValue: UIColor.lightGray)
        NoteView.roundCorners(value: 5)
        btnMealChoose.setbuttonborder(colorValue: UIColor.black, widthValue: 1.0, cornerRadiusValue: 0)
        MealSelectView.isHidden = true
        MealSelectView.ShadowMealView()
        
        foodImg.setImageborder(colorValue: UIColor.gray, widthValue: 1.0, cornerRadiusValue: 5.0)
        
        addDoneButtonOnKeyboard()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnMenuPress(_ sender: Any) {
        /*
        MenuView.menuClicked()
        */
    }
    
    
    @IBAction func btnMealSelectPress(_ sender: Any) {
        MealSelectView.mealClicked()
    }
    
    
    @IBAction func btnMeal(_ sender: Any) {
        
           lblFoodLabel.text = "Meal"
           MealSelectView.isHidden = true
           MealClicked = false
    }
   
    
    @IBAction func btnSnacks(_ sender: Any) {
        
        lblFoodLabel.text = "Snacks"
        MealSelectView.isHidden = true
        MealClicked = false
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
       
        NoteText.text = nil
        NoteText.textColor = UIColor.black
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if NoteText.text.isEmpty
        {
            NoteText.text = "Enter your note here..."
           
            NoteText.textColor = UIColor.lightGray
        }
    }

    func addDoneButtonOnKeyboard()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelKeyboard))
        
        var items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as! [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        //txtTo.inputAccessoryView = doneToolbar
        //txtFrom.inputAccessoryView = doneToolbar
        
        NoteText.inputAccessoryView = doneToolbar
        
    }
    @objc func cancelKeyboard(){
        self.view.endEditing(true)
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let foodLogView = storyboard.instantiateViewController(withIdentifier: "foodLogView") as! FoodLogView
        
        self.present(foodLogView, animated: true, completion: nil)
    }
    
    @IBAction func btnBack2(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let foodLogView = storyboard.instantiateViewController(withIdentifier: "foodLogView") as! FoodLogView
        
        self.present(foodLogView, animated: true, completion: nil)
    }

    
    //---------------------------------- Code for adjusting view depending upon the keyboard open and close...------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y -= 150
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y += 150
        
    }
    
    //-------------------------------------------------------- End -----------------------------------------------------------------------------------------
    
    @IBAction func addFoodLog(_ sender: Any) {
        
        if(foodImg.image == nil)
        {
            self.showAlert(title: "Alert", message: "Please Select Food Image")
        }
        else if(NoteText.text == nil)
        {
            self.showAlert(title: "Alert", message: "Please Enter Note for Food")
        }
        else
        {
            let imgData = UIImageJPEGRepresentation(foodImg.image!, 0.5)
            
            let timeStamp = String(Date().currentTimeStamp)
            
            let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let updateParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "food_category" : lblFoodLabel.text! , "timestamp" : timeStamp , "food_note" : NoteText.text]
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in updateParameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if let data = imgData{
                    
                    multipartFormData.append(data, withName: "food_image", fileName: "image.jpg", mimeType: "image/jpg")
                    
                }
                
            },to: AddFoodLogAPI, encodingCompletion: { (result) in
                
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print("Succesfully uploaded")
                        
                        print(response.result.value)
                        
                        udefault.set(response.result.value, forKey: UserData)
                        
                        spinnerActivity.hide(animated: true)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let foodLogView = storyboard.instantiateViewController(withIdentifier: "foodLogView") as! FoodLogView
                        
                        self.present(foodLogView, animated: true, completion: nil)
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    spinnerActivity.hide(animated: true)
                    self.showAlert(title: "Alert", message: "Error in Uploading")
                    
                }
                
            })
        }
        
    }
    
    
    @IBAction func btnAddFoodImg(_ sender: Any) {
        
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        var gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            
            //profileImg.image = image
            
            self.dismiss(animated: true, completion: nil)
            let cropViewController = CropViewController(image: image)
            cropViewController.delegate = self
            present(cropViewController, animated: true, completion: nil)
            
        } else{
            print("Something went wrong")
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        foodImg.image = image
        coverImg.isHidden = true
        
        dismiss(animated: true, completion: nil)
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
