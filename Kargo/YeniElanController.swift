//
//  YeniElanController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 9/16/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit


struct ValyutaListData:Decodable {
    let data: [TimeLineItemValyuta]?
}

class YeniElanController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UITextFieldDelegate {

    

    @IBOutlet weak var ovalView: UIView!
    @IBOutlet weak var imtinaBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var haradanCountryLbl: UILabel!
    @IBOutlet weak var haradanCountryView: CustomSelectButton!
    @IBOutlet weak var haradanTextField: UITextField!
    @IBOutlet weak var haradanCityHeight: NSLayoutConstraint!
    @IBOutlet weak var haradanCityLbl: UILabel!
    @IBOutlet weak var haradanCityView: CustomSelectButton!
    @IBOutlet weak var haradanCityTextField: UITextField!
    @IBOutlet weak var haradanRegionHeight: NSLayoutConstraint!
    @IBOutlet weak var haradanRegionTextField: UITextField!
    @IBOutlet weak var harayaCountryLbl: UILabel!
    @IBOutlet weak var harayaCountryView: CustomSelectButton!
    @IBOutlet weak var harayaCountryTextField: UITextField!
    @IBOutlet weak var harayaCityViewHeight: NSLayoutConstraint!
    @IBOutlet weak var harayaCityLbl: UILabel!
    @IBOutlet weak var harayaCityTextField: UITextField!
    @IBOutlet weak var harayaCityView: CustomSelectButton!
    @IBOutlet weak var harayaRegionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var harayaRegionTextField: UITextField!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var typeView: CustomSelectButton!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var volumeTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var enTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dateView: CustomSelectButton!
    @IBOutlet weak var firstDateTextField: UITextField!
    @IBOutlet weak var secondDateTextField: UITextField!
    
    @IBOutlet weak var valyutaLbl: UILabel!
    @IBOutlet weak var valyutaView: CustomSelectButton!
    @IBOutlet weak var valyutaTextField: NSLayoutConstraint!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var mapTextField: UITextField!
    @IBOutlet weak var volumeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var valTextField: UITextField!
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var mapView: CustomSelectButton!
    
    
    @IBOutlet weak var weightViewHeight: NSLayoutConstraint!
    @IBOutlet weak var volViewHeight: NSLayoutConstraint!
    @IBOutlet weak var enViewHeight: NSLayoutConstraint!
    @IBOutlet weak var heightViewHeight: NSLayoutConstraint!
    @IBOutlet weak var typeViewHeight: NSLayoutConstraint!
    
    
    var fromCountryPicker = UIPickerView()
    var fromCityPicker = UIPickerView()
    var toCountryPicker = UIPickerView()
    var toCityPicker = UIPickerView()
    var typePicker = UIPickerView()
    var valyutaPicker = UIPickerView()
    var firstDatePicker = UIDatePicker()
    var secondDatePicker = UIDatePicker()
    var pickerViews = [UIPickerView]()
    var hiddenTextFields = [UITextField]()
    var customBtnArray = [CustomSelectButton]()
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    
    var tipler = [Type]()
    var countryList = [CountryDataModel]()
    var fromRegionList = [CountryDataModel]()
    var toRegionList = [CountryDataModel]()
    var valyutas = [TimeLineItemValyuta]()
    
    var selectedFromCountry = ""
    var selectedFromCity  =   ""
    var selectedToCountry = ""
    var selectedToCity = ""
    var selectedType = ""
    var selectedValyuta = ""
    
    var coord_x = ""
    var coord_y = ""
    var elanType = ""
    
    var requiredList = [String]()
    
    var errorMessages = [String]()
    
    var showMessage: (()->())?
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBtnArray = [haradanCountryView, haradanCityView, harayaCountryView, harayaCityView, typeView, dateView, valyutaView, mapView]
        setUpDesign()
        addConnectionView()
        pickerViewSettings()
        
