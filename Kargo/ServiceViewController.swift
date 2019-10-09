//
//  ServiceViewController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/10/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bigActionBar: UIView!
    var serviceType = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(UIScreen.main.bounds.height)
        createShadow2(view: mainView)
        setUpBackButton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
        })
        
        if(UIScreen.main.bounds.height < 600)
        {
            imageHeight.constant = 170
            
            mainViewHeight.constant = 360
            
        }
        
        if(serviceType == 1)
        {
            imageView.image = UIImage(named: "evacuator2Img.png")
        }
        else
        {
            imageView.image = UIImage(named: "evakuatorImg.png")
        }
        
    }
    
    func createShadow2(view: UIView){
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 30.0
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

}
