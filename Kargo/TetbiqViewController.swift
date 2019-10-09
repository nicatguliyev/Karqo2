//
//  TetbiqViewController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/12/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import AnyFormatKit

class TetbiqViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{


    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var textFieldsView: UIView!
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    @IBOutlet weak var cardTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var ayliqView: CustomAyliqSelect!
    @IBOutlet weak var hiddenTextField: UITextField!
    @IBOutlet weak var muddetLbl: UILabel!
    let muddetPicker = UIPickerView()
    var muddet = ["Aylıq", "İllik"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = false
        setUpBackButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
            self.textFieldsView.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
            self.payBtn.roundCorners(corners: [.bottomRight, .topLeft], cornerRadius: 50.0)
        })
        
        ayliqView.layer.cornerRadius = 0
        ayliqView.layer.borderWidth = 0
        ayliqView.backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ayliqTapped))
        ayliqView.isUserInteractionEnabled = true
        tapGesture.cancelsTouchesInView = false
        ayliqView.addGestureRecognizer(tapGesture)
        
        muddetPicker.delegate = self
        muddetPicker.dataSource = self
        hiddenTextField.inputView = muddetPicker
     
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
    
    @objc func ayliqTapped(){
        hiddenTextField.becomeFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return muddet.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return muddet[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        muddetLbl.text = muddet[row]
    }
    
    
}


extension TetbiqViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String

        if cardTextField == textField {
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
