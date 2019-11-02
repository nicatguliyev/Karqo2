//
//  BildirisDetailCollectionCell.swift
//  Kargo
//
//  Created by Nicat Guliyev on 10/30/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class BildirisDetailCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var fromCountryLbl: UILabel!
    @IBOutlet weak var toCountryLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var tipLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
