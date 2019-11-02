//
//  ProfileController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/17/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, SWRevealViewControllerDelegate {

    var menuBtn = UIButton()
    var menuBarItem = UIBarButtonItem()
    @IBOutlet weak var view1: CustomSelectButton!
    @IBOutlet weak var view2: CustomSelectButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bigAcxtionBar: UIView!
    @IBOutlet weak var senedView: CustomSelectButton!
    @IBOutlet weak var senedViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    var foreignPassportUrl: String?
    var carRegisterUrl: String?
    var halfcarRegisterUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpMenuButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigAcxtionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
            self.mainView.roundCorners(corners: [.topRight, .bottomRight], cornerRadius: 30.0)
        })
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        view1.layer.borderColor = UIColor.clear.cgColor
        view2.layer.borderColor = UIColor.clear.cgColor
        senedView.layer.borderColor = UIColor.clear.cgColor
        view1.layer.cornerRadius = 0
        view2.layer.cornerRadius = 0
        senedView.layer.cornerRadius = 0
        
        if((UserDefaults.standard.string(forKey: "USERROLE"))! == "4"){
            senedViewHeight.constant = 0
            mainViewHeight.constant = 140
            
        }
        
            
        self.revealViewController()?.delegate = self
        
        let profilTap = UITapGestureRecognizer(target: self, action: #selector(profilTapped))
        view1.isUserInteractionEnabled = true
        profilTap.cancelsTouchesInView = false
        view1.addGestureRecognizer(profilTap)
        
        let sifreTap = UITapGestureRecognizer(target: self, action: #selector(sifreTapped))
        view2.isUserInteractionEnabled = true
        sifreTap.cancelsTouchesInView = false
        view2.addGestureRecognizer(sifreTap)
        
        let senedTap = UITapGestureRecognizer(target: self, action: #selector(senedTapped))
        senedView.isUserInteractionEnabled = true
        senedTap.cancelsTouchesInView = false
        senedView.addGestureRecognizer(senedTap)
       
    }
    
    
    
    @objc func profilTapped(){
        if((UserDefaults.standard.string(forKey: "USERROLE"))! == "4"){
            performSegue(withIdentifier: "segueToDetail", sender: self)
        }
        else{
            performSegue(withIdentifier: "segueToDriverProfileController", sender: self)
        }
       
    }
    
    @objc func sifreTapped(){
        performSegue(withIdentifier: "segueToChangePass", sender: self)
    }
    
    @objc func senedTapped(){
        performSegue(withIdentifier: "segueToDocument", sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
    }
    
    func revealControllerPanGestureBegan(_ revealController: SWRevealViewController!) {
        view1.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
        view2.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
         senedView.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToDocument")
        {
            let VC  = segue.destination as! DocumentsController
            VC.type = 2
        }
    }

}
