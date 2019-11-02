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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(UserDefaults.standard.string(forKey: "USERID") == nil){
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfId") as! InformationController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            })
        }
        else{
            if(vars.isNotf == true){
                DispatchQueue.main.asyncAfter(deadline: .now()+0.00001, execute: {
                             let vc = self.storyboard?.instantiateViewController(withIdentifier: "RevealVC") as! CustomSWRevealController
                             vc.modalPresentationStyle = .fullScreen
                             self.present(vc, animated: false, completion: nil)
                         })
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                             let vc = self.storyboard?.instantiateViewController(withIdentifier: "RevealVC") as! CustomSWRevealController
                             vc.modalPresentationStyle = .fullScreen
                             self.present(vc, animated: false, completion: nil)
                         })
            }
         
        }
        
    }
    
}
