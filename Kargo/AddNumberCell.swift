//
//  AddNumberCell.swift
//  Kargo
//
//  Created by Nicat Guliyev on 8/16/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class AddNumberCell: UITableViewCell {
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var prefixLbl: UILabel!
    @IBOutlet weak var numberSelectBtn: UIButton!
    @IBOutlet weak var pickerTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
