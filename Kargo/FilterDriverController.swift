//
//  FilterDriverController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/11/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

struct CountryData:Decodable{
    let data: [CountryDataModel]?
}

struct CountryDataModel:Decodable{
    let id: Int?
    let name: String?
    let nicename: String?
    let numcode: Int?
    let phonecode: Int?
}

class FilterDriverController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UITextFieldDelegate {

    
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var parentView: UIView!
    var picker = UIPickerView()
    var fromRegionPicker = UIPickerView()
    var toCountryPicker = UIPickerView()
    var toRegionPicker = UIPickerView()
    var  carTypePicker = UIPickerView()
    var  cargoTypePicker = UIPickerView()
    @IBOutlet weak var testTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationView: CustomSelectButton!
    @IBOutlet weak var tecrubeView: CustomSelectButton!
    @IBOutlet weak var typeView: CustomSelectButton!
    @IBOutlet weak var volumeView: CustomSelectButton!
    @IBOutlet weak var weightView: CustomSelectButton!
    @IBOutlet weak var registerView: CustomSelectButton!
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var tecrubeTextField: UITextField!
    @IBOutlet weak var typeTextFiled: UITextField!
    @IBOutlet weak var volumeTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var registerTextfield: UITextField!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var tecrubeLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var volumeLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var registerLbl: UILabel!
    var tipler = [Type]()
    var countryList = [CountryDataModel]()
    var fromRegionList = [CountryDataModel]()
    var toRegionList = [CountryDataModel]()
    var firstDatePicker = UIDatePicker()
    var secondDatePicker = UIDatePicker()
    
    var textFieldArray = [UITextField]()
    var viewArray = [CustomSelectButton]()
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var secondDateTextField: UITextField!
    @IBOutlet weak var haradanRegHeightConst: NSLayoutConstraint!
    @IBOutlet weak var haradanRegionTopConst: NSLayoutConstraint!
    @IBOutlet weak var haradanRegionLblConst: NSLayoutConstraint!
    @IBOutlet weak var harayaRegionTopConst: NSLayoutConstraint!
    @IBOutlet weak var harayaRegionLblConst: NSLayoutConstraint!
    @IBOutlet weak var harayaRegionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var carTypeLblHeightConst: NSLayoutConstraint!
    @IBOutlet weak var carTypeViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var yukTypeSelectBtn: CustomSelectButton!
    @IBOutlet weak var yukTypeLbl: UILabel!
    @IBOutlet weak var yukTypeTextField: UITextField!    
    @IBOutlet weak var yukTypeHeightConst: NSLayoutConstraint!
    @IBOutlet weak var yukTypeLblHeight: NSLayoutConstraint!
    @IBOutlet weak var cleanBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var basliqLbl: UILabel!
    @IBOutlet weak var fromCountryLbl: UILabel!
    @IBOutlet weak var toCountryLbl: UILabel!
    @IBOutlet weak var dateIntervalLbl: UILabel!
    @IBOutlet weak var carTypeLbl: UILabel!
    @IBOutlet weak var cargoTypeLbl: UILabel!
    @IBOutlet weak var fromCityLbl: UILabel!
    @IBOutlet weak var toCityLbl: UILabel!
    
    var selectedLang: String?
    
    var screenHeight = 0.0
    var filterType = ""
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    
    var selectedFromCountry = ""
    var selectedFromRegion = ""
    var selectedTocountry = ""
    var selectedToRegion = ""
    var selectedCarType = ""
    var selectedCargoType = ""
    var startDate = ""
    var endDate = ""
    
