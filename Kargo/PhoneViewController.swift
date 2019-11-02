//
//  PhoneViewController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 10/23/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class PhoneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var tableHeightConst: NSLayoutConstraint!
    
    var phoneNumbers: String?
    var numbers = [String]()
    var actionType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(view1Tapped))
        self.view1.isUserInteractionEnabled = true
        self.view1.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(view2Tapped))
        self.view2.isUserInteractionEnabled = true
        self.view2.addGestureRecognizer(tapGesture2)
        
        self.numbers = phoneNumbers!.components(separatedBy: ",")
        if(actionType == 1)
        {
            self.tableHeightConst.constant = 55.0
        }
        else{
            self.tableHeightConst.constant = CGFloat(Double(numbers.count) * 55.0)
        }
        
        

    }
    
    @objc func view1Tapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func view2Tapped(){
        self.dismiss(animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(actionType == 1)
        {
            return 1
        }
        else{
            return numbers.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneNumberCellId") as! PhoneNumberCell
        
        cell.phoneNumberLbl.text = numbers[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true, completion: nil)
        if(actionType == 1)
        {
            
            UIApplication.shared.open(URL(string: "https://api.whatsapp.com/send?phone=" + numbers[indexPath.row])!, options: [:], completionHandler: nil)
        }
        else if(actionType == 2)
        {
            UIApplication.shared.open(URL(string: "tel:" + numbers[indexPath.row])!, options: [:], completionHandler: nil)
        }
        else{
            UIApplication.shared.open(URL(string: "sms:" + numbers[indexPath.row])!, options: [:], completionHandler: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//
//        let cells = self.tableView.visibleCells
//        print(type(of: touch.view))
//
//        if(touch.view == self.tableView){
//            return false
//        }
//        else
//        {
//            return true
//        }
//
//    }
    

}
