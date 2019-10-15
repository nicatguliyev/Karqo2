//
//  DriverProfileDetailController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 10/10/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import Alamofire

struct DriverUserModel:Decodable{
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
    let car_brand: Car?
    let car_model: Car?
    let car_weight: Int?
    let car_tonnage_m3: Int?
    let car_tonnage_kq: Int?
    let car_type: Type?
    let work_practice: Int?
    let push_status: Int?
    let sms_status: Int?
    let sound_status: Int?
    let vibration_status: Int?
    let active: Int?
  
}


struct DriverProfileData:Decodable{
    let status: String?
    let data: DriverUserModel?
}

class DriverProfileDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var fieldsView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var numbersTable: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var filedsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var carWeightField: UITextField!
    @IBOutlet weak var carSelectBtn: CustomSelectButton!
    @IBOutlet weak var carSelectTextField: UITextField!
    @IBOutlet weak var modelSelectBtn: CustomSelectButton!
    @IBOutlet weak var volumeTextField: UITextField!
    @IBOutlet weak var halfCarWeightField: UITextField!
    @IBOutlet weak var carTypeSelectBtn: CustomSelectButton!
    @IBOutlet weak var carLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var carTypeLbl: UILabel!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    
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
    var markaPickerView = UIPickerView()
    var modelPickerView = UIPickerView()
    var tipPickerView = UIPickerView()
    var markalar = [Car]()
    var modeller = [Car]()
    var tipler = [Type]()
    
    var selectedCar: Car?
    var selectedModel: Car?
    var selectedCarType: Type?
    
    var selectedMarkaRow = 0
    var selectedModelRow = 0
    var selectedTypeRow = 0
    

  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addConnectionView()
        
        userImage.layer.cornerRadius = userImage.frame.height / 2
        setUpBackButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
            self.bottomView.roundCorners(corners: [.topRight], cornerRadius: 90.0)
        })
        createShadow(view: fieldsView)
       // getCars()
        getProfileDetails()
        
        
        markaPickerView.delegate = self
        markaPickerView.dataSource = self
        modelPickerView.delegate = self
        modelPickerView.dataSource = self
        tipPickerView.delegate = self
        tipPickerView.dataSource = self
        
        
        let markaGesture = UITapGestureRecognizer(target: self, action: #selector(markaTapped))
        markaGesture.cancelsTouchesInView = false
        carSelectBtn.isUserInteractionEnabled = true
        carSelectBtn.addGestureRecognizer(markaGesture)
        carSelectTextField.inputView = markaPickerView
        
        let modelGesture = UITapGestureRecognizer(target: self, action: #selector(modelTapped))
        modelGesture.cancelsTouchesInView = false
        modelSelectBtn.isUserInteractionEnabled = true
        modelSelectBtn.addGestureRecognizer(modelGesture)
        modelTextField.inputView = modelPickerView
        
        let tipGesture = UITapGestureRecognizer(target: self, action: #selector(tipTapped))
        tipGesture.cancelsTouchesInView = false
        carTypeSelectBtn.isUserInteractionEnabled = true
        carTypeSelectBtn.addGestureRecognizer(tipGesture)
        typeTextField.inputView = tipPickerView
        
        let bottomTap = UITapGestureRecognizer(target: self, action: #selector(bottomTapped))
        bottomView.isUserInteractionEnabled = true
        bottomView.addGestureRecognizer(bottomTap)
        
        imageController.delegate = self
        imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imageController.allowsEditing  = false
        
    }
    
    
    @objc func bottomTapped(){
        if(modeller.count != 0 ){
             updateProfileDetails()
        }
       
        
    }
    
    
    @objc func markaTapped(){
        carSelectTextField.becomeFirstResponder()
    }
    
    @objc func modelTapped(){
        modelTextField.becomeFirstResponder()
    }
    
    @objc func tipTapped(){
        typeTextField.becomeFirstResponder()
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
    
    @IBAction func userImageClicked(_ sender: Any) {
        
        self.present(imageController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil{
            
            selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            self.userImage.image = selectedImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib: [AddNumberCell] = Bundle.main.loadNibNamed("AddNumberCell", owner: self, options: nil) as! [AddNumberCell]
        let cell = nib[0]
        
        
        cell.textField.tag = indexPath.row
      //  cell.textField.delegate = self
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
        let cells = self.numbersTable.visibleCells as! Array<AddNumberCell>
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
        tableHeight.constant = CGFloat((numbers.count) * 50)
        filedsViewHeight.constant = 775 + CGFloat((numbers.count-1)*50)
        numbersTable.reloadData()
        
    }
    
    func addConnectionView(){
        if let connectionView = Bundle.main.loadNibNamed("CheckConnectionView", owner: self, options: nil)?.first as? CheckConnectionView {
             connectionView.frame = CGRect(x: 0, y: 75, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 75)
            self.view.addSubview(connectionView);
            connectionView.buttonView.clipsToBounds = true
            
            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.checkIndicator
            
            connectionView.tryButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        }
    }
    
    @objc func tryAgain(){
        //getCars()
        getProfileDetails()
    }
    
    func getProfileDetails(){
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        let userId = vars.user?.user?.id
        // tipler = []
        let driverDetailUrl = "http://209.97.140.82/api/v1/user/profile/\(userId!)"
        guard let url = URL(string: driverDetailUrl) else {return}
        print(driverDetailUrl)
        
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("Bearer " + (vars.user?.data?.token)!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 8.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: urlRequest){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                
               // let output =   String(data: data, encoding: String.Encoding.utf8)
          //       print("output: \(output)")
                
                do{
                    let jsonData = try JSONDecoder().decode(DriverProfileData.self, from: data)
                    if(jsonData.status == "success"){
                        let avatar = jsonData.data?.avatar
                     
                        DispatchQueue.main.async {
                            
                            if let avatar = avatar{
                                let avatarUrl = URL(string: avatar)
                                    self.userImage.sd_setImage(with: avatarUrl)
                            
                            }
                            self.nameTextField.text = jsonData.data?.name
                            self.userNameTextField.text = jsonData.data?.username
                            
                            if let carWeight =  jsonData.data?.car_weight{
                                self.carWeightField.text = String(describing: carWeight)
                            }
                            if let halfCarWeight = jsonData.data?.car_tonnage_kq{
                                self.halfCarWeightField.text = String(describing: halfCarWeight)
                            }
                            
                            if let halfCarVolume = jsonData.data?.car_tonnage_m3{
                                self.volumeTextField.text = String(describing: halfCarVolume)
                            }
                            
                            
                            self.numbers = jsonData.data?.phone?.components(separatedBy: ",") ?? [""]
                            self.tableHeight.constant = CGFloat((self.numbers.count) * 50)
                            self.filedsViewHeight.constant = 775 + CGFloat((self.numbers.count-1)*50)
                            self.numbersTable.reloadData()
                            
                            
                            self.selectedCar = jsonData.data?.car_brand
                            self.selectedModel = jsonData.data?.car_model
                            self.selectedCarType = jsonData.data?.car_type
                            
                            self.getCars()
                        }
                        
                    }
                    
                }
                    
                catch let jsonError{
                    print("JsonError: \(jsonError)")
                    DispatchQueue.main.async {
                        self.view.makeToast("Json Error")
                        self.connView.isHidden = true
                    }
                    
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
    
    func getCars(){
        
        markalar = []
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        let carUrl = "http://209.97.140.82/api/v1/car/list"
        guard let url = URL(string: carUrl) else {return}
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            
            
            
            if(error == nil){
                guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(CarData.self, from: data)
    
                    for i in 0..<jsonData.data.count{
                        self.markalar.append(jsonData.data[i])
                    }
                    
                    DispatchQueue.main.async {
                        self.markaPickerView.reloadAllComponents()
                        for i in 0..<self.markalar.count{
                            if(self.markalar[i].id == self.selectedCar?.id){
                                self.markaPickerView.selectRow(i, inComponent: 0, animated: true)
                                self.selectedMarkaRow = i
                                self.getModels(carId: jsonData.data[i].id!, type: 2)
                                self.carLbl.text = self.markalar[i].title
                            }
                        }
                    }
                    
                }
                    
                catch _{
                   // print("JsonError")
                    DispatchQueue.main.async {
                        self.connView.isHidden = true
                    }
                }
                
            }
            else
            {
                
                if let error = error as NSError?
                {
                    print("ErrorCode: \(error.code)")
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        
                        DispatchQueue.main.async {
                            
                            self.connView.isHidden = false
                            self.checkConnIndicator.isHidden = true
                            self.checkConnButtonView.isHidden = false
                            
                        }
                    }
                }
            }
            }.resume()
    }
    
    func getModels(carId: Int, type: Int){
        modeller = []
        selectedModelRow = 0
        let carUrl = "http://209.97.140.82/api/v1/car/" + "\(carId)" + "/model/list"
        guard let url = URL(string: carUrl) else {return}
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            
            
            
            if(error == nil){
                guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(CarData.self, from: data)
                    for i in 0..<jsonData.data.count{
                        self.modeller.append(jsonData.data[i])
                    }
                    DispatchQueue.main.async {
                        self.modelPickerView.reloadAllComponents()
                        
                        if(type == 1){
                            self.modelPickerView.selectRow(0, inComponent: 0, animated: true)
                            self.modelLbl.text = self.modeller[0].title
                            
                        }
                        else
                        {
                            for i in 0..<self.modeller.count{
                                if(self.modeller[i].id == self.selectedModel?.id){
                                    self.modelPickerView.selectRow(i, inComponent: 0, animated: true)
                                    self.modelLbl.text = self.modeller[i].title
                                    self.selectedModelRow = i
                                    self.getCarTypes()
                                }
                            }
                        }
                        
                        
                        self.modelSelectBtn.isUserInteractionEnabled = true
                    }
                }
                    
                catch _{
                    DispatchQueue.main.async {
                        self.view.makeToast("Model Json Error")
                        self.connView.isHidden = true
                    }
                }
                
            }
            else
            {
                
                if let error = error as NSError?
                {
                    
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        DispatchQueue.main.async {
                            self.connView.isHidden = false
                            self.checkConnIndicator.isHidden = true
                            self.checkConnButtonView.isHidden = false
                        }
                        
                    }
                }
            }
            
            
            }.resume()
    }
    
    func getCarTypes(){
        tipler = []
        let carUrl = "http://209.97.140.82/api/v1/car/types"
        guard let url = URL(string: carUrl) else {return}
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(CarTypeData.self, from: data)
                    for i in 0..<jsonData.data.count{
                        self.tipler.append(jsonData.data[i])
                    }
                    
                    DispatchQueue.main.async {
                        self.connView.isHidden = true
                        self.tipPickerView.reloadAllComponents()
                        
                        for i in 0..<self.tipler.count{
                            if(self.tipler[i].id == self.selectedCarType?.id){
                                self.selectedTypeRow = i
                                self.tipPickerView.selectRow(i, inComponent: 0, animated: true)
                                self.carTypeLbl.text = self.tipler[i].name
                            }
                        }
                        
                    }
                }
                    
                catch _{
                    DispatchQueue.main.async {
                        self.view.makeToast("CarType Json Error")
                        self.connView.isHidden = true
                    }
                }
                
            }
            else
            {
                
                
                if let error = error as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        DispatchQueue.main.async {
                            self.connView.isHidden = false
                            self.checkConnIndicator.isHidden = true
                            self.checkConnButtonView.isHidden = false
                        }
                    }
                }
            }
            
            
            }.resume()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == markaPickerView)
        {
            return markalar.count
        }
        else if(pickerView == modelPickerView){
            return modeller.count
        }
        else {
            return tipler.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == markaPickerView){
            return markalar[row].title
        }
        else if(pickerView == modelPickerView)
        {
            return modeller[row].title
        }
        else
        {
            return tipler[row].name
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == markaPickerView){
            modelLbl.text = "----"
            modelSelectBtn.isUserInteractionEnabled = false
            getModels(carId: markalar[row].id!, type: 1)
            carLbl.text = markalar[row].title
            selectedMarkaRow = row
        }
        if(pickerView == modelPickerView){
            modelLbl.text = modeller[row].title
            selectedModelRow = row
        }
        if(pickerView == tipPickerView){
            carTypeLbl.text = tipler[row].name
            selectedTypeRow = row
        }
    }
    
    func updateAvatar(){
        connView.isHidden = false
        checkConnIndicator.isHidden = false
        checkConnButtonView.isHidden = true
        
        let headers = [
            "Authorization": "Bearer " + (vars.user?.data?.token)!,
            "Content-type":"multipart/form-data",
            "Content-Disposition":"form-data"
            
        ]
        
        let imgData = selectedImage!.jpegData(compressionQuality: 0.2)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            
            if let imgData = imgData{
                multipartFormData.append(imgData, withName: "avatar",fileName: "profile.png", mimeType: "image/png")
            }
            
        }, usingThreshold:UInt64.init(),
           to: "http://209.97.140.82/api/v1/user/update/avatar", //URL Here
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
                                                controller.changeProfileImage(x: responseData.avatar ?? "")
                                            }
                                        }
                                    }
                                    else
                                    {
                                        DispatchQueue.main.async {
                                            self.view.makeToast("Xəta: Profil şəkili dəyişdirilmədi")
                                            //self.userImage.image = nil
                                        }
                                    }
                                }
                                    
                                    
                                    
                                catch{
                                    
                                    DispatchQueue.main.async {
                                        self.view.makeToast("Xəta: Json Error. Profil şəkili dəyişdirilmədi")
                                        //self.userImage.image = nil
                                    }
                                }
                                
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    self.view.makeToast("Xəta \(responseCode): Profil şəkili dəyişdirilmədi")
                                   // self.userImage.image = nil
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
    
    func updateProfileDetails(){
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        let updateUrl = "http://209.97.140.82/api/v1/user/update/general"
        guard let url = URL(string: updateUrl) else {return}
        
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("Bearer " + (vars.user?.data?.token)!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var filteredNumbers = [String]()
        
        let cells = self.numbersTable.visibleCells as! Array<AddNumberCell>
        for cell in cells {
            if(cell.textField.text != ""){
                filteredNumbers.append(cell.textField.text!)
            }
        }
        
        
        let parameters: [String: Any] = [
            "name": nameTextField.text!,
            "username": userNameTextField.text!,
            "phone": filteredNumbers.joined(separator: ","),
            "car_model":"\(modeller[selectedModelRow].id ?? 0)",
            "car_brand":"\(markalar[selectedMarkaRow].id ?? 0)",
            "car_weight":"\(carWeightField.text ?? "")",
            "car_tonnage_kq": "\(halfCarWeightField.text ?? "")",
            "car_tonnage_m3": "\(volumeTextField.text ?? "")",
            "car_type": "\(tipler[selectedTypeRow].id ?? 0)",
            "work_practice": "7"
        ]
        
        
        urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: urlRequest){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                
                do{
                    let jsonData = try JSONDecoder().decode(ProfileDetailModel.self, from: data)
                    if(jsonData.status == "success"){
                        
                        DispatchQueue.main.async {
                            if let controller  = MenuViewController.staticSelf{
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToErrorController"){
            let VC = segue.destination as! ErrorMessageController
            VC.errorMessages = self.errorMessages
        }
       
        //   if(segue)
    }
    
    

    
}
