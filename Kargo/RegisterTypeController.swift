//
//  RegisterTypeController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/3/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class RegisterTypeController: UIViewController {

    @IBOutlet weak var firstWidthConst: NSLayoutConstraint!
    @IBOutlet weak var firstHeightConst: NSLayoutConstraint!
    @IBOutlet weak var secondWidthConst: NSLayoutConstraint!
    @IBOutlet weak var secondHeightConst: NSLayoutConstraint!
    @IBOutlet weak var customerLbl: UILabel!
    @IBOutlet weak var driverLbl: UILabel!
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var customerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeDimensions()
        createShadow(view: driverView)
        createShadow(view: customerView)
        
        let customerTapGesture = UITapGestureRecognizer(target: self, action: #selector(customerTapped))
        customerView.addGestureRecognizer(customerTapGesture)
        customerView.isUserInteractionEnabled = true
        
        let driverTapGesture = UITapGestureRecognizer(target: self, action: #selector(driverTapped))
        driverView.addGestureRecognizer(driverTapGesture)
        driverView.isUserInteractionEnabled = true

    }
    
    @objc func customerTapped(){
        performSegue(withIdentifier: "segueToDriver", sender: self)
    }
    
    @objc func driverTapped(){
        performSegue(withIdentifier: "segueToCustomerReg", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }


    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func changeDimensions(){
        print(UIScreen.main.bounds.height)
        if(UIScreen.main.bounds.height < 580.0){
            firstWidthConst.constant = 140
            secondWidthConst.constant = 140
            firstHeightConst.constant = 140
            secondHeightConst.constant = 140
            driverLbl.font = driverLbl.font.withSize(18)
            customerLbl.font = customerLbl.font.withSize(18)
        }
        if(UIScreen.main.bounds.height > 580 && UIScreen.main.bounds.height < 680)
        {
            firstWidthConst.constant = 160
            secondWidthConst.constant = 160
            firstHeightConst.constant = 160
            secondHeightConst.constant = 160
        }
    }
    
    func createShadow(view: UIView){
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowOpacity = 10
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 20.0
    }
}
