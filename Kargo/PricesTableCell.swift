//
//  PricesTableCell.swift
//  Kargo
//
//  Created by Nicat Guliyev on 11/12/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class PricesTableCell: UITableViewCell {
    
    @IBOutlet weak var ovalView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var radioBtn: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
