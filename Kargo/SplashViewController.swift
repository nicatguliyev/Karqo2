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
            if(UserDefaults.standard.string(forKey: "Lang") != nil){
                // Eger local database-de USERID yoxdursa demeli user login olmayib. ona gorede 3 saniyeden sonra InformationController ekrani acilacaq
                DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfId") as! InformationController
                    vc.modalPresentationStyle = .fullScreen // IOS 13 de bunu yazmasaq yeni controller tab kimi acilacaq
                    self.present(vc, animated: false, completion: nil)
                })
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "chooseLangId") as! ChooseLanguageController
                    vc.modalPresentationStyle = .fullScreen // IOS 13 de bunu yazmasaq yeni controller tab kimi acilacaq
                    self.present(vc, animated: false, completion: nil)
                })
            }
            
        }
        else{ // Eger local Database -de USERID varsa demeli artiq user login olub
            if(vars.isNotf == true){ // Proqram notification-dan acilir
                DispatchQueue.main.asyncAfter(deadline: .now()+0.00001, execute: {// Notifiction-dan acildigina gore Splash ekranda dayanmir derhal esas Controllere kecir
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RevealVC") as! CustomSWRevealController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false, completion: nil)
                })
            }
            else{// proqram notificationdan acilmir, ona gorede Splash ekranda 3 saniye dayandiqdan sonra kecir Esas controllera
                DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RevealVC") as! CustomSWRevealController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false, completion: nil)
                })
            }
            
        }
        
    }
    
}
