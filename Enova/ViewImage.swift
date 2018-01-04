//
//  ViewImage.swift
//  Enova
//
//  Created by APPLE MAC MINI on 04/01/18.
//  Copyright © 2018 APPLE MAC MINI. All rights reserved.
//

import UIKit

class ViewImage: UIViewController,UIScrollViewDelegate {

    @IBOutlet var ScrollView: UIScrollView!
    
    @IBOutlet var Image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScrollView.minimumZoomScale = 1.0
        ScrollView.maximumZoomScale = 6.0
        
        ScrollView.bouncesZoom = false
        ScrollView.bounces = false
        
        ScrollView.delegate = self
        
        let imgDataZoom = UserDefaults.standard.object(forKey: FoodImageDefault) as! NSData
        
        Image.image = UIImage(data: imgDataZoom as Data)
        
        

        // Do any additional setup after loading the view.
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return Image
    }
   
    @IBAction func btnBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
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
