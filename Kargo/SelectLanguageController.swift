//
//  SelectLanguageController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/26/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class SelectLanguageController: UIViewController, SWRevealViewControllerDelegate {
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var view1: CustomSelectButton!
    @IBOutlet weak var view2: CustomSelectButton!
    @IBOutlet weak var view3: CustomSelectButton!
    @IBOutlet weak var basliqLbl: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var iamge3: UIImageView!
    
    var selectedLang: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedLang = UserDefaults.standard.string(forKey: "Lang")
        
        if(selectedLang == "en"){
            image1.isHidden = true
            image2.isHidden = true
            iamge3.isHidden = false
        }
        
        if(selectedLang == "ru"){
            image1.isHidden = true
            image2.isHidden = false
            iamge3.isHidden = true
        }
        
        if(selectedLang == "az"){
            image1.isHidden = false
            image2.isHidden = true
            iamge3.isHidden = true
        }
        
        setUpBackButton()
        
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
            self.mainView.roundCorners(corners: [.topRight, .bottomRight], cornerRadius: 30.0)

        })
       // createShadow(view: mainView)
        
        view1.layer.borderColor = UIColor.clear.cgColor
        view2.layer.borderColor = UIColor.clear.cgColor
        view3.layer.borderColor = UIColor.clear.cgColor
        view1.layer.cornerRadius = 0
        view2.layer.cornerRadius = 0
        view3.layer.cornerRadius = 0
        
        self.revealViewController()?.delegate = self
        
        let azTap = UITapGestureRecognizer(target: self, action: #selector(azTapped))
        view1.isUserInteractionEnabled = true
        azTap.cancelsTouchesInView = false
        view1.addGestureRecognizer(azTap)
        
        let rusTap = UITapGestureRecognizer(target: self, action: #selector(rusTapped))
        view2.isUserInteractionEnabled = true
        rusTap.cancelsTouchesInView = false
        view2.addGestureRecognizer(rusTap)

        let engTap = UITapGestureRecognizer(target: self, action: #selector(engTapped))
        view3.isUserInteractionEnabled = true
        engTap.cancelsTouchesInView = false
        view3.addGestureRecognizer(engTap)
    }
    
    func setUpBackButton(){
        
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.setImage(UIImage(named: "whiteBackIcon.png"), for: UIControl.State.normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 30)
        
        backButton.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
        
        barItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = barItem
        
    }
    
    func revealControllerPanGestureBegan(_ revealController: SWRevealViewController!) {
        view1.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
        view2.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
        view3.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
    }
    
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func azTapped(){
        UserDefaults.standard.set("az", forKey: "Lang")
        selectedLang = UserDefaults.standard.string(forKey: "Lang")
        basliqLbl.text = "language_options".addLocalizableString(str: selectedLang!)
        image1.isHidden = false
        image2.isHidden = true
        iamge3.isHidden = true
    }
    
    @objc func rusTapped(){
        UserDefaults.standard.set("ru", forKey: "Lang")
        selectedLang = UserDefaults.standard.string(forKey: "Lang")
        basliqLbl.text = "language_options".addLocalizableString(str: selectedLang!)
        image1.isHidden = true
        image2.isHidden = false
        iamge3.isHidden = true
    }
    
    @objc func engTapped(){
        UserDefaults.standard.set("en", forKey: "Lang")
        selectedLang = UserDefaults.standard.string(forKey: "Lang")
        basliqLbl.text = "language_options".addLocalizableString(str: selectedLang!)
        image1.isHidden = true
        image2.isHidden = true
        iamge3.isHidden = false
    }
    
    func createShadow(view: UIView){
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 30.0
        
    }
}
