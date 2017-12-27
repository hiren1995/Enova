//
//  ProfileSettingView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 27/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit

var Gender:String = "Male"

class ProfileSettingView: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    
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
        
        imgMale.image = UIImage(named: "radio-on")
        imgMale.removeImageborder()
        Gender = "Male"
        imgFemale.image = nil
        imgFemale.backgroundColor = UIColor.white
        imgFemale.setImageborder(colorValue: UIColor.black, widthValue: 1.0, cornerRadiusValue: 10.0)
    }
    
    @IBAction func btnFemalePressed(_ sender: Any) {
        
        imgFemale.image = UIImage(named: "radio-on")
        imgFemale.removeImageborder()
        Gender = "Female"
        imgMale.image = nil
        imgMale.backgroundColor = UIColor.white
        imgMale.setImageborder(colorValue: UIColor.black, widthValue: 1.0, cornerRadiusValue: 10.0)
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
        
        //txtTo.inputAccessoryView = doneToolbar
        //txtFrom.inputAccessoryView = doneToolbar
       
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
