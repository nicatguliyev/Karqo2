//
//  ProfileDetailController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/22/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import Alamofire

struct ProfileDetailModel:Decodable {
    let status: String?
    let data: UserModel?
    let error: [String]?
}

class ProfileDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    

    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var fieldsView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var bottomView: SenedeBaxButtonView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fieldHeight: NSLayoutConstraint!
    @IBOutlet weak var basliqLbl: UILabel!
    @IBOutlet weak var nameSurnameLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var saveLbl: UILabel!
    
    
    var imageController = UIImagePickerController()
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    var numbers = [""]
    var newRowInserted = false
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    var selectedImage: UIImage?
    var errorMessages = [String]()
    var selectedLang: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLang  = UserDefaults.standard.string(forKey: "Lang")
        basliqLbl.text = "my_profile_info".addLocalizableString(str: selectedLang!)
        nameSurnameLbl.text = "name_surname".addLocalizableString(str: selectedLang!)
        userNameLbl.text = "username".addLocalizableString(str: selectedLang!)
        phoneLbl.text = "contact_number".addLocalizableString(str: selectedLang!)
        saveLbl.text = "save".addLocalizableString(str: selectedLang!)
        
        setUpBackButton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
            self.bottomView.roundCorners(corners: [.topRight], cornerRadius: 90.0)
        })
        
        createShadow(view: fieldsView)
        userImage.layer.cornerRadius = userImage.layer.frame.height / 2
       // phoneTextField.text = phoneTextField.text?.format("(+NNN) NN NNN NN NN", oldString: phoneTextField.text!)
        addConnectionView()
        getProfileDetails()
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = false
        
        imageController.delegate = self
        imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imageController.allowsEditing  = false
        
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(imageTap)
        
        let bottomTap = UITapGestureRecognizer(target: self, action: #selector(bottomTapped))
        bottomView.isUserInteractionEnabled = true
        bottomView.addGestureRecognizer(bottomTap)
        

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
    
    @objc func bottomTapped(){
        updateProfileDetails()
      // updateAvatar()
    }
    
    @objc func userImageTapped(){
      //  self.present(imageController, animated: true, completion: nil)
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
        if(textField == nameTextField){
            cityTextField.becomeFirstResponder()
        }
        else if(textField == cityTextField){
            mailTextField.becomeFirstResponder()
        }
        else if(textField == mailTextField){
            phoneTextField.becomeFirstResponder()
        }
        else{
            self.view.endEditing(true)
        }
        return true
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
        
        if(indexPath.row != 0 && indexPath.row == numbers.count-1 && newRowInserted == true)
        {
            cell.textField.becomeFirstResponder()
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func addClciked(sender: UIButton){
        let cells = self.phoneTableView.visibleCells as! Array<AddNumberCell>
        for i in 0..<cells.count{
            numbers[i] = cells[i].textField.text!
    
        }
        
        if(sender.tag == numbers.count - 1){
            if(sender.tag != 4){
                numbers.append("")
                newRowInserted = true
            }
            
            
        }
        else
        {
            newRowInserted = false
            numbers.remove(at: sender.tag)
        }
        tableViewHeight.constant = CGFloat((numbers.count) * 50)
        fieldHeight.constant = 320 + CGFloat((numbers.count-1)*50)
        phoneTableView.reloadData()
        
    }
    
    
    func addConnectionView(){
        if let connectionView = Bundle.main.loadNibNamed("CheckConnectionView", owner: self, options: nil)?.first as? CheckConnectionView {
            connectionView.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 80)
            self.view.addSubview(connectionView);
            connectionView.buttonView.clipsToBounds = true
            
            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.checkIndicator
            
             connectionView.tryButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
            
        }
    }
    
    @objc func tryAgain(){
        getProfileDetails()
    }
    
    
    func getProfileDetails(){
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        let userId = (UserDefaults.standard.string(forKey: "USERID"))!
        // tipler = []
        let driverDetailUrl = "http://carryup.az/api/v1/user/profile/\(userId)"
        guard let url = URL(string: driverDetailUrl) else {return}
        print(driverDetailUrl)
        
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 8.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: urlRequest){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                
               // let output =   String(data: data, encoding: String.Encoding.utf8)
               // print("output: \(output)")
                
                do{
                    let jsonData = try JSONDecoder().decode(ProfileDetailModel.self, from: data)
                    if(jsonData.status == "success"){
                        let avatar = jsonData.data?.avatar
                        if let avatar = avatar{
                            let avatarUrl = URL(string: avatar)
                            DispatchQueue.main.async {
                                self.userImage.sd_setImage(with: avatarUrl)
                               
                            }
                        }
                        DispatchQueue.main.async {
                             self.nameTextField.text = jsonData.data?.name
                             self.cityTextField.text = jsonData.data?.username
                             self.numbers = jsonData.data?.phone?.components(separatedBy: ",") ?? [""]
                             self.tableViewHeight.constant = CGFloat((self.numbers.count) * 50)
                             self.fieldHeight.constant = 320 + CGFloat((self.numbers.count-1)*50)
                             self.phoneTableView.reloadData()
                        }
                       
                        
                    }
                  
                    
                }
                    
                catch let jsonError{
                    print("JsonError: \(jsonError)")
                    DispatchQueue.main.async {
                        self.view.makeToast("Json Error")
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.connView.isHidden = true
                }
            }
            else
            {
                
                
                if let error = error as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        DispatchQueue.main.async {
                            self.checkConnIndicator.isHidden = true
                            self.checkConnButtonView.isHidden = false
                        }
                       
                    }
                }
            }
            
            
            }.resume()
    }
    
    
    
    func updateProfileDetails(){
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        let updateUrl = "http://carryup.az/api/v1/user/update/general"
        guard let url = URL(string: updateUrl) else {return}
      
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var filteredNumbers = [String]()
        
        
        let cells = self.phoneTableView.visibleCells as! Array<AddNumberCell>
        for cell in cells {
            if(cell.textField.text != ""){
                filteredNumbers.append(cell.textField.text!)
            }
        }
        
   
        let parameters: [String: Any] = [
            "name": nameTextField.text!,
            "username": cityTextField.text!,
            "phone": filteredNumbers.joined(separator: ",")
        ]
        
        
        urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: urlRequest){(data, response, error) in
            
            
//            DispatchQueue.main.async {
//                self.connView.isHidden = true
//            }
            
            if(error == nil){
                guard let data = data else {return}
      
                do{
                    let jsonData = try JSONDecoder().decode(ProfileDetailModel.self, from: data)
                    if(jsonData.status == "success"){
                       
                            DispatchQueue.main.async {
                                if let controller  = MenuViewController.staticSelf{
                                    UserDefaults.standard.set(self.nameTextField.text!, forKey: "USERNAME")
                                    UserDefaults.standard.set(filteredNumbers[0], forKey: "USERPHONE")

                                    controller.changeName(x: self.nameTextField.text!)
                                    controller.changePhoneNumber(x: filteredNumbers[0])
                                }
                                if(self.selectedImage != nil){
                                     self.updateAvatar()
                                }
                                else{
                                    self.connView.isHidden = true
                                    self.view.makeToast("Profil məlumatları dəyişdirildi")
                                }
                                
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
                            self.connView.isHidden = true
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
    
    
    func updateAvatar(){
        
        connView.isHidden = false
        checkConnIndicator.isHidden = false
        checkConnButtonView.isHidden = true
        
        let headers = [
            "Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!,
            "Content-type":"multipart/form-data",
            "Content-Disposition":"form-data"
            
        ]
        
        let imgData = selectedImage!.jpegData(compressionQuality: 0.2)
   
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            
            if let imgData = imgData{
                multipartFormData.append(imgData, withName: "avatar",fileName: "profile.png", mimeType: "image/png")
            }
            
        }, usingThreshold:UInt64.init(),
           to: "http://carryup.az/api/v1/user/update/avatar", //URL Here
            method: .post,
            headers: headers, //pass header dictionary here
            encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseString { response in
                        
                        self.connView.isHidden = true
                        guard let data = response.data else {return}
                        
                        
                        if let responseCode = response.response?.statusCode{
                            
                            if(responseCode == 200)
                            {
                            
                               
                                do {
                                    let responseData = try JSONDecoder().decode(AddOrderSuccessModel.self, from: data)
                                    if(responseData.status == "success"){
                                        self.selectedImage = nil
                                        DispatchQueue.main.async {
                                         self.view.makeToast("Profil məlumatları  dəyişdirildi")
                                            if let controller  = MenuViewController.staticSelf{
                                                UserDefaults.standard.set(responseData.avatar ?? "", forKey: "USERAVATAR")
                                                controller.changeProfileImage(x: responseData.avatar ?? "")
                                            }
                                        }
                                    }
                                    else
                                    {
                                        DispatchQueue.main.async {
                                            self.view.makeToast("Xəta: Profil şəkili dəyişdirilmədi")
                                        }
                                    }
                                }
                                    
                        
                                    
                                catch{
                                    
                                    DispatchQueue.main.async {
                                        self.view.makeToast("Xəta: Json Error. Profil şəkili dəyişdirilmədi")
                                    }
                                }
                                
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    self.view.makeToast("Xəta \(responseCode): Profil şəkili dəyişdirilmədi")
                                }
                            }
                        }
                        
                        if let error = response.error as NSError?
                        {
                            if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                                self.view.makeToast("Profil şəkili dəyişdirilmədi. İnternet bağlantısını yoxlayın")
                            }
                            else{
                                self.view.makeToast("Bilinməyən xəta. Profil şəkili dəyişdirilmədi")
                            }
                            
                        }
                       
                    }
                    
                    break
                case .failure( _):
                    self.connView.isHidden = true
                    //print(error)
                    self.view.makeToast("Bilinməyən xəta. Profil şəkili dəyişdirilmədi")
                    break
                }
        })
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil{
            
                selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                self.userImage.image = selectedImage
    
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func imageBtnClicked(_ sender: Any) {
         self.present(imageController, animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToErrorController"){
            let VC = segue.destination as! ErrorMessageController
            VC.errorMessages = self.errorMessages
        }
      //   if(segue)
    }
  
    

    
}

extension ProfileDetailController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 0
        //let cells = self.numbersTable.visibleCells as! Array<AddNumberCell>
        
        if(nameTextField == textField ){
            maxLength = 30
        }
        else if(cityTextField == textField){
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
        
    
    
    
}
