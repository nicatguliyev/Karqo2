//
//  ChangePasswordController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/22/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class ChangePasswordController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var bottomView: SenedeBaxButtonView!
    
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var replyNewPassword: UITextField!
    @IBOutlet weak var basliqLbl: UILabel!
    @IBOutlet weak var oldPassLbl: UILabel!
    @IBOutlet weak var newPassLbl: UILabel!
    @IBOutlet weak var repeatPassLbl: UILabel!
    @IBOutlet weak var saveLbl: UILabel!
    
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    var errorMessages = [String]()
    var selectedLang: String?
    
    var iconClick1 = false
    var iconClick2 = false
    var iconClick3 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLang = UserDefaults.standard.string(forKey: "Lang")
        basliqLbl.text = "change_password".addLocalizableString(str: selectedLang!)
        newPassLbl.text = "new_pass".addLocalizableString(str: selectedLang!)
        oldPassLbl.text = "old_pass".addLocalizableString(str: selectedLang!)
        repeatPassLbl.text = "new_pass_confirm".addLocalizableString(str: selectedLang!)
        saveLbl.text = "save".addLocalizableString(str: selectedLang!)
        
        addConnectionView()
        setUpBackButton()
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
            self.bottomView.roundCorners(corners: [.topRight], cornerRadius: 90.0)
        })
        createShadow(view: mainView)
        
        let bottomTap = UITapGestureRecognizer(target: self, action: #selector(bottomTapped))
        bottomView.isUserInteractionEnabled  = true
        bottomView.addGestureRecognizer(bottomTap)
        //bottomView.setNeedsLayout()
        // added new line
        
//        let test = CustomActionBar(url: "http://209.97.140.82/api/v1/valyuta/list")
//        test.getValyutas { (data, error) in
//            if(data != nil){
//                do{
//                    let jsonData = try JSONDecoder().decode(ValyutaListData.self, from: data!)
//                    print(jsonData)
//                }
//                catch{
//                    print("JsonXeta")
//                }
//                if(error != nil){
//                  //  print(error)
//                }
//               // let jsonData = try JSONDecoder().decode(ValyutaListData.self, from: data)
//            }
//        }
        
    }
    
    @objc func bottomTapped(){
        updatePassword()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == oldPassword){
            newPassword.becomeFirstResponder()
        }
        else if(textField == newPassword){
            replyNewPassword.becomeFirstResponder()
        }
        else
        {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 0
        //let cells = self.numbersTable.visibleCells as! Array<AddNumberCell>
        
        if(textField == oldPassword || textField == newPassword || textField == replyNewPassword){
            maxLength = 30
        }
        else
        {
            maxLength = 16
        }
        
        
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    func addConnectionView(){
        if let connectionView = Bundle.main.loadNibNamed("CheckConnectionView", owner: self, options: nil)?.first as? CheckConnectionView {
            connectionView.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 80)
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
    
    
    func updatePassword(){
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        let updateUrl = "http://carryup.az/api/v1/user/update/password"
        guard let url = URL(string: updateUrl) else {return}
        
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let parameters: [String: Any] = [
            "old_password": oldPassword.text!,
            "password": newPassword.text!,
            "password_confirmation": replyNewPassword.text!
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
                
                do{
                    let jsonData = try JSONDecoder().decode(ProfileDetailModel.self, from: data)
                    if(jsonData.status == "success"){
                        
                        DispatchQueue.main.async {
                             self.view.makeToast("Sifre deyisdirildi")
                        }
                    }
                    else
                    {
                        self.errorMessages = []
                        let requiredList = jsonData.error!
                        for i in 0..<requiredList.count{
                            self.errorMessages.append(requiredList[i])
                        }
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "segueToErrorController", sender: self)

                        }
                    }
                    
                }
                    
                catch _{
                    DispatchQueue.main.async {
                        self.connView.isHidden = true
                        self.view.makeToast("Xəta: Json Error")
                    }
                    
                }
                
            }
            else
            {
                
                if let error = error as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        DispatchQueue.main.async {
                            self.connView.isHidden = true
                            self.view.makeToast("Xəta: İnternet bağlantısını yoxlayın")
                            
                        }
                        
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.connView.isHidden = true
                        self.view.makeToast("Bilinməyən xəta")
                        
                    }
                }
            }
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToErrorController"){
            let VC = segue.destination as! ErrorMessageController
            VC.errorMessages = self.errorMessages
        }
    }
    
    @IBAction func showOldPass(_ sender: Any) {
        if(iconClick1 == false){
                   oldPassword.isSecureTextEntry = false
               }
               else{
                   oldPassword.isSecureTextEntry = true
               }
               iconClick1 = !iconClick1
    }
    
    @IBAction func showNewPass(_ sender: Any) {
        if(iconClick2 == false){
                   newPassword.isSecureTextEntry = false
               }
               else{
                   newPassword.isSecureTextEntry = true
               }
               iconClick2 = !iconClick2
    }
    
    @IBAction func showRepeatPass(_ sender: Any) {
        if(iconClick3 == false){
                   replyNewPassword.isSecureTextEntry = false
               }
               else{
                   replyNewPassword.isSecureTextEntry = true
               }
               iconClick3 = !iconClick3
    }
    
}
