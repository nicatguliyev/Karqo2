//
//  ExitPopupController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 9/25/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import OneSignal

class ExitPopupController: UIViewController {
    @IBOutlet weak var exitView: UIView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    var exit: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute: {
            self.exitView.roundCorners(corners: [.bottomLeft, .topRight], cornerRadius: 70.0)
            self.yesBtn.layer.cornerRadius = 10
            self.noBtn.layer.cornerRadius = 10
        })

        // Do any additional setup after loading the view.
    }
    
    @IBAction func yesBtnClicked(_ sender: Any) {
        OneSignal.deleteTag("user_id")
        UserDefaults.standard.removeObject(forKey: "USERID")
        UserDefaults.standard.removeObject(forKey: "USERTOKEN")
          UserDefaults.standard.removeObject(forKey: "USERROLE")
        UserDefaults.standard.removeObject(forKey: "USERNAME")
              UserDefaults.standard.removeObject(forKey: "USERAVATAR")
                UserDefaults.standard.removeObject(forKey: "USERPHONE")
        UserDefaults.standard.removeObject(forKey: "PUSHSTATUS")
               UserDefaults.standard.removeObject(forKey: "SMSSTATUS")
                     UserDefaults.standard.removeObject(forKey: "SOUNDSTATUS")
                       UserDefaults.standard.removeObject(forKey: "VIBSTATUS")
        dismiss(animated: true, completion: nil)
        exit!()
        //self.revealViewController()?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
