//
//  MoneyTransferController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/16/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class MoneyTransferController: UIViewController{
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var fieldsView: UIView!
    @IBOutlet weak var valyutaView: CustomAyliqSelect!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var gonderConst: NSLayoutConstraint!
    @IBOutlet weak var cardTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var cardTextField2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpDesign()
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
    
    func setUpDesign(){
        
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = false
        setUpBackButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
            self.fieldsView.roundCorners(corners: [.bottomRight], cornerRadius: 60.0)
            self.bottomView.roundCorners(corners: [.bottomRight], cornerRadius: 60.0)
            self.sendBtn.roundCorners(corners: [.bottomRight, .topLeft], cornerRadius: 50.0)
        })
        
        valyutaView.layer.cornerRadius = 0
        valyutaView.layer.borderWidth = 0
        valyutaView.backgroundColor = UIColor.clear
        
        if(UIScreen.main.bounds.height < 600)
        {
            gonderConst.constant = 10.0
        }
        
    }
}
extension MoneyTransferController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
        
        if cardTextField == textField  || cardTextField2 == textField{
            textField.text = lastText.format("NNNN NNNN NNNN NNNN", oldString: text)
            return false
        }
        if timeTextField == textField{
            textField.text = lastText.format("NN/NN", oldString: text)
            return false
        }
        return true
    }
}
