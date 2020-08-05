//
//  CustomerRegController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/4/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire

struct CarData:Decodable {
   let  data:[Car]
}

struct Car:Decodable {
    let id: Int?
    let code: String?
    let title: String?
    
}

struct CarTypeData:Decodable{
    let data:[Type]
}

struct Type:Decodable {
    let id: Int?
    let name: String?
}

class CustomerRegController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate{

    var rowCount = 1
    @IBOutlet weak var numbersTable: UITableView!
    var numbers = [""]
    var pickerTextFileds = [UITextField]()
    var operatorPickerView = UIPickerView()
    var markaPickerView = UIPickerView()
    var modelPickerView = UIPickerView()
    var tipPickerView = UIPickerView()
    var operators = ["+994", "+995", "+996", "+997"]
    var prefixs = [String]()
    var prefixLbls = [UILabel]()
    var clickedOperatorIndex = 0
    @IBOutlet weak var bottomView: SenedeBaxButtonView!
    @IBOutlet weak var browse1Btn: UIButton!
    @IBOutlet weak var browse2Btn: UIButton!
    @IBOutlet weak var browse3Btn: UIButton!
    @IBOutlet weak var browse1ImageBtn: UIButton!
    @IBOutlet weak var browseLeftConst1: NSLayoutConstraint!
    @IBOutlet weak var browseLeftConst2: NSLayoutConstraint!
    @IBOutlet weak var browseLeftConst3: NSLayoutConstraint!
    @IBOutlet weak var image01Btn: UIButton!
    @IBOutlet weak var image02Btn: UIButton!
    @IBOutlet weak var image03Btn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var stajLbl: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var carWeightTextField: UITextField!
    @IBOutlet weak var halfCarVolumeTextField: UITextField!
    @IBOutlet weak var halfCarWeightTextField: UITextField!
    @IBOutlet weak var stajTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var image1Controller = UIImagePickerController()
    var image2Controller = UIImagePickerController()
    var image3Controller = UIImagePickerController()
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()

    @IBOutlet weak var markaTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var modelLbl: UILabel!
    
    
    @IBOutlet weak var stajSelectView: CustomSelectButton!
    @IBOutlet weak var markaSelectView: CustomSelectButton!
    @IBOutlet weak var markaLbl: UILabel!
    @IBOutlet weak var modelSelectView: CustomSelectButton!
    @IBOutlet weak var tipSelectView: CustomSelectButton!
    @IBOutlet weak var tipLbl: UILabel!
    
    @IBOutlet weak var driverInfoLbl: UILabel!
    @IBOutlet weak var nameSurnameLbl: UILabel!
    @IBOutlet weak var foreginPassportLbl: UILabel!
    @IBOutlet weak var registerPassportLbl: UILabel!
    @IBOutlet weak var semiRegisterPassportLbl: UILabel!
    @IBOutlet weak var workExperienceLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var repeatPasswordLbl: UILabel!
    @IBOutlet weak var carInfoLbl: UILabel!
    @IBOutlet weak var brendLbl: UILabel!
    @IBOutlet weak var carWeightLbl: UILabel!
    @IBOutlet weak var semiCarInfoLbl: UILabel!
    @IBOutlet weak var semiCarVolumeLbl: UILabel!
    @IBOutlet weak var semiCarWeightLbl: UILabel!
    @IBOutlet weak var semiCarTypeLbl: UILabel!
    @IBOutlet weak var registerFinishLbl: UILabel!
    @IBOutlet weak var basliqLbl: UILabel!
    @IBOutlet weak var modelInfLbl: UILabel!
    
    
    var iconClick1 = false
    var iconClick2 = false
    var markalar = [Car]()
    var modeller = [Car]()
    var tipler = [Type]()
    
    var selectedMarkaRow = 0
    var selectedModelRow = 0
    var selectedTypeRow = 0
    
