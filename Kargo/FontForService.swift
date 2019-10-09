//
//  FontForService.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/10/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import Foundation
import UIKit

class FontForService: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(UIScreen.main.bounds.height < 600){
            self.font = self.font.withSize(self.font.pointSize - 2)
        }
        }
    }