    var findOrderFunction: ((String, String, String, String, String, String, String) -> ())?
    var findDriverFunction: ((String, String, String, String, String, String, String) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLang = UserDefaults.standard.string(forKey: "Lang")
        fromCountryLbl.text = "from_country".addLocalizableString(str: selectedLang!)
        toCountryLbl.text = "to_country".addLocalizableString(str: selectedLang!)
        dateIntervalLbl.text = "date_interval".addLocalizableString(str: selectedLang!)
        carTypeLbl.text = "transportation_type".addLocalizableString(str: selectedLang!)
        cargoTypeLbl.text = "cargo_type".addLocalizableString(str: selectedLang!)
        cleanBtn.setTitle("clear".addLocalizableString(str: selectedLang!), for: .normal)
        searchBtn.setTitle("search".addLocalizableString(str: selectedLang!), for: .normal)
        basliqLbl.text = "search_more".addLocalizableString(str: selectedLang!)
        fromCityLbl.text = "from_city".addLocalizableString(str: selectedLang!)
        toCityLbl.text = "to_city".addLocalizableString(str: selectedLang!)
        
        
        textFieldArray = [locationTextfield, tecrubeTextField, typeTextFiled, volumeTextField, weightTextField, registerTextfield]
        viewArray = [locationView, tecrubeView, typeView, volumeView, weightView, registerView, yukTypeSelectBtn]
        cleanBtn.layer.cornerRadius = 10
        searchBtn.layer.cornerRadius = 10

        setUpBackButton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
         //   self.bottomView.roundCorners(corners: [.topRight], cornerRadius: 90.0)
        })
        
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
   
        firstDatePicker.datePickerMode = .date
        weightTextField.inputView = firstDatePicker
        
        
        secondDatePicker.datePickerMode = .date
        secondDateTextField.inputView = secondDatePicker
        
        //firstDatePicker.date = Calendar.current.date
        
        let loc = Locale(identifier: selectedLang!)
        firstDatePicker.locale = loc
        secondDatePicker.locale = loc
        
        if(filterType == "driver")
        {
            carTypeLblHeightConst.constant = 18
            carTypeViewHeightConst.constant = 45
            yukTypeLblHeight.constant = 0
            yukTypeHeightConst.constant = 0
        }
        else{
            carTypeLblHeightConst.constant = 0
            carTypeViewHeightConst.constant = 0
            yukTypeLblHeight.constant = 18
            yukTypeHeightConst.constant = 45
        }
        
        getCountries()
        addConnectionView()
        
       // let bottomTapGesture = UITapGestureRecognizer(target: self, action: #selector(bottomTapped))
       // bottomView.isUserInteractionEnabled = true
      //  bottomView.addGestureRecognizer(bottomTapGesture)
    }

    
    @objc func bottomTapped(){
//        if(filterType == "order")
//        {
//            findOrderFunction!(selectedFromCountry, selectedFromRegion, selectedTocountry, selectedToRegion, startDate, endDate)
//        }
//        else
//        {
//            findDriverFunction!(selectedFromCountry, selectedFromRegion, selectedTocountry, selectedToRegion, startDate, endDate, selectedCarType)
//        }
//        
//        self.navigationController?.popViewController(animated: true)
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
        picker.delegate = self
        picker.dataSource = self
        
        fromRegionPicker.delegate = self
        fromRegionPicker.dataSource = self
        
        toCountryPicker.delegate = self
        toCountryPicker.dataSource = self
        
        toRegionPicker.delegate = self
        toRegionPicker.dataSource = self
        
        carTypePicker.delegate = self
        carTypePicker.dataSource = self
        
        cargoTypePicker.delegate = self
        cargoTypePicker.dataSource = self

        locationTextfield.inputView = picker
        tecrubeTextField.inputView = fromRegionPicker
        typeTextFiled.inputView = toCountryPicker
        volumeTextField.inputView = toRegionPicker
        registerTextfield.inputView = carTypePicker
        yukTypeTextField.inputView = cargoTypePicker
        
        
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(locationTapped))
        locationView.isUserInteractionEnabled = true
        locationTap.cancelsTouchesInView = false
        locationView.addGestureRecognizer(locationTap)
        
        let tecrubeTap = UITapGestureRecognizer(target: self, action: #selector(tecrubeTapped))
        tecrubeView.isUserInteractionEnabled = true
        tecrubeTap.cancelsTouchesInView = false
        tecrubeView.addGestureRecognizer(tecrubeTap)
        
        let typeTap = UITapGestureRecognizer(target: self, action: #selector(typeTapped))
        typeView.isUserInteractionEnabled = true
        typeTap.cancelsTouchesInView = false
        typeView.addGestureRecognizer(typeTap)
        
        let volumeTap = UITapGestureRecognizer(target: self, action: #selector(volumeTapped))
        volumeView.isUserInteractionEnabled = true
        volumeTap.cancelsTouchesInView = false
        volumeView.addGestureRecognizer(volumeTap)
        
        let weightTap = UITapGestureRecognizer(target: self, action: #selector(weightTapped))
        weightView.isUserInteractionEnabled = true
        weightTap.cancelsTouchesInView = false
        weightView.addGestureRecognizer(weightTap)
        
        let registerTap = UITapGestureRecognizer(target: self, action: #selector(registerTapped))
        registerView.isUserInteractionEnabled = true
        registerTap.cancelsTouchesInView = false
        registerView.addGestureRecognizer(registerTap)
        
        let cargoTap = UITapGestureRecognizer(target: self, action: #selector(cargoTapped))
        yukTypeSelectBtn.isUserInteractionEnabled = true
        cargoTap.cancelsTouchesInView = false
        yukTypeSelectBtn.addGestureRecognizer(cargoTap)
        
        
        
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
    
    @objc func tryAgain(){
        getCountries()
    }
    
    
    @objc func locationTapped()
    {
        locationTextfield.becomeFirstResponder()
    }
    @objc func tecrubeTapped()
    {
        tecrubeTextField.becomeFirstResponder()
    }
    @objc func typeTapped()
    {
         typeTextFiled.becomeFirstResponder()
    }
    @objc func volumeTapped()
    {
         volumeTextField.becomeFirstResponder()
    }
    @objc func weightTapped()
    {
        weightTextField.becomeFirstResponder()
    }
    @objc func registerTapped()
    {
         registerTextfield.becomeFirstResponder()
    }
    
    @objc func cargoTapped()
       {
            yukTypeTextField.becomeFirstResponder()
       }
    
    
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func createShadow2(view: UIView){
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 30.0
        self.scrollView.layer.cornerRadius = 20.0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == picker || pickerView == toCountryPicker){
            return countryList.count + 1
        }
        else if(pickerView == fromRegionPicker){
            return fromRegionList.count + 1
        }
        else if(pickerView == toRegionPicker)
        {
            return toRegionList.count + 1
        }
        else
        {
            return tipler.count + 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == picker || pickerView == toCountryPicker){
            if(row == 0){
                return "Seçilməyib"
            }
            else{
                return countryList[row-1].name
            }
        }
        else if(pickerView == fromRegionPicker)
        {
            if(row == 0){
                return "Seçilməyib"
            }
            else{
                return fromRegionList[row-1].name
            }
        }
        else if(pickerView == toRegionPicker)
        {
            if(row == 0){
                return "Seçilməyib"
            }
            else{
                return toRegionList[row-1].name
            }
        }
        else
        {
            if(row == 0){
                return "Seçilməyib"
            }
            else{
                return tipler[row-1].name
            }
        }
    
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == picker)
        {
            if(row != 0){
                locationLbl.text = countryList[row - 1].name
                getRegions(countryId: countryList[row - 1].id!, type: 1)
                selectedFromCountry = "\(countryList[row-1].id!)"
            }
            else{
                locationLbl.text = "Seçilməyib"
                selectedFromCountry = ""
            }
            
        }
        else if(pickerView == toCountryPicker){
            
            if(row != 0){
                typeLbl.text = countryList[row-1].name
                getRegions(countryId: countryList[row-1].id!, type: 2)
                selectedTocountry = "\(countryList[row-1].id!)"
            }
            else
            {
                typeLbl.text = "Seçilməyib"
                selectedTocountry = ""
            }
            
            
        }
        else if(pickerView == fromRegionPicker)
        {
            if(row != 0){
                tecrubeLbl.text = fromRegionList[row - 1].name
                selectedFromRegion = "\(fromRegionList[row-1].id!)"
            }
            else
            {
                tecrubeLbl.text = "Seçilməyib"
                selectedFromRegion = ""
            }
            
        }
        else if(pickerView == toRegionPicker){
            if(row != 0){
                volumeLbl.text = toRegionList[row - 1].name
                selectedToRegion = "\(toRegionList[row-1].id!)"
            }
            else
            {
                volumeLbl.text = "Seçilməyib"
                selectedToRegion = ""
            }
        }
        else{
            if(filterType == "driver"){
                if(row != 0){
                               registerLbl.text = tipler[row - 1].name
                               selectedCarType = "\(tipler[row-1].id!)"
                           }
                           else{
                               registerLbl.text = "Seçilməyib"
                               selectedCarType = ""
                           }
            }
            else
            {
                if(row != 0){
                               yukTypeLbl.text = tipler[row - 1].name
                               selectedCargoType = "\(tipler[row-1].id!)"
                           }
                           else{
                               yukTypeLbl.text = "Seçilməyib"
                               selectedCargoType = ""
                           }
            }
           
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        for i in 0..<viewArray.count{
            viewArray[i].backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 0..<viewArray.count{
            viewArray[i].backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "yyyy-MM-dd"
        if(textField == weightTextField){
            weightLbl.text = dateFormatter.string(from: firstDatePicker.date) + " - "
             DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                self.secondDateTextField.becomeFirstResponder()
             })
           
            startDate = newDateFormatter.string(from: firstDatePicker.date)
        }
        if(textField == secondDateTextField){
           weightLbl.text = dateFormatter.string(from: firstDatePicker.date) + " - " + dateFormatter.string(from: secondDatePicker.date)
            endDate = newDateFormatter.string(from: secondDatePicker.date)
        }

    }

    @IBAction func cleanClicked(_ sender: Any) {
        selectedFromCountry = ""
        selectedFromRegion = ""
        selectedTocountry = ""
        selectedToRegion = ""
        startDate = ""
        endDate = ""
        selectedCargoType = ""
        selectedCarType = ""
        locationLbl.text = "Seçilməyib"
        tecrubeLbl.text = "Seçilməyib"
        registerLbl.text = "Seçilməyib"
        typeLbl.text = "Seçilməyib"
        volumeLbl.text = "Seçilməyib"
        yukTypeLbl.text = "Seçilməyib"
        weightLbl.text = "Seçilməyib"

        
        picker.selectRow(0, inComponent: 0, animated: true)
        fromRegionPicker.selectRow(0, inComponent: 0, animated: true)
        toCountryPicker.selectRow(0, inComponent: 0, animated: true)
        toRegionPicker.selectRow(0, inComponent: 0, animated: true)
        carTypePicker.selectRow(0, inComponent: 0, animated: true)
        cargoTypePicker.selectRow(0, inComponent: 0, animated: true)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.fromRegionPicker.reloadAllComponents()
            self.haradanRegHeightConst.constant = 0
            self.haradanRegionLblConst.constant = 0
            self.haradanRegionTopConst.constant = 0
            self.toRegionPicker.reloadAllComponents()
            self.harayaRegionHeightConst.constant = 0
            self.harayaRegionLblConst.constant = 0
            self.harayaRegionTopConst.constant = 0
            self.view.layoutIfNeeded()
                                           
        })
        
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        if(filterType == "order")
        {
            findOrderFunction!(selectedFromCountry, selectedFromRegion, selectedTocountry, selectedToRegion, startDate, endDate, selectedCargoType)
        }
        else
        {
            findDriverFunction!(selectedFromCountry, selectedFromRegion, selectedTocountry, selectedToRegion, startDate, endDate, selectedCarType)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCountries(){
        
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
      
        let countryUrl = "http://carryup.az/api/v1/country/list"
        guard let url = URL(string: countryUrl) else {return}
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5.0
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
                }
                    
                catch _{
                    DispatchQueue.main.async {
                        self.view.makeToast("Json Error")
                    }
                }
                
                DispatchQueue.main.async {
                    if(self.filterType == "driver"){
                        self.getCarTypes()
                    
                    }
                    else
                    {
                      //  self.connView.isHidden = true
                        self.getCargoTypes()
                    }
                  
                    self.picker.reloadAllComponents()
                    self.toCountryPicker.reloadAllComponents()
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
    
    
    func getRegions(countryId: Int, type: Int){
        if(type == 1){
            fromRegionList = []
            fromRegionPicker.reloadAllComponents()
            fromRegionPicker.selectRow(0, inComponent: 0, animated: true)
            tecrubeLbl.text = "Seçilməyib"
        }
        if(type == 2){
            toRegionList = []
            toRegionPicker.reloadAllComponents()
            volumeLbl.text = "Seçilməyib"
        }
        let regionUrl = "http://carryup.az/api/v1/country/\(countryId)/region/list"
        guard let url = URL(string: regionUrl) else {return}
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 3.0
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
                            for i in 0..<regionArray.count {
                                if(type == 1)
                                {
                                    self.fromRegionList.append(regionArray[i])
                                    DispatchQueue.main.async {
                                        UIView.animate(withDuration: 0.2, animations: {
                                            self.fromRegionPicker.reloadAllComponents()
                                            self.haradanRegHeightConst.constant = 45
                                            self.haradanRegionLblConst.constant = 18
                                            self.haradanRegionTopConst.constant = 20
                                            self.view.layoutIfNeeded()
                                        })
                             
                                    }
                                }
                                if(type == 2){
                                    self.toRegionList.append(regionArray[i])
                                    DispatchQueue.main.async {
                                        UIView.animate(withDuration: 0.2, animations: {
                                            self.toRegionPicker.reloadAllComponents()
                                            self.harayaRegionHeightConst.constant = 45
                                            self.harayaRegionLblConst.constant = 18
                                            self.harayaRegionTopConst.constant = 20
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
                                        self.fromRegionPicker.reloadAllComponents()
                                        self.haradanRegHeightConst.constant = 0
                                        self.haradanRegionLblConst.constant = 0
                                        self.haradanRegionTopConst.constant = 0
                                        self.view.layoutIfNeeded()
                                    })
                          
                                }
                            }
                            if(type == 2){
                                DispatchQueue.main.async {
                                    UIView.animate(withDuration: 0.2, animations: {
                                        self.toRegionPicker.reloadAllComponents()
                                        self.harayaRegionHeightConst.constant = 0
                                        self.harayaRegionLblConst.constant = 0
                                        self.harayaRegionTopConst.constant = 0
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
    
    
    func getCarTypes(){
        tipler = []
        let carUrl = "http://carryup.az/api/v1/car/types"
        guard let url = URL(string: carUrl) else {return}
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(CarTypeData.self, from: data)
                    for i in 0..<jsonData.data.count{
                        self.tipler.append(jsonData.data[i])
                    }
                }
                    
                catch let jsonError{
                    print(jsonError)
                    DispatchQueue.main.async {
                        self.view.makeToast("Json Error")
                    }
                }
                
                DispatchQueue.main.async {
                    self.connView.isHidden = true
                    self.carTypePicker.reloadAllComponents()
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
    
    func getCargoTypes(){
        tipler = []
        let carUrl = "http://carryup.az/api/v1/order/categories"
        guard let url = URL(string: carUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
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
                        self.connView.isHidden = true
                        self.carTypePicker.reloadAllComponents()
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
    
}
