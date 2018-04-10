//
//  ChatScreenView.swift
//  Enova
//
//  Created by APPLE MAC MINI on 19/03/18.
//  Copyright © 2018 APPLE MAC MINI. All rights reserved.
//

import UIKit

import  SwiftyJSON

import JSQMessagesViewController

import Alamofire

import MBProgressHUD

//import CoreData

import MobileCoreServices

import CropViewController

import Kingfisher

class ChatScreenView: JSQMessagesViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate {

    
    let incomingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero).incomingMessagesBubbleImage(with: UIColor(red: 66/255, green: 155/255, blue: 213/255, alpha: 1.0))
    
    let outgoingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: UIEdgeInsets.zero).outgoingMessagesBubbleImage(with: UIColor(red: 211/255, green: 219/255, blue: 223/255, alpha: 1.0))
    
    private var messages = [JSQMessage]()
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageReceived(notification:)), name: NSNotification.Name("MessageNotification"), object: nil)
        

        let tempData = JSON(udefault.value(forKey: UserData))
        
        self.senderId = "0"
        self.senderDisplayName = "EnovaUser"
        
        LoadMessages()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews()
    {
        
        self.scrollToBottom(animated: true)
    }
    
    func LoadMessages()
    {
        
        let getchatdata:Parameters = ["user_id": udefault.value(forKey: UserId)! ,"last_id": "-1"]
        
        Alamofire.request(GetMessagesAPI, method: HTTPMethod.post, parameters: getchatdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON
            { (response) in
                
                if(response.result.value != nil)
                {
                    print(JSON(response.result.value))
                    let tempDictMsg = JSON(response.result.value)
                    
                    
                    if(tempDictMsg["status"] == "success")
                    {
                        if(tempDictMsg["data"].count > 0)
                        {
                            for i in 0...tempDictMsg["data"].count-1
                            {
                                if(tempDictMsg["data"][i]["is_image"].intValue == 0)
                                {
                                    let date = Date(timeIntervalSince1970:  (tempDictMsg["data"][i]["time"].doubleValue / 1000.0))
                                    
                                    print(date)
                                    
                                    self.messages.append(JSQMessage(senderId: tempDictMsg["data"][i]["sent_admin"].stringValue, senderDisplayName: "sender", date:date as Date! , text: decodeEmojiMsg(tempDictMsg["data"][i]["message"].stringValue)))
                                    
                                    //self.collectionView.reloadData()
                                    
                                    self.finishReceivingMessage(animated: true)
                                    
                                }
                                    
                                else
                                {
                                    let img = JSQPhotoMediaItem(image: UIImage(named: "imgPlaceholder"))
                                    
                                    img?.appliesMediaViewMaskAsOutgoing = true
                                    
                                    let date = Date(timeIntervalSince1970:  (Double(tempDictMsg["data"][i]["time"].stringValue)! / 1000.0))
                                    
                                    self.messages.append(JSQMessage(senderId: tempDictMsg["data"][i]["sent_admin"].stringValue, senderDisplayName: "sender", date: date as Date!, media: img))
                                    
                                    //self.collectionView.reloadData()
                                    
                                    KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: "\(chatImgPath)/\(tempDictMsg["data"][i]["message"].stringValue)")! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
                                        
                                        
                                        img?.image = image
                                        
                                        self.collectionView.reloadData()
                                    })
                                    
                                }
                                
                            }
                        }
                    }
                    
                    self.collectionView.reloadData()
                }
                else
                {
                        self.showAlert(title: "Alert", message: "Please Check your Internet Connection")
                }
                
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cellchat = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        cellchat.messageBubbleContainerView.layer.cornerRadius = 10.0
        
        let messagesitem = messages[indexPath.row]
        
        if messagesitem.isMediaMessage
        {
            cellchat.messageBubbleContainerView.backgroundColor = UIColor.clear
        }
        
        if(messagesitem.senderId == self.senderId)
        {
            cellchat.cellBottomLabel.textAlignment = .right
        }
        else
        {
            cellchat.cellBottomLabel.textAlignment = .left
        }
        
        return cellchat
    }
    
    
    
    
    //------------------------------------------------ code for showing date and sender name for each cell--------------------------------------------
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        
        let message = messages[indexPath.row]
        
        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
    }
    
    //------------------------------------------------ code for showing date and sender name for each cell End --------------------------------------------
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        
        return messages[indexPath.item]
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    
        return messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
        
        //return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        //return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "radio-on"), diameter: 30)
        
        //return JSQMessagesAvatarImageFactory.avatarImage(with: nil, diameter: 60)
        return nil
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        //below code appends the message array with the message we type in text view... then all the above methods are called...
        
        self.messages.append(JSQMessage(senderId: self.senderId, displayName: senderDisplayName, text: text))
        
        collectionView.reloadData()
        
        self.finishSendingMessage()
        
        let timeStamp = String(Date().currentTimeStamp)
        
        let sendMsgdata:Parameters = ["user_id": udefault.value(forKey: UserId)! ,"time": timeStamp,"message":text,"is_image": 0]
        
        Alamofire.request(SendMessagesAPI, method: HTTPMethod.post, parameters: sendMsgdata as Parameters, encoding: URLEncoding.default, headers: nil).responseJSON
            { (response) in
                
                let tempDict = JSON(response.result.value)
                
                if(response.result.value != nil)
                {
                   if(tempDict["status"] == "success")
                   {
                        print("Sent Successfully")
                   }
                   else
                   {
                         self.showAlert(title: "Alert", message: "Something went worng while sending message")
                   }
                }
                else
                {
                    self.showAlert(title: "Alert", message: "Please Check your Internet Connection")
                }
                
        }
        
        
    }
    
    //-------------- code for selecting image on click of accessory button---------------
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
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
        
        let img = JSQPhotoMediaItem(image: image)
        
        let imgData = UIImageJPEGRepresentation(image, 0.1)
        
        self.messages.append(JSQMessage(senderId: self.senderId, displayName: senderDisplayName, media : img))
        
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
        
        let timeStamp = String(Date().currentTimeStamp)
        
        let sendMsgdata:Parameters = ["user_id": udefault.value(forKey: UserId)! ,"time": timeStamp ,"is_image": 1]
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in sendMsgdata {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imgData{
                
                multipartFormData.append(data, withName: "message", fileName: "image.jpg", mimeType: "image/jpg")
                
            }
            
        },to: SendMessagesAPI, encodingCompletion: { (result) in
            
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    
                    print(response.result.value)
                    
                    
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                
                self.showAlert(title: "Alert", message: "Error in Uploading")
                
            }
            
        })
        
        
        // dismiss(animated: true, completion: nil)
    }
   
    
    @objc func messageReceived (notification : NSNotification)
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
        
        LoadMessages()
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
