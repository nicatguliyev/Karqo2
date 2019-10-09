//
//  BildirisItemBackground.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/16/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class BildirisItemBackground: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.3)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            ( self.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.0))
        })
    }

}