    var selectedImage1 = UIImage()
    var selectedImage2 = UIImage()
    var selectedImage3 = UIImage()
    
    var errorMessages = [String]()
    var selectedLanguage: String?
    
   // var selectedMarka = 0
    
    
    
    @IBOutlet weak var numbersTableHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLanguage = UserDefaults.standard.string(forKey: "Lang")
        basliqLbl.text = "register".addLocalizableString(str: selectedLanguage!)
        nameSurnameLbl.text = "name_surname".addLocalizableString(str: selectedLanguage!)
        driverInfoLbl.text = "driver_info".addLocalizableString(str: selectedLanguage!)
        foreginPassportLbl.text = "driver_foreign_passport".addLocalizableString(str: selectedLanguage!)
        browse1Btn.setTitle("browse".addLocalizableString(str: selectedLanguage!), for: .normal)
        registerPassportLbl.text = "register_certificate".addLocalizableString(str: selectedLanguage!)
         browse2Btn.setTitle("browse".addLocalizableString(str: selectedLanguage!), for: .normal)
         browse3Btn.setTitle("browse".addLocalizableString(str: selectedLanguage!), for: .normal)
        semiRegisterPassportLbl.text = "semi_trailer_register_certificate".addLocalizableString(str: selectedLanguage!)
        workExperienceLbl.text = "work_experience".addLocalizableString(str: selectedLanguage!)
        userNameLbl.text = "username_login".addLocalizableString(str: selectedLanguage!)
        passwordLbl.text = "password".addLocalizableString(str: selectedLanguage!)
        repeatPasswordLbl.text = "password_repeat".addLocalizableString(str: selectedLanguage!)
        carInfoLbl.text = "car_info".addLocalizableString(str: selectedLanguage!)
        brendLbl.text = "brend".addLocalizableString(str: selectedLanguage!)
        carWeightLbl.text = "capacity_kg".addLocalizableString(str: selectedLanguage!)
        modelInfLbl.text = "model".addLocalizableString(str: selectedLanguage!)
        semiCarInfoLbl.text = "semi_trailer_info".addLocalizableString(str: selectedLanguage!)
        semiCarVolumeLbl.text = "capacity_m3".addLocalizableString(str: selectedLanguage!)
        semiCarWeightLbl.text = "capacity_kg".addLocalizableString(str: selectedLanguage!)
        semiCarTypeLbl.text = "type_of_transport".addLocalizableString(str: selectedLanguage!)
        registerFinishLbl.text = "register_finish".addLocalizableString(str: selectedLanguage!)
        phoneNumberLbl.text = "contact_number".addLocalizableString(str: selectedLanguage!)
        
        addConnectionView()
        getCars()
        //connView.isHidden = true
        getCarTypes()
        
        operatorPickerView.delegate = self
        operatorPickerView.dataSource = self
        markaPickerView.delegate = self
        markaPickerView.dataSource = self
        modelPickerView.delegate = self
        modelPickerView.dataSource = self
        tipPickerView.delegate = self
        tipPickerView.dataSource = self
    
        image1Controller.delegate = self
        image1Controller.sourceType = UIImagePickerController.SourceType.photoLibrary
        image1Controller.allowsEditing  = false
        
        image2Controller.delegate = self
        image2Controller.sourceType = UIImagePickerController.SourceType.photoLibrary
        image2Controller.allowsEditing  = false
        
        image3Controller.delegate = self
        image3Controller.sourceType = UIImagePickerController.SourceType.photoLibrary
        image3Controller.allowsEditing  = false
        
        scrollView.delegate = self
        
        let imageBtns = [image01Btn, image02Btn, image03Btn]
        let browseBtns = [browse1Btn, browse2Btn, browse3Btn]
        
        for i in 0..<3 {
            imageBtns[i]?.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
            imageBtns[i]?.layer.borderWidth = 1
            imageBtns[i]?.layer.cornerRadius = 10
        }
        
