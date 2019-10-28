//
//  SplashViewController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/2/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    var SPVC: SplashViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.dismiss(animated: true, completion: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfId") as! InformationController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        })

    }
    
}
