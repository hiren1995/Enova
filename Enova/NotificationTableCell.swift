//
//  NotificationTableCell.swift
//  Enova
//
//  Created by APPLE MAC MINI on 20/03/18.
//  Copyright © 2018 APPLE MAC MINI. All rights reserved.
//

import UIKit
import ActiveLabel

class NotificationTableCell: UITableViewCell {

    
    @IBOutlet weak var lblNotificationTitle: ActiveLabel!
    @IBOutlet weak var lblNotificationDate: UILabel!
    @IBOutlet weak var imgNotification: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
