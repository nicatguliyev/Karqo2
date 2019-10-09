//
//  CustomBildirisCell.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/16/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class CustomBildirisCell: UITableViewCell {
    
    @IBOutlet weak var ovalView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bildirisImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bildirisImg.layer.cornerRadius = bildirisImg.frame.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    
}
