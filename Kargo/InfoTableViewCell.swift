//
//  InfoTableViewCell.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/9/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var paramNameLbl: UILabel!
    @IBOutlet weak var paramValLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
