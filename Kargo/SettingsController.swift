//
//  SettingsController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/23/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, SWRevealViewControllerDelegate {
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var langView: CustomSelectButton!
    @IBOutlet weak var ringView: CustomSelectButton!
    var menuBtn = UIButton()
    var menuBarItem = UIBarButtonItem()
    @IBOutlet weak var locationView: CustomSelectButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMenuButton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
            self.mainView.roundCorners(corners: [.topRight, .bottomRight], cornerRadius: 30.0)
        })
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        langView.layer.borderColor = UIColor.clear.cgColor
        ringView.layer.borderColor = UIColor.clear.cgColor
        langView.layer.cornerRadius = 0
        ringView.layer.cornerRadius = 0
        locationView.layer.borderColor = UIColor.clear.cgColor
        locationView.layer.cornerRadius = 0
        
        self.revealViewController()?.delegate = self
        
        let langTap = UITapGestureRecognizer(target: self, action: #selector(langTapped))
        langView.isUserInteractionEnabled = true
        langTap.cancelsTouchesInView = false
        langView.addGestureRecognizer(langTap)
        
        let ringTap = UITapGestureRecognizer(target: self, action: #selector(ringTapped))
        ringView.isUserInteractionEnabled = true
        ringTap.cancelsTouchesInView = false
        ringView.addGestureRecognizer(ringTap)

        // Do any additional setup after loading the view.
    }
    
    @objc func langTapped(){
        performSegue(withIdentifier: "segueToSelectLang", sender: self)
    }
    
    @objc func ringTapped(){
        performSegue(withIdentifier: "segueToBildiris", sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
    }
    
    func revealControllerPanGestureBegan(_ revealController: SWRevealViewController!) {
        langView.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
        ringView.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
        locationView.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)

    }
    
    
    
    func setUpMenuButton(){
        
        menuBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuBtn.setImage(UIImage(named: "menuIcon.png"), for: UIControl.State.normal)
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        menuBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 30)
        
        
        menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        menuBarItem = UIBarButtonItem(customView: menuBtn)
        
        self.navigationItem.leftBarButtonItem = menuBarItem
        revealViewController()?.rearViewRevealWidth = 300
        
        self.revealViewController()?.rearViewRevealOverdraw = 0
        self.revealViewController()?.bounceBackOnOverdraw = false
        
    }
    

}
