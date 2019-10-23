//
//  DriverRegController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 9/4/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import Alamofire

class DriverRegController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    var rowCount = 1
    var numbers = [""]
    @IBOutlet weak var numbersTable: UITableView!
    @IBOutlet weak var numberTableHeight: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bottomView: SenedeBaxButtonView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var voenTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    
    var errorMessages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bottomView.roundCorners(corners: [.topRight], cornerRadius: 90.0)
        })
        
        addConnectionView()
        
        let bottomViewGesture = UITapGestureRecognizer(target: self, action: #selector(registerClicked))
        bottomView.isUserInteractionEnabled = true
        bottomView.addGestureRecognizer(bottomViewGesture)
        
        

    }
    
    @objc func registerClicked(){
        registerUser()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib: [AddNumberCell] = Bundle.main.loadNibNamed("AddNumberCell", owner: self, options: nil) as! [AddNumberCell]
        let cell = nib[0]
        
        
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
        cell.textField.text = numbers[indexPath.row]
        
        if (indexPath.row == 4) {
            cell.addBtn.isHidden = true
        }
        else
        {
            cell.addBtn.isHidden = false
        }
        
        if(indexPath.row == numbers.count - 1){
            cell.addBtn.setImage(UIImage(named: "plus-button.png"), for: .normal)
        }
        else
        {
            cell.addBtn.setImage(UIImage(named: "minus.png"), for: .normal)
        }
        
        cell.addBtn.tag = indexPath.row
        cell.addBtn.addTarget(self, action: #selector(addClciked), for: .touchUpInside)
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func addClciked(sender: UIButton){
        let cells = self.numbersTable.visibleCells as! Array<AddNumberCell>
        for i in 0..<cells.count{
            numbers[i] = cells[i].textField.text!
        }
        
        if(sender.tag == numbers.count - 1){
            if(sender.tag != 4){
                numbers.append("")
            }
            
        }
        else
        {
            numbers.remove(at: sender.tag)
        }
        numberTableHeight.constant = CGFloat((numbers.count) * 50)
        numbersTable.reloadData()
        
    }
    

    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    func registerUser(){
        
        connView.isHidden = false
        checkConnIndicator.isHidden = false
        checkConnButtonView.isHidden = true
        
        var filteredNumbers = [String]()

        
        let cells = self.numbersTable.visibleCells as! Array<AddNumberCell>
        for cell in cells {
            if(cell.textField.text != ""){
                filteredNumbers.append(cell.textField.text!)
            }
        }
        
        let parameters = [
            "role_id":"4",
            "name":"\(nameTextField.text ?? "")",
            "username":"\(userNameTextField.text ?? "")",
            "password":"\(passwordTextField.text ?? "")",
            "phone":filteredNumbers.joined(separator: ","),  // Arraydeki elementleri vergul ile birlesdirir
            "password_confirmation":"\(repeatPasswordTextField.text ?? "")",
            "voen":voenTextField.text ?? ""
        ]
        
        let headers = [
            "Content-type":"multipart/form-data",
            "Content-Disposition":"form-data"
        ]

        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold:UInt64.init(),
           to: "http://209.97.140.82/api/v1/user/register", //URL Here
            method: .post,
            headers: headers, //pass header dictionary here
            encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):

                    upload.responseString { response in
                        
                        self.connView.isHidden = true
                         guard let data = response.data else {return}
                        
                        if let responseCode = response.response?.statusCode{
                            if(responseCode == 413)
                            {
                                self.view.makeToast("Şəkillərin həcmi çoxdur")
                            }
                            if(responseCode == 200)
                            {
                                
                                do {
                                    let responseData = try JSONDecoder().decode(AddOrderSuccessModel.self, from: data)
                                                                        if(responseData.status == "error"){
                                                                            self.errorMessages = []
                                                                            let requiredList = responseData.error!
                                                                            for i in 0..<requiredList.count{
                                                                                self.errorMessages.append(requiredList[i])
                                                                            }
                                                                            self.performSegue(withIdentifier: "segueToErrorController", sender: self)
                                                                        }
                                                                        else{
                                                                             self.performSegue(withIdentifier: "segueToSuccess2", sender: self)
                                    }
                                }
                                    
                                catch{
                                    DispatchQueue.main.async {
                                        self.view.makeToast("Json Error")
                        
                                    }
                                }
                            }
                        }
                        
                        if let error = response.error as NSError?
                        {
                            if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                                self.view.makeToast("Bağlantı xətası. Yenidən yoxlayın")
                            }
                        }
                        
                    }
                    
                    break
                case .failure(let error):
                    print("the error is  : \(error.localizedDescription)")
                    self.connView.isHidden = true
                    self.view.makeToast("Bilinməyən xəta")
                    break
                    
                    
                    
                }
        })
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 0
        
        if(textField == nameTextField || textField == passwordTextField || textField == repeatPasswordTextField){
            maxLength = 30
        }
        else if(textField == userNameTextField){
            maxLength = 20
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToErrorController"){
            let VC = segue.destination as! ErrorMessageController
            VC.errorMessages = self.errorMessages
        }
        
        if(segue.identifier == "segueToSuccess2"){
            let VC = segue.destination as! SuccessRegisterController
            VC.userName = self.userNameTextField.text!
            VC.password = self.passwordTextField.text!
        }
    }
    
    

}
