//
//  MenuTableViewCell.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/10/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuNAmeLbl: UILabel!
    @IBOutlet weak var greenView: UIView!
    
    @IBOutlet weak var numberBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
