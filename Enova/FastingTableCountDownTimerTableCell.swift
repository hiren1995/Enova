//
//  FastingTableCountDownTimerTableCell.swift
//  Enova
//
//  Created by APPLE MAC MINI on 02/04/18.
//  Copyright © 2018 APPLE MAC MINI. All rights reserved.
//

import UIKit

class FastingTableCountDownTimerTableCell: UITableViewCell {

    
    @IBOutlet var lblTimer: UILabel!
    
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var lblEndDate: UILabel!
    @IBOutlet var lblStartTime: UILabel!
    @IBOutlet var lblEndTime: UILabel!
    
    
    @IBOutlet var btnCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
