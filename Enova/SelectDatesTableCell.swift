//
//  SelectDatesTableCell.swift
//  Enova
//
//  Created by APPLE MAC MINI on 02/04/18.
//  Copyright © 2018 APPLE MAC MINI. All rights reserved.
//

import UIKit

class SelectDatesTableCell: UITableViewCell {

    @IBOutlet var txtFrom: UITextField!
    @IBOutlet var txtTo: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
