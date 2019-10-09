//
//  LoginController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/5/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class Global {
    var userName = ""
    var user: LoginDataModel?
}

struct LoginDataModel:Decodable {
    let status: String?
    let user: UserModel?
    let data: UserTokenModel?
    
}
struct UserModel:Decodable{
    let id: Int?
    let role_id: Int?
    let username: String?
    let name: String?
    let avatar: String?
    let email: String?
    let phone: String?
    let foreign_passport: String?
    let car_register_doc: String?
    let half_car_register_doc: String?
    let car_brand: Int?
    let car_model: Int?
    let car_tonnage_m3: Int?
    let car_tonnage_kq: Int?
    let car_type: Int?
    let work_practice: Int?
    let push_status: Int?
    let sms_status: Int?
    let sound_status: Int?
    let vibration_status: Int?
    let active: Int?
    //let settings: [String: String]?
  //  let settings: [UserSettingModel]?
}
struct UserSettingModel:Decodable {
    let locale: String?
    
}
struct UserTokenModel:Decodable {
    let token: String?
}
var vars = Global()

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    var userName = ""
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameView.layer.cornerRadius = 2
        passwordView.layer.cornerRadius = 2
        loginBtn.layer.cornerRadius = 30
        
        addConnectionView()

    }
    
    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == userTextField){
            passTextField.becomeFirstResponder()
        }
        else
        {
            passTextField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func loginClicked(_ sender: Any) {
      //  vars.userName = userTextField.text!
    //    performSegue(withIdentifier: "segueToSWReveal", sender: self)
        loginUser(userName: userTextField.text!, password: passTextField.text!)
    }
    
    func addConnectionView(){
        if let connectionView = Bundle.main.loadNibNamed("CheckConnectionView", owner: self, options: nil)?.first as? CheckConnectionView {
            connectionView.frame = CGRect(x: 0, y: 2.7/10 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 2.7/10 * UIScreen.main.bounds.height)
            self.view.addSubview(connectionView);
            connectionView.buttonView.clipsToBounds = true
            
            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.checkIndicator
            
            connView.isHidden = true
            
            connectionView.tryButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        }
    }
    
    @objc func tryAgain(){
        
    }
    
    
    func loginUser(userName:String, password:String){
        
        self.view.endEditing(true)
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
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
                self.connView.isHidden = true
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
                                self.performSegue(withIdentifier: "segueToSWReveal", sender: self)
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

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

