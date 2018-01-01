//
//  ProfileSettingView.swift
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
import CropViewController

var Gender:String = "Male"

class ProfileSettingView: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate{
    
    @IBOutlet var HeaderView: UIView!
    
    @IBOutlet var MenuView: UIView!
    
    @IBOutlet weak var btnDiabetes: UIButton!
    
    @IBOutlet weak var DiabetesView: UIView!
    
    @IBOutlet weak var lblDiabetesType: UILabel!
    
    @IBOutlet weak var NoteView: UIView!
    
    @IBOutlet weak var NoteText: UITextView!
    
    @IBOutlet weak var txtDOB: UITextField!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var imgMale: UIImageView!
    
    @IBOutlet weak var imgFemale: UIImageView!
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var coverImg: UIView!
    
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HeaderView.ShadowHeader()
        MenuView.menuViewBorder()
        MenuView.isHidden = true
        DiabetesView.ShadowMealView()
        DiabetesView.isHidden = true
        NoteView.setborder(colorValue: UIColor.lightGray)
        NoteView.roundCorners(value: 5)
        
        btnDiabetes.setbuttonborder(colorValue: UIColor.gray, widthValue: 1.0, cornerRadiusValue: 0.0)
        
        imgFemale.image = nil
        imgFemale.backgroundColor = UIColor.white
        imgFemale.setImageborder(colorValue: UIColor.black, widthValue: 1.0, cornerRadiusValue: 10.0)
        
        addDoneButtonOnKeyboard()
        
        loadUserData()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnMenuPress(_ sender: Any) {
        
        MenuView.menuClicked()
        
    }
    
    @IBAction func btnDiabetesPress(_ sender: Any) {
        
        DiabetesView.diabetesClicked()
    }
    
    @IBAction func btnPreDiabetesPress(_ sender: Any) {
        
        lblDiabetesType.text = "Pre-Diabetes"
        DiabetesView.isHidden = true
        DiabetesClicked = false
        
    }
    
    @IBAction func btnDiabetestype2Press(_ sender: Any) {
        
        lblDiabetesType.text = "Type II"
        DiabetesView.isHidden = true
        DiabetesClicked = false
    }
    
    @IBAction func btnDiabetesNone(_ sender: Any) {
        
        lblDiabetesType.text = "None"
        DiabetesView.isHidden = true
        DiabetesClicked = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        NoteText.text = nil
        NoteText.textColor = UIColor.black
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if NoteText.text.isEmpty
        {
            NoteText.text = "Enter text here..."
            
            NoteText.textColor = UIColor.lightGray
        }
    }
    
    
    @IBAction func btnMalePressed(_ sender: Any) {
        
        MaleRadioButton()
    }
    
    @IBAction func btnFemalePressed(_ sender: Any) {
        
        FemaleRadioButton()
        
    }
    
    
     //-------------------------------  code for date picker for txtFrom button ----------------------------------------------------------
    
    @IBAction func TxtDOBTapped(_ sender: UITextField) {
        
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(handleDatePickertxtFrom), for: UIControlEvents.valueChanged)
    }
    @objc func handleDatePickertxtFrom(sender: UIDatePicker) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        txtDOB.text = dateFormatter.string(from: sender.date)
        
    }
    
    //---------------------------------------------- End ------------------------------------------------------------------------------
    
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
       
        txtName.inputAccessoryView = doneToolbar
        NoteText.inputAccessoryView = doneToolbar
        txtDOB.inputAccessoryView = doneToolbar
    }
    @objc func cancelKeyboard(){
        self.view.endEditing(true)
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBack2(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
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
    
    
    func loadUserData()
    {
        let tempData = JSON(udefault.value(forKey: UserData))
        
        print(tempData)
        
        if(tempData != JSON.null)
        {
            txtName.text = tempData["data"]["full_name"].stringValue
            lblDiabetesType.text = tempData["data"]["diabetes_type"].stringValue
            txtDOB.text = tempData["data"]["dob"].stringValue
            NoteText.text = tempData["data"]["medications"].stringValue
            NoteText.textColor = UIColor.black
            
            if(tempData["data"]["gender"].stringValue == "Male")
            {
                MaleRadioButton()
            }
            else
            {
                FemaleRadioButton()
            }
            
            KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: userImgPath + tempData["data"]["profile_pic"].stringValue)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
               
                if(error == nil)
                {
                    self.profileImg.image = image
                    self.coverImg.isHidden = true
                }
                else
                {
                    self.showAlert(title: "Alert", message: "Something Went Wrong while downloading Profile Image")
                }
               
            })
        }
    }
    
    func MaleRadioButton()
    {
        imgMale.image = UIImage(named: "radio-on")
        imgMale.removeImageborder()
        Gender = "Male"
        imgFemale.image = nil
        imgFemale.backgroundColor = UIColor.white
        imgFemale.setImageborder(colorValue: UIColor.black, widthValue: 1.0, cornerRadiusValue: 10.0)
    }
    func FemaleRadioButton()
    {
        imgFemale.image = UIImage(named: "radio-on")
        imgFemale.removeImageborder()
        Gender = "Female"
        imgMale.image = nil
        imgMale.backgroundColor = UIColor.white
        imgMale.setImageborder(colorValue: UIColor.black, widthValue: 1.0, cornerRadiusValue: 10.0)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        update()
        
    }
    
    func update()
    {
        if (txtName.text == nil)
        {
            self.showAlert(title: "Alert", message: "Name Field cannot be empty")
        }
        else if (NoteText.text == nil)
        {
            self.showAlert(title: "Alert", message: "Please Enter Medications")
        }
        else if(profileImg.image == nil)
        {
            self.showAlert(title: "Alert", message: "Please Select Profile Image")
        }
        else
        {
            let imgData = UIImageJPEGRepresentation(profileImg.image!, 0.5)
            
            let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let updateParameters:Parameters = ["user_id": udefault.value(forKey: UserId)! , "full_name" : txtName.text! , "gender" : Gender , "diabetes_type" : lblDiabetesType.text! , "dob" : txtDOB.text!, "medications" : NoteText.text! ]
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in updateParameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if let data = imgData{
                    
                    multipartFormData.append(data, withName: "profile_pic", fileName: "image.jpg", mimeType: "image/jpg")
                    
                }
                
            },to: UpdateProfileAPI, encodingCompletion: { (result) in
                
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print("Succesfully uploaded")
                        
                        print(response.result.value)
                        
                        udefault.set(response.result.value, forKey: UserData)
                        
                        spinnerActivity.hide(animated: true)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let dashBoard = storyboard.instantiateViewController(withIdentifier: "dashBoard") as! DashBoard
                        
                        self.present(dashBoard, animated: true, completion: nil)
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    spinnerActivity.hide(animated: true)
                    self.showAlert(title: "Alert", message: "Error in Uploading")
                    
                }
                
            })
        }
        
        
    }
    
    
    @IBAction func btnUploadnewImg(_ sender: Any) {
        
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
        
        profileImg.image = image
        
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
