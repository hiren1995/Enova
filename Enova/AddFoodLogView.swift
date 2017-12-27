//
//  AddFoodLogView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 26/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit

class AddFoodLogView: UIViewController,UITextViewDelegate {

    
    @IBOutlet var HeaderView: UIView!
    
    @IBOutlet var MenuView: UIView!
    
    @IBOutlet weak var NoteView: UIView!
    
    @IBOutlet weak var NoteText: UITextView!
    
    @IBOutlet weak var btnMealChoose: UIButton!
    
    
    @IBOutlet weak var lblFoodLabel: UILabel!
    
    
    @IBOutlet weak var MealSelectView: UIView!
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
        
        addDoneButtonOnKeyboard()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnMenuPress(_ sender: Any) {
        
        MenuView.menuClicked()
        
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
