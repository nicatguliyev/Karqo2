//
//  SuccessRegisterController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 9/3/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import OneSignal

class SuccessRegisterController: UIViewController {
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var userName = ""
    var password = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        loginView.layer.cornerRadius = 25
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        loginView.isUserInteractionEnabled = true
        loginView.addGestureRecognizer(tapGesture)

    }
    
    @objc func loginTapped(){
      //  performSegue(withIdentifier: "segueToMain", sender: self)
        loginUser(userName: userName, password: password)
    }
    
    
    func loginUser(userName:String, password:String){
        
        self.view.endEditing(true)
        self.indicator.isHidden = false
        
        let loginUrl = "http://209.97.140.82/api/v1/user/login"
        
        guard let url = URL(string: loginUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "username": userName,
            "password": password
        ]
        
        
        urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: urlRequest){(data, response, error) in
            
            DispatchQueue.main.async {
                self.indicator.isHidden = true
            }
            
            if(error == nil){
                guard let data = data else {return}
                
                let outputStr  = String(data: data, encoding: String.Encoding.utf8)
                do{
                    
                    if let outputStr = outputStr{
                        if(outputStr.contains("Unauthorized"))
                        {
                            DispatchQueue.main.async {
                                self.view.makeToast("Username veya password sehvdir")
                            }
                        }
                        else
                        {
                            let userModel = try JSONDecoder().decode(LoginDataModel.self, from: data)
                            vars.user = userModel
                            DispatchQueue.main.async {
                                OneSignal.sendTag("user_id", value: "\((userModel.user?.id)!)")
                                UserDefaults.standard.set("\((userModel.user?.id)!)", forKey: "USERID")
                                UserDefaults.standard.set("\((userModel.data?.token)!)", forKey: "USERTOKEN")
                                UserDefaults.standard.set("\((userModel.user?.role_id)!)", forKey: "USERROLE")
                                UserDefaults.standard.set("\((userModel.user?.name)!)", forKey: "USERNAME")
                                UserDefaults.standard.set("\((userModel.user?.phone)!)", forKey: "USERPHONE")
                                UserDefaults.standard.set("\((userModel.user?.avatar ?? ""))", forKey: "USERAVATAR")
                                UserDefaults.standard.set("\((userModel.user?.push_status)!)", forKey: "PUSHSTATUS")
                                UserDefaults.standard.set("\((userModel.user?.sms_status)!)", forKey: "SMSSTATUS")
                                UserDefaults.standard.set("\((userModel.user?.sound_status)!)", forKey: "SOUNDSTATUS")
                                UserDefaults.standard.set("\((userModel.user?.vibration_status)!)", forKey: "VIBSTATUS")
                                self.performSegue(withIdentifier: "segueToMain", sender: self)
                                //self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                    
                    
                }
                    
                catch let jsonError{
                    DispatchQueue.main.async {
                        print(jsonError)
                        self.view.makeToast("Model Json Error")
                    }
                    
                }
            }
            else
            {
                
                if let error = error as NSError?
                {
                    
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        DispatchQueue.main.async {
                            self.view.makeToast("İnternet bağlantısını yoxlayın")
                        }
                        
                    }
                }
            }
            
            
            }.resume()
    }
}

