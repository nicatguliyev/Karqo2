//
//  CustomAyliqSelect.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/15/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class CustomAyliqSelect: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1).cgColor
        self.layer.borderWidth = 1.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.1)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            ( self.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.0))
        })
    }
    

}
