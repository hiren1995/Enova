//
//  ChatScreenOutlineView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 19/03/18.
//  Copyright © 2018 APPLE MAC MINI. All rights reserved.
//

import UIKit

class ChatScreenOutlineView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
