//
//  BildirisSettingsController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/24/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

struct UpdateNotfModel: Decodable {
    let status: String?
}

class BildirisSettingsController: UIViewController {

    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var mainView: UIView!
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    @IBOutlet weak var firstView: UIView!
    var questionView = QuestionView()
    @IBOutlet weak var pushSwitch: UISwitch!
    @IBOutlet weak var smsSwitch: UISwitch!
    @IBOutlet weak var sesSwitch: UISwitch!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDefaults.standard.string(forKey: "PUSHSTATUS") == "1"){
            pushSwitch.setOn(true, animated: true)
        }
        if(UserDefaults.standard.string(forKey: "SMSSTATUS") == "1"){
            smsSwitch.setOn(true, animated: true)
        }
        if(UserDefaults.standard.string(forKey: "SOUNDSTATUS") == "1"){
            sesSwitch.setOn(true, animated: true)
        }
        if(UserDefaults.standard.string(forKey: "VIBSTATUS") == "1"){
            vibrationSwitch.setOn(true, animated: true)
        }
        
        setUpBackButton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
        })
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = false
        createShadow(view: mainView)
        firstView.layer.cornerRadius = 30.0
        
        pushSwitch.addTarget(self, action: #selector(pushSwitchChanged), for: UIControl.Event.valueChanged)
        smsSwitch.addTarget(self, action: #selector(smsSwitchChanged), for: UIControl.Event.valueChanged)
        sesSwitch.addTarget(self, action: #selector(sesSwitchChanged), for: UIControl.Event.valueChanged)
        vibrationSwitch.addTarget(self, action: #selector(vibSwitchChanged), for: UIControl.Event.valueChanged)




    }
    
    @objc func pushSwitchChanged(){
        if(pushSwitch.isOn){
            updateProfileDetails(notfName: "push_status", status: 1)
        }
        else
        {
            updateProfileDetails(notfName: "push_status", status: 0)

        }
    }
    
    
    @objc func smsSwitchChanged(){
          if(smsSwitch.isOn){
                  updateProfileDetails(notfName: "sms_status", status: 1)
              }
              else
              {
                  updateProfileDetails(notfName: "sms_status", status: 0)

              }
      }
    
    @objc func sesSwitchChanged(){
          if(sesSwitch.isOn){
                  updateProfileDetails(notfName: "sound_status", status: 1)
              }
              else
              {
                  updateProfileDetails(notfName: "sound_status", status: 0)

              }
      }
    
    @objc func vibSwitchChanged(){
          if(vibrationSwitch.isOn){
                  updateProfileDetails(notfName: "vibration_status", status: 1)
              }
              else
              {
                  updateProfileDetails(notfName: "vibration_status", status: 0)

              }
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
    
    func addQuestionView(){
         if let questionView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as? QuestionView {
            
            self.questionView = questionView
          //  self.questionIndicator = questionView.indicator
            questionView.yesBTN.layer.cornerRadius = 15.0
            questionView.cancelBtn.layer.cornerRadius = 15.0
            self.questionView.deleteView.isHidden = true
            self.questionView.indicator.isHidden = false
          
          //  let currentWindow: UIWindow? = UIApplication.shared.keyWindow
            questionView.frame = UIApplication.shared.keyWindow!.frame
            UIApplication.shared.keyWindow?.addSubview(questionView)
            
        }
    }
    
    func updateProfileDetails(notfName: String, status: Int){
            addQuestionView()
            
            let updateUrl = "http://209.97.140.82/api/v1/user/update/settings/\(notfName)/" + "\(status)"
            guard let url = URL(string: updateUrl) else {return}
          
            
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            
            urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 5.0
            sessionConfig.timeoutIntervalForResource = 60.0
            let session = URLSession(configuration: sessionConfig)
            
            session.dataTask(with: urlRequest){(data, response, error) in
                
                DispatchQueue.main.async {
                    self.questionView.removeFromSuperview()
                }
                
                if(error == nil){
                    guard let data = data else {return}
          
                    do{
                        let jsonData = try JSONDecoder().decode(UpdateNotfModel.self, from: data)
                        if(jsonData.status == "success"){
                           DispatchQueue.main.async {
                                self.view.makeToast("Bildiriş update edildi")
                            if(notfName == "push_status"){
                           //     UserDefaults.standard.removeObject(forKey: "PUSHSTATUS")
                                UserDefaults.standard.set("\(status)", forKey: "PUSHSTATUS")
                            }
                            if(notfName == "sms_status"){
                                 UserDefaults.standard.set("\(status)", forKey: "SMSSTATUS")
                            }
                            if(notfName == "sound_status"){
                                 UserDefaults.standard.set("\(status)", forKey: "SOUNDSTATUS")
                            }
                            if(notfName == "vibration_status"){
                                 UserDefaults.standard.set("\(status)", forKey: "VIBSTATUS")
                            }
                           }
                            }
                        else
                        {
                            DispatchQueue.main.async {
                                 self.view.makeToast("Xəta: Bildiriş update edilmədi")
                                if(notfName == "push_status"){
                                    self.pushSwitch.setOn(false, animated: true)
                                }
                                if(notfName == "sms_status"){
                                    self.smsSwitch.setOn(false, animated: true)
                                    
                                }
                                if(notfName == "sound_status"){
                                    self.sesSwitch.setOn(false, animated: true)
                                    
                                }
                                if(notfName == "vibration_status"){
                                    self.vibrationSwitch.setOn(false, animated: true)
                                    
                                }
                            }
                        }
                        
                    }
                        
                    catch _{
                        DispatchQueue.main.async {
                             self.view.makeToast("Xəta: Json Error")
                            if(notfName == "push_status"){
                                self.pushSwitch.setOn(false, animated: true)
                            }
                            if(notfName == "sms_status"){
                                self.smsSwitch.setOn(false, animated: true)
                                
                            }
                            if(notfName == "sound_status"){
                                self.sesSwitch.setOn(false, animated: true)
                                
                            }
                            if(notfName == "vibration_status"){
                                self.vibrationSwitch.setOn(false, animated: true)
                                
                            }
                        }
                       
                    }
                    
                }
                else
                {
                    
                    if let error = error as NSError?
                    {
                        if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                            DispatchQueue.main.async {
                                self.view.makeToast("Xəta: İnternet bağlantısını yoxlayın")

                            }
                            
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.view.makeToast("Bilinməyən xəta")
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        if(notfName == "push_status"){
                            self.pushSwitch.setOn(false, animated: true)
                        }
                        if(notfName == "sms_status"){
                            self.smsSwitch.setOn(false, animated: true)
                            
                        }
                        if(notfName == "sound_status"){
                            self.sesSwitch.setOn(false, animated: true)
                            
                        }
                        if(notfName == "vibration_status"){
                            self.vibrationSwitch.setOn(false, animated: true)
                            
                        }
                    }
                    
                    
                }
                }.resume()
        }
        

}
