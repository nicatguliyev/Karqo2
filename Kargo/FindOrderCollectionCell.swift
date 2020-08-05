//
//  FindOrderCollectionCell.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/27/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class FindOrderCollectionCell: UICollectionViewCell

{

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var fromCountryLbl: UILabel!
    @IBOutlet weak var personNameLbl: UILabel!
    @IBOutlet weak var toCountryLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var tipLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var tarixLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
