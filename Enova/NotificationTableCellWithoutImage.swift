//
//  NotificationTableCellWithoutImage.swift
//  Enova
//
//  Created by Apple on 10/04/18.
//  Copyright © 2018 APPLE MAC MINI. All rights reserved.
//

import UIKit
import ActiveLabel

class NotificationTableCellWithoutImage: UITableViewCell {

    
    @IBOutlet var lblNotificationTitle: ActiveLabel!
    
    
    @IBOutlet var lblNotificationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
