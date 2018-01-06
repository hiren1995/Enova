//
//  MealSelectTableCell.swift
//  Enova
//
//  Created by APPLE MAC MINI on 06/01/18.
//  Copyright © 2018 APPLE MAC MINI. All rights reserved.
//

import UIKit

class MealSelectTableCell: UITableViewCell {

    @IBOutlet weak var lblMealTypeName: UILabel!
    
    @IBOutlet weak var borderBottom: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
