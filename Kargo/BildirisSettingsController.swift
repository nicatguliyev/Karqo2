//
//  BildirisSettingsController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/24/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class BildirisSettingsController: UIViewController {

    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bottomView: SenedeBaxButtonView!
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    @IBOutlet weak var firstView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackButton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
            self.bottomView.roundCorners(corners: [.topRight], cornerRadius: 90.0)
        })
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = false
        createShadow(view: mainView)
        firstView.layer.cornerRadius = 30.0

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
    
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
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