        getCountries()
    }
    
    func createShadow2(view: UIView){
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 30.0
        
        
    }

    func setUpDesign(){
        setUpBackButton()
        createShadow2(view: ovalView)
        
        createBtn.layer.cornerRadius = 12
        imtinaBtn.layer.cornerRadius = 12
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
        })
        
        if(vars.user?.user?.role_id == 3){
            weightViewHeight.constant = 0
            volViewHeight.constant = 0
            enViewHeight.constant = 0
            heightViewHeight.constant = 0
            volumeViewHeight.constant = 0
            typeViewHeight.constant = 0
        }
        
        
    }
    
    func pickerViewSettings(){
        pickerViews = [fromCountryPicker, fromCityPicker, toCountryPicker, toCityPicker, typePicker, valyutaPicker]
        
        for i in 0..<pickerViews.count{
            pickerViews[i].delegate = self
            pickerViews[i].dataSource = self
        }
        
        let fromCountryTapGesture = UITapGestureRecognizer(target: self, action: #selector(fromCountryTapped))
        haradanCountryView.isUserInteractionEnabled = true
        fromCountryTapGesture.cancelsTouchesInView = false
        haradanCountryView.addGestureRecognizer(fromCountryTapGesture)
        
        let fromCityTapGesture = UITapGestureRecognizer(target: self, action: #selector(fromCityTapped))
        haradanCityView.isUserInteractionEnabled = true
        fromCityTapGesture.cancelsTouchesInView = false
        haradanCityView.addGestureRecognizer(fromCityTapGesture)
        
        let toCountryTapGesture = UITapGestureRecognizer(target: self, action: #selector(toCountryTapped))
        harayaCountryView.isUserInteractionEnabled = true
        toCountryTapGesture.cancelsTouchesInView = false
        harayaCountryView.addGestureRecognizer(toCountryTapGesture)
        
        let toCityTapGesture = UITapGestureRecognizer(target: self, action: #selector(toCityTapped))
        harayaCityView.isUserInteractionEnabled = true
        toCityTapGesture.cancelsTouchesInView = false
        harayaCityView.addGestureRecognizer(toCityTapGesture)
        
        let typeTapGesture = UITapGestureRecognizer(target: self, action: #selector(typeTapped))
        typeView.isUserInteractionEnabled = true
        typeTapGesture.cancelsTouchesInView = false
        typeView.addGestureRecognizer(typeTapGesture)
        
        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTapped))
        dateView.isUserInteractionEnabled = true
        dateTapGesture.cancelsTouchesInView = false
        dateView.addGestureRecognizer(dateTapGesture)
        
        let valyutaTapGesture = UITapGestureRecognizer(target: self, action: #selector(valyutaTapped))
        valyutaView.isUserInteractionEnabled = true
        valyutaTapGesture.cancelsTouchesInView = false
        valyutaView.addGestureRecognizer(valyutaTapGesture)
        
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        mapView.isUserInteractionEnabled = true
        mapTapGesture.cancelsTouchesInView = false
        mapView.addGestureRecognizer(mapTapGesture)
        
        mapTextField.isEnabled = false
        
      
        hiddenTextFields = [haradanTextField, haradanCityTextField, harayaCountryTextField, harayaCityTextField, typeTextField, valTextField] as! [UITextField]
        
        for i in 0..<hiddenTextFields.count{
            hiddenTextFields[i].inputView = pickerViews[i]
        }
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        firstDatePicker.datePickerMode = .date
        firstDateTextField.inputView = firstDatePicker
        
        
        secondDatePicker.datePickerMode = .date
        secondDateTextField.inputView = secondDatePicker
        
        let loc = Locale(identifier: "az")
        firstDatePicker.locale = loc
        secondDatePicker.locale = loc
        
        haradanCityHeight.constant = 0
        haradanRegionHeight.constant = 0
        harayaCityViewHeight.constant = 0
        harayaRegionViewHeight.constant = 0
        
        haradanCityTextField.delegate = self
        haradanTextField.delegate = self
        harayaCityTextField.delegate = self
        harayaCountryTextField.delegate = self
        typeTextField.delegate = self
        firstDateTextField.delegate = self
        secondDateTextField.delegate = self
        valTextField.delegate = self
        mapTextField.delegate = self
        
//        mapTextField.isEnabled = false
//        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
//        mapTextField.isUserInteractionEnabled = true
//        mapTextField.addGestureRecognizer(mapTapGesture)
    }
    
    @objc func mapTapped(){
         self.view.endEditing(true)
         self.performSegue(withIdentifier: "segueToMapController", sender: self)
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
    
    func addConnectionView(){
        if let connectionView = Bundle.main.loadNibNamed("CheckConnectionView", owner: self, options: nil)?.first as? CheckConnectionView {
            connectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            self.view.addSubview(connectionView);
            connectionView.buttonView.clipsToBounds = true
            
            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.checkIndicator
            
            
            
            connectionView.tryButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        }
    }
    
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tryAgain(){
        valyutas = []
        tipler = []
        countryList = []
        getCountries()
    }
    
    @objc func fromCountryTapped(){
       print("Basildiu")
       haradanTextField.becomeFirstResponder()
    }
    
    @objc func fromCityTapped(){
        haradanCityTextField.becomeFirstResponder()
    }
    
    @objc func toCountryTapped(){
        harayaCountryTextField.becomeFirstResponder()
    }
    
    @objc func toCityTapped(){
        harayaCityTextField.becomeFirstResponder()
    }
    
    @objc func typeTapped(){
        typeTextField.becomeFirstResponder()
    }
    
    @objc func dateTapped(){
        firstDateTextField.becomeFirstResponder()
    }
    
    @objc func valyutaTapped(){
        valTextField.becomeFirstResponder()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == fromCountryPicker || pickerView == toCountryPicker){
            return countryList.count + 1
        }
    
        else if(pickerView == typePicker){
            return tipler.count + 1
        }
        
        else if(pickerView == valyutaPicker){
            return valyutas.count + 1
        }
        else if(pickerView == fromCityPicker){
            return fromRegionList.count + 1
        }
        else if(pickerView == toCityPicker){
            return toRegionList.count + 1
        }
        else{
            return 5
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if(pickerView == fromCountryPicker || pickerView == toCountryPicker){
            if(row != 0){
                return countryList[row - 1].name
            }
            else{
                 return "Seçilməyib"
            }
        }
            
       else if(pickerView == typePicker){
            if(row != 0){
                return tipler[row - 1].name
            }
            else{
                return "Seçilməyib"
            }
        }
        else if(pickerView == valyutaPicker){
            if(row != 0){
                return valyutas[row - 1].code
            }
            else{
                return "Seçilməyib"
            }
        }
        else if(pickerView == fromCityPicker ){
            if(row != 0){
                return fromRegionList[row - 1].name
            }
            else{
                return "Seçilməyib"
            }
        }
        else if(pickerView == toCityPicker ){
            if(row != 0){
                return toRegionList[row - 1].name
            }
            else{
                return "Seçilməyib"
            }
        }
    
        else {
            return "Test"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == fromCountryPicker){
            if(row != 0){
              haradanCountryLbl.text = countryList[row-1].name
              selectedFromCountry = "\(countryList[row-1].id!)"
              getRegions(countryId: countryList[row-1].id!, type: 1)
                UIView.animate(withDuration: 0.2, animations: {
                    self.haradanRegionHeight.constant = 91
                    self.view.layoutIfNeeded()
                })
                
            }
            else{
                haradanCountryLbl.text = "Seçilməyib"
                selectedFromCountry = ""
                haradanRegionTextField.text = ""
                UIView.animate(withDuration: 0.2, animations: {
                    self.haradanRegionHeight.constant = 0
                    self.haradanCityHeight.constant = 0
                    self.view.layoutIfNeeded()
                })
                
            }
             haradanCityLbl.text = "Seçilməyib"
        }
        if(pickerView == toCountryPicker){
            if(row != 0){
                harayaCountryLbl.text = countryList[row-1].name
                selectedToCountry = "\(countryList[row-1].id!)"
                getRegions(countryId: countryList[row-1].id!, type: 2)
                UIView.animate(withDuration: 0.2, animations: {
                    self.harayaRegionViewHeight.constant = 91
                    self.view.layoutIfNeeded()
                })
            }
            else{
                harayaCountryLbl.text = "Seçilməyib"
                selectedToCountry = ""
                harayaRegionTextField.text = ""
                UIView.animate(withDuration: 0.2, animations: {
                    self.harayaRegionViewHeight.constant = 0
                    self.harayaCityViewHeight.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
            harayaCityLbl.text = "Seçilməyib"
        }
        if(pickerView == typePicker){
            if(row != 0){
                typeLbl.text = tipler[row-1].name
                selectedType = "\(tipler[row-1].id!)"
            }
            
            else{
                typeLbl.text = "Seçilməyib"
                selectedType = ""
            }
        }
        if(pickerView == valyutaPicker){
            if(row != 0){
                 valyutaLbl.text = valyutas[row-1].code
                 selectedValyuta = "\(valyutas[row-1].id!)"
            }
            else{
                valyutaLbl.text = "Seçilməyib"
                selectedValyuta = ""
            }
        }
        
        if(pickerView == fromCityPicker){
            if(row != 0){
                haradanCityLbl.text = fromRegionList[row-1].name
                selectedFromCity = "\(fromRegionList[row-1].id!)"
            }
            else{
                haradanCityLbl.text = "Seçilməyib"
                selectedFromCity = ""
            }
        }
        if(pickerView == toCityPicker){
            if(row != 0){
                harayaCityLbl.text = toRegionList[row-1].name
                selectedToCity = "\(toRegionList[row-1].id!)"
            }
            else{
                harayaCityLbl.text = "Seçilməyib"
            }
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        for i in 0..<customBtnArray.count{
            customBtnArray[i].backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 0..<customBtnArray.count{
            customBtnArray[i].backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
        }
        
    }
    
    @IBAction func createBtnClicked(_ sender: Any) {
        if(vars.user?.user?.role_id == 4){
            createUserAdv()
        }
        else
        {
            createDriverAdv()
        }
        
        
    }
    
    func createUserAdv(){
        
        errorMessages = []
        let dateForm = DateFormatter()
        dateForm.dateFormat = "dd-MM-yyyy"
        
        self.view.endEditing(true)
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        let loginUrl = "http://209.97.140.82/api/v1/order/create"
        
        guard let url = URL(string: loginUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("Bearer " + (vars.user?.data?.token)!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
       
        let parameters: [String: Any] = [
            "from_country_id": selectedFromCountry,
            "from_region_id": selectedFromCity,
            "from_city": haradanRegionTextField.text!,
            "to_country_id": selectedToCountry,
            "to_region_id": selectedToCity,
            "to_city": harayaRegionTextField.text!,
            "start_date": dateForm.string(from: firstDatePicker.date),
            "end_date": dateForm.string(from: secondDatePicker.date),
            "cargo_tonnage_m3": volumeTextField.text!,
            "cargo_tonnage_kq": weightTextField.text!,
            "size_x": lengthTextField.text!,
            "size_y": enTextField.text!,
            "size_z": heightTextField.text!,
            "price": priceTextField.text!,
            "price_valyuta": selectedValyuta,
            "coordinates_x": coord_x,
            "coordinates_y": coord_y,
            "order_category_id": selectedType
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
                
               // let outputStr  = String(data: data, encoding: String.Encoding.utf8)
               // print(outputStr)
                do{
     
                            let addOrderResponse = try JSONDecoder().decode(AddOrderSuccessModel.self, from: data)
                            DispatchQueue.main.async {

                                if(addOrderResponse.status == "success"){
                                    self.showMessage!()
                                    self.navigationController?.popViewController(animated: true)
                                }
                                else
                                {
                                    let requiredList = addOrderResponse.error!
                                for i  in 0..<requiredList.count{
                                        self.errorMessages.append(requiredList[i])
                                    }
                                    self.performSegue(withIdentifier: "segueToRequiredList", sender: self)
                                    
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
    
    
    func createDriverAdv(){
        
        errorMessages = []
        let dateForm = DateFormatter()
        dateForm.dateFormat = "dd-MM-yyyy"
        
        var startDate = ""
        var endDate = ""
        
        if(dateLbl.text != "Seçilməyib"){
            startDate = dateForm.string(from: firstDatePicker.date)
            endDate = dateForm.string(from: secondDatePicker.date)
        }
        
        self.view.endEditing(true)
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        let loginUrl = "http://209.97.140.82/api/v1/driver/create"
        
        guard let url = URL(string: loginUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("Bearer " + (vars.user?.data?.token)!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters: [String: Any] = [
            "from_country_id": selectedFromCountry,
            "from_region_id": selectedFromCity,
            "from_city": haradanRegionTextField.text!,
            "to_country_id": selectedToCountry,
            "to_region_id": selectedToCity,
            "to_city": harayaRegionTextField.text!,
            "start_date": startDate,
            "end_date": endDate,
            "price": priceTextField.text!,
            "price_valyuta": selectedValyuta,
            "coordinates_x": coord_x,
            "coordinates_y": coord_y,
            "car_type": "1"
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
                
                // let outputStr  = String(data: data, encoding: String.Encoding.utf8)
                // print(outputStr)
                do{
                    
                    let addOrderResponse = try JSONDecoder().decode(AddOrderSuccessModel.self, from: data)
                    DispatchQueue.main.async {
                        
                        if(addOrderResponse.status == "success"){
                            self.showMessage!()
                            self.navigationController?.popViewController(animated: true)
                        }
                        else
                        {
                            let requiredList = addOrderResponse.error!
                        for i in 0..<requiredList.count{
                                self.errorMessages.append(requiredList[i])
                            }
                            self.performSegue(withIdentifier: "segueToRequiredList", sender: self)
                            
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

    
    
    func getCountries(){
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        let countryUrl = "http://209.97.140.82/api/v1/country/list"
        guard let url = URL(string: countryUrl) else {return}
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 6.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: url){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(CountryData.self, from: data)
                    let countryArray = jsonData.data
                    
                    if let countryArray = countryArray {
                        for i in 0..<countryArray.count {
                         self.countryList.append(countryArray[i])
                        }
                    }
                    DispatchQueue.main.async {
                        self.getCargoTypes()
                    }
                }
                    
                catch _{
                    DispatchQueue.main.async {
                        self.view.endEditing(true)
                        self.connView.isHidden = true
                        self.view.makeToast("Xəta baş verdi")
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
    
    
    func getCargoTypes(){
        tipler = []
        let carUrl = "http://209.97.140.82/api/v1/order/categories"
        guard let url = URL(string: carUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("Bearer " + (vars.user?.data?.token)!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(CarTypeData.self, from: data)
                    for i in 0..<jsonData.data.count{
                        self.tipler.append(jsonData.data[i])
                    }
                    
                    DispatchQueue.main.async {
                        self.getValyutas()
                    }

                }
                    
                catch let jsonError{
                    DispatchQueue.main.async {
                        print(jsonError)
                        self.view.endEditing(true)
                        self.connView.isHidden = true
                        self.view.makeToast("Xəta baş verdi")
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
                            self.checkConnButtonView.isHidden = false
                            self.checkConnIndicator.isHidden = true
                        }
                    }
                }
            }
            
            
            }.resume()
        
    }
    
    func getValyutas(){
      //  tipler = []
        let carUrl = "http://209.97.140.82/api/v1/valyuta/list"
        guard let url = URL(string: carUrl) else {return}
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(ValyutaListData.self, from: data)
                    for i in 0..<jsonData.data!.count{
                        self.valyutas.append(jsonData.data![i])
                    }
                }
                    
                catch let jsonError{
                    print(jsonError)
                    DispatchQueue.main.async {
                        self.view.makeToast("Xəta baş verdi")
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
                            self.connView.isHidden = false
                            self.checkConnButtonView.isHidden = false
                            self.checkConnIndicator.isHidden = true
                        }
                    }
                }
            }
            
            
            }.resume()
        
    }
    
    func getRegions(countryId: Int, type: Int){
        if(type == 1){
            fromRegionList = []
           // fromRegionPicker.reloadAllComponents()
          //  fromRegionPicker.selectRow(0, inComponent: 0, animated: true)
          //  tecrubeLbl.text = "Seçilməyib"
        }
        if(type == 2){
            toRegionList = []
        //    toRegionPicker.reloadAllComponents()
         //   volumeLbl.text = "Seçilməyib"
        }
        let regionUrl = "http://209.97.140.82/api/v1/country/\(countryId)/region/list"
        guard let url = URL(string: regionUrl) else {return}
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: url){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(CountryData.self, from: data)
                    let regionArray = jsonData.data
                    
                    if let regionArray = regionArray {
                        
                        if(regionArray.count > 0){
                            print(regionArray)
                            for i in 0..<regionArray.count {
                                if(type == 1)
                                {
                                    self.fromRegionList.append(regionArray[i])
                                    DispatchQueue.main.async {
                                        self.fromCityPicker.reloadAllComponents()
                                        UIView.animate(withDuration: 0.2, animations: {
                                              self.haradanCityHeight.constant = 91
                                              self.view.layoutIfNeeded()
                                        })
                                        
                                    }
                                }
                                if(type == 2){
                                    self.toRegionList.append(regionArray[i])
                                    DispatchQueue.main.async {
                                        self.toCityPicker.reloadAllComponents()
                                        UIView.animate(withDuration: 0.2, animations: {
                                             self.harayaCityViewHeight.constant = 91
                                            self.view.layoutIfNeeded()
                                        })
                                        
                                    }
                                }
                                
                            }
                        }
                        else{
                            if(type == 1)
                            {
                                DispatchQueue.main.async {
                                    UIView.animate(withDuration: 0.2, animations: {
                                        self.haradanCityHeight.constant = 0

                                        self.view.layoutIfNeeded()
                                    })
                                    
                                }
                            }
                            if(type == 2){
                                DispatchQueue.main.async {
                                    UIView.animate(withDuration: 0.2, animations: {
                                        self.harayaCityViewHeight.constant = 0
                                        self.view.layoutIfNeeded()
                                    })
                                }
                                
                            }
                        }
                        
                    }
                    
                }
                    
                catch let jsonError{
                    print("JsonError: \(jsonError)")
                    DispatchQueue.main.async {
                        self.view.endEditing(true)
                        self.view.makeToast("Json Error")
                    }
                }
            }
            else
            {
                
                
                if let error = error as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        DispatchQueue.main.async {
                            self.view.endEditing(true)
                            self.view.makeToast("Internet baglantisini yoxlayin")
                        }
                    }
                }
            }
            
            
            }.resume()
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == firstDateTextField){
          dateLbl.text = dateFormatter.string(from: firstDatePicker.date) + " - "
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                self.secondDateTextField.becomeFirstResponder()
            })
         
        }
        if(textField == secondDateTextField){
            dateLbl.text = dateFormatter.string(from: firstDatePicker.date) + " - " + dateFormatter.string(from: secondDatePicker.date)
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == mapTextField){
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute: {
                 self.mapTextField.resignFirstResponder()
                 self.performSegue(withIdentifier: "segueToMapController", sender: self)
            })
          
            
        }
    }
    
    func setCoord(coord_x: String, coord_y: String) -> () {
       // self.view.endEditing(true)
        self.coord_x = coord_x
        self.coord_y = coord_y
        if(coord_x != "" && coord_y != ""){
             mapTextField.text = coord_x + ", " + coord_y
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToMapController")
        {
            let VC = segue.destination as! MapViewController
            VC.setCoord = self.setCoord
        }
        if(segue.identifier == "segueToRequiredList") {
            let VC = segue.destination as! ErrorMessageController
            VC.errorMessages = self.errorMessages
        }
    }

}
