//
//  FoodLogTableCell.swift
//  Enova
//
//  Created by APPLE MAC MINI on 26/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import UIKit

class FoodLogTableCell: UITableViewCell {

    @IBOutlet weak var MealType: UILabel!
    
    @IBOutlet weak var DateTime: UILabel!
    
    @IBOutlet weak var btnView: UIButton!
   
    @IBOutlet weak var btnViewbig: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