        for i in 0..<3 {
           browseBtns[i]?.layer.cornerRadius = 10
        }
        
        
        let markaGesture = UITapGestureRecognizer(target: self, action: #selector(markaTapped))
        markaGesture.cancelsTouchesInView = false
        markaSelectView.isUserInteractionEnabled = true
        markaSelectView.addGestureRecognizer(markaGesture)
        markaTextField.inputView = markaPickerView
        
        let modelGesture = UITapGestureRecognizer(target: self, action: #selector(modelTapped))
        modelGesture.cancelsTouchesInView = false
        modelSelectView.isUserInteractionEnabled = true
        modelSelectView.addGestureRecognizer(modelGesture)
        modelTextField.inputView = modelPickerView
        
        let tipGesture = UITapGestureRecognizer(target: self, action: #selector(tipTapped))
        tipGesture.cancelsTouchesInView = false
        tipSelectView.isUserInteractionEnabled = true
        tipSelectView.addGestureRecognizer(tipGesture)
        tipTextField.inputView = tipPickerView
        
        let registerGesture = UITapGestureRecognizer(target: self, action: #selector(registerTapped))
        registerGesture.cancelsTouchesInView = false
        bottomView.addGestureRecognizer(registerGesture)
        bottomView.isUserInteractionEnabled = true
        
        
        modelTextField.delegate = self
        markaTextField.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bottomView.roundCorners(corners: [.topRight], cornerRadius: 90.0)
        })
        
        checkMaxLength(textField: stajTextField, maxLength: 2)

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func registerTapped(){
        self.view.endEditing(true)
        registerUser()
     //  performSegue(withIdentifier: "segueToSuccess", sender: self)
    }
    
    @objc func markaTapped(){
        markaTextField.becomeFirstResponder()
    }
    
    @objc func modelTapped(){
        modelTextField.becomeFirstResponder()
    }
    
    @objc func tipTapped(){
        tipTextField.becomeFirstResponder()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    @IBAction func backClciked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func browse1Clicked(_ sender: Any) {
    
        self.present(image1Controller, animated: true, completion: nil)
        
    }
    
    @IBAction func browse2Clicked(_ sender: Any) {
         self.present(image2Controller, animated: true, completion: nil)
    }
    
    @IBAction func browse3Clicked(_ sender: Any) {
         self.present(image3Controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil{
            
            if(picker == image1Controller){
                image01Btn.isHidden = false
                selectedImage1 = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                browseLeftConst1.constant = 140
            }
            else if(picker == image2Controller){
                image02Btn.isHidden = false
                selectedImage2 = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                browseLeftConst2.constant = 140
            }
            else{
                image03Btn.isHidden = false
                selectedImage3 = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                browseLeftConst3.constant = 140
            }
        
            
            
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
        
     //   print(rowCount)
        
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
        cell.textField.text = numbers[indexPath.row]
        
      //  cell.numberSelectBtn.tag = indexPath.row
     //   cell.numberSelectBtn.addTarget(self, action: #selector(numberSelectClciked), for: .touchUpInside)
        
        //cell.pickerTextField.tag = indexPath.row
       // pickerTextFileds.append(cell.pickerTextField)
      ///  cell.pickerTextField.inputView = operatorPickerView
        
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
        numbersTableHeight.constant = CGFloat((numbers.count) * 50)
        numbersTable.reloadData()
 
    }
    
//    @objc func numberSelectClciked(sender:UIButton){
//
//        clickedOperatorIndex = sender.tag
//
//        if(sender.tag == rowCount - 1 && rowCount != 1 && rowCount != pickerTextFileds.count)  // Bilinmeyen sebebden plus buttonuna basdiqdan sonra axirinci setrin pickerTextFiledi arraye 2 defe elave olunur. Bu halda elave edilmis 2 eded textFieldden yalniz ikincisi istifade olunur. Birincisini istifade etdikde islemir.
//        {
//             pickerTextFileds[rowCount].becomeFirstResponder() // arrayin axirinci textfieldi (Elave edilmis 2 eyni textFiledden ikincisi) istifade edilir
//        }
//        else{
//            pickerTextFileds[sender.tag].becomeFirstResponder()
//        }
//
//    }
    
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
           // modelLbl.text = "----"
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
            modelSelectView.isUserInteractionEnabled = false
            getModels(carId: markalar[row].id!)
            markaLbl.text = markalar[row].title
            selectedMarkaRow = row
        }
        if(pickerView == modelPickerView){
            modelLbl.text = modeller[row].title
            selectedModelRow = row
        }
        if(pickerView == tipPickerView){
            tipLbl.text = tipler[row].name
            selectedTypeRow = row
        }
        
       
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//         numbers[textField.tag] = textField.text!
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         markaSelectView.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
         modelSelectView.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
         tipSelectView.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
         stajSelectView.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
   
    }
    
    func addConnectionView(){
        if let connectionView = Bundle.main.loadNibNamed("CheckConnectionView", owner: self, options: nil)?.first as? CheckConnectionView {
            connectionView.frame = CGRect(x: 0, y: 2.7/10 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 2.7/10 * UIScreen.main.bounds.height)
            self.view.addSubview(connectionView);
            connectionView.buttonView.clipsToBounds = true
            
            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.checkIndicator
            
            connectionView.tryButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        }
    }
    
    @objc func tryAgain(){
        getCars()
        getCarTypes()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 0
        //let cells = self.numbersTable.visibleCells as! Array<AddNumberCell>
       
        if(textField == nameTextField || textField == passwordTextField || textField == repeatPasswordTextField){
            maxLength = 30
        }
        else if(textField == stajTextField){
            maxLength = 2
        }
        else if(textField == userNameTextField){
            maxLength = 20
        }
       else  if(textField == carWeightTextField || textField == halfCarVolumeTextField || textField == halfCarWeightTextField)
        {
            maxLength = 6
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
    
    
    func getCars(){
        markalar = []
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        let carUrl = "http://carryup.az/api/v1/car/list"
        guard let url = URL(string: carUrl) else {return}
        
        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in

          
            
            if(error == nil){
                 guard let data = data else {return}
                do{
                   let jsonData = try JSONDecoder().decode(CarData.self, from: data)
                    DispatchQueue.main.async {
                        self.getModels(carId: jsonData.data[0].id!)
                    }

                    for i in 0..<jsonData.data.count{
                        self.markalar.append(jsonData.data[i])
                    }

                }

                catch _{
                    print("JsonError")
                }

                DispatchQueue.main.async {
                    self.connView.isHidden = true
                    self.markaPickerView.reloadAllComponents()
                    self.markaLbl.text  = self.markalar[0].title
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

    func getModels(carId: Int){
        modeller = []
        selectedModelRow = 0
        let carUrl = "http://carryup.az/api/v1/car/" + "\(carId)" + "/model/list"
        guard let url = URL(string: carUrl) else {return}

        URLSession.shared.dataTask(with: url){(data, response, error) in

            

            if(error == nil){
                 guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(CarData.self, from: data)
                    for i in 0..<jsonData.data.count{
                        self.modeller.append(jsonData.data[i])
                    }
                }

                catch _{
                   self.view.makeToast("Model Json Error")
                }

                DispatchQueue.main.async {
                    self.modelPickerView.reloadAllComponents()
                    self.modelPickerView.selectRow(0, inComponent: 0, animated: true)
                    self.modelLbl.text  = self.modeller[0].title
                    self.modelSelectView.isUserInteractionEnabled = true
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
    
    func getCarTypes(){
        tipler = []
        let carUrl = "http://carryup.az/api/v1/car/types"
        guard let url = URL(string: carUrl) else {return}
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            
            if(error == nil){
                 guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(CarTypeData.self, from: data)
                    print(jsonData)
                    for i in 0..<jsonData.data.count{
                        self.tipler.append(jsonData.data[i])
                    }
                }
                    
                catch _{
                    print("JsonError")
                }
                
                DispatchQueue.main.async {
                    self.tipPickerView.reloadAllComponents()
                    self.tipLbl.text  = self.tipler[0].name
                }
            }
            else
            {
                

                if let error = error as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        print("Internet Xetasi")
                    }
                }
            }
            
            
            }.resume()
        
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
            "role_id":"3",
            "name":"\(nameTextField.text ?? "")",
            "username":"\(userNameTextField.text ?? "")",
            "password":"\(passwordTextField.text ?? "")",
            "phone":filteredNumbers.joined(separator: ","),
            "password_confirmation":"\(repeatPasswordTextField.text ?? "")",
            "work_practice":"\(stajTextField.text ?? "")",
            "car_model":"\(modeller[selectedModelRow].id ?? 0)",
            "car_brand":"\(markalar[selectedMarkaRow].id ?? 0)",
            "car_weight":"\(carWeightTextField.text ?? "")",
            "car_tonnage_kq": "\(halfCarWeightTextField.text ?? "")",
            "car_tonnage_m3": "\(halfCarVolumeTextField.text ?? "")",
            "car_type": "\(tipler[selectedTypeRow].id ?? 0)"
            
        ]
        
        let headers = [
            "Content-type":"multipart/form-data",
            "Content-Disposition":"form-data"
        ]
        
        let imgData1 = selectedImage1.jpegData(compressionQuality: 0.2)
        let imgData2 = selectedImage2.jpegData(compressionQuality: 0.2)
        let imgData3 = selectedImage3.jpegData(compressionQuality: 0.2)
        

        
        Alamofire.upload(multipartFormData: { multipartFormData in


            if let imgData1 = imgData1{
                multipartFormData.append(imgData1, withName: "foreign_passport",fileName: "foreign_passport", mimeType: "image/png")
            }
            if let imgData2 = imgData2{
                multipartFormData.append(imgData2, withName: "car_register_doc",fileName: "car_register_doc", mimeType: "image/png")
            }
            if let imgData3 = imgData3{
               multipartFormData.append(imgData3, withName: "half_car_register_doc",fileName: "half_car_register_doc", mimeType: "image/png")
            }

            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }

        }, usingThreshold:UInt64.init(),
           to: "http://carryup.az/api/v1/user/register", //URL Here
            method: .post,
            headers: headers, //pass header dictionary here
            encodingCompletion: { (result) in

                switch result {
                case .success(let upload, _, _):

                    upload.responseString { response in
                        
                          print(response.description)
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
                                        self.performSegue(withIdentifier: "segueToSuccess", sender: self)
                                        
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
                    self.connView.isHidden = true
                    print(error)
                    self.view.makeToast("Bilinməyən xəta")
                    break
                }
        })
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToErrorController"){
           let VC = segue.destination as! ErrorMessageController
            VC.errorMessages = self.errorMessages
        }
        if(segue.identifier == "segueToSuccess"){
            let VC = segue.destination as! SuccessRegisterController
            VC.userName = self.userNameTextField.text!
            VC.password = self.passwordTextField.text!
        }
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if ((textField.text!).count > maxLength) {
            textField.deleteBackward()
        }
    }
    
   
    @IBAction func showPassPressed(_ sender: Any) {
        if(iconClick1 == false){
            passwordTextField.isSecureTextEntry = false
        }
        else{
            passwordTextField.isSecureTextEntry = true
        }
        iconClick1 = !iconClick1
    }
    
    
    @IBAction func showRepeatedPassPressed(_ sender: Any) {
        if(iconClick2 == false){
                repeatPasswordTextField.isSecureTextEntry = false
            }
            else{
                repeatPasswordTextField.isSecureTextEntry = true
            }
            iconClick2 = !iconClick2
    }
    
}
