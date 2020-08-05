//
//  ChooseLanguageController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/7/20.
//  Copyright © 2020 Nicat Guliyev. All rights reserved.
//

import UIKit

class ChooseLanguageController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var azView: CustomSelectButton!
    @IBOutlet weak var rusView: CustomSelectButton!
    @IBOutlet weak var engView: CustomSelectButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.mainView.roundCorners(corners: [.topRight, .bottomRight], cornerRadius: 30.0)
        })
        
        azView.layer.cornerRadius = 0
        azView.layer.borderColor = UIColor.clear.cgColor
        rusView.layer.cornerRadius = 0
        rusView.layer.borderColor = UIColor.clear.cgColor
        engView.layer.cornerRadius = 0
        engView.layer.borderColor = UIColor.clear.cgColor
        
        let azTapgesture = UITapGestureRecognizer(target: self, action: #selector(azTapped))
        azView.isUserInteractionEnabled = true
        azView.addGestureRecognizer(azTapgesture)
        
        let rusTapGesture = UITapGestureRecognizer(target: self, action: #selector(rusTapped))
        rusView.isUserInteractionEnabled = true
        rusView.addGestureRecognizer(rusTapGesture)
        
        let engTapGesture = UITapGestureRecognizer(target: self, action: #selector(engTapped))
        engView.isUserInteractionEnabled = true
        engView.addGestureRecognizer(engTapGesture)
    }
    
    @objc func azTapped(){
        UserDefaults.standard.set("az", forKey: "Lang")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfId") as! InformationController
        vc.modalPresentationStyle = .fullScreen // IOS 13 de bunu yazmasaq yeni controller tab kimi acilacaq
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func rusTapped(){
        UserDefaults.standard.set("ru", forKey: "Lang")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfId") as! InformationController
        vc.modalPresentationStyle = .fullScreen // IOS 13 de bunu yazmasaq yeni controller tab kimi acilacaq
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func engTapped(){
        UserDefaults.standard.set("en", forKey: "Lang")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfId") as! InformationController
        vc.modalPresentationStyle = .fullScreen // IOS 13 de bunu yazmasaq yeni controller tab kimi acilacaq
        self.present(vc, animated: false, completion: nil)
    }
    
    
    
    
}
