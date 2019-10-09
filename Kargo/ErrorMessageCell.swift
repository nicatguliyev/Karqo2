//
//  ErrorMessageCell.swift
//  Kargo
//
//  Created by Nicat Guliyev on 8/23/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class ErrorMessageCell: UITableViewCell {

    @IBOutlet weak var errorLbl: UIView!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
