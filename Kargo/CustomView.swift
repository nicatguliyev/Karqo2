//
//  CustomView.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/8/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class CustomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backgroundColor = UIColor(red: 25/255, green: 82/255, blue: 95/255, alpha: 0.85)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        backgroundColor = UIColor(red: 25/255, green: 82/255, blue: 95/255, alpha: 1)
        
    }

}
