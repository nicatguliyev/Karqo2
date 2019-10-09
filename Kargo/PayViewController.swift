//
//  PayViewController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/12/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import AnyFormatKit

class PayViewController: UIViewController, UITextFieldDelegate, SWRevealViewControllerDelegate {
    
    var menuBtn = UIButton()
    var menuBarItem = UIBarButtonItem()
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var view1: CustomSelectButton!
    @IBOutlet weak var view2: CustomSelectButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMenuButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
            self.mainView.roundCorners(corners: [.topRight, .bottomRight], cornerRadius: 30.0)
        })          
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        view1.layer.borderColor = UIColor.clear.cgColor
        view2.layer.borderColor = UIColor.clear.cgColor
        view1.layer.cornerRadius = 0
        view2.layer.cornerRadius = 0
        
        self.revealViewController()?.delegate = self
        
        let tetbiqTap = UITapGestureRecognizer(target: self, action: #selector(tetbiqTapped))
        view1.isUserInteractionEnabled = true
        tetbiqTap.cancelsTouchesInView = false
        view1.addGestureRecognizer(tetbiqTap)
        
        let transferTap = UITapGestureRecognizer(target: self, action: #selector(transferTapped))
        view2.isUserInteractionEnabled = true
        transferTap.cancelsTouchesInView = false
        view2.addGestureRecognizer(transferTap)
        
    
        
    }
    

    
    @objc func tetbiqTapped(){
        performSegue(withIdentifier: "segueToTetbiq", sender: self)
    }
    
    @objc func transferTapped(){
        performSegue(withIdentifier: "segueToTransfer", sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
    }
    
    func revealControllerPanGestureBegan(_ revealController: SWRevealViewController!) {
        view1.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
        view2.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
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
