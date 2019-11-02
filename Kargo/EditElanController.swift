//
//  EditElanController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 10/16/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit


struct EditOrderModel: Decodable{
    let status: String?
    let data: OrderDataModel2?
    let error: [String]?
    let avatar: String?
}

struct OrderDataModel2:Decodable {
    let id: Int?
    let user_id: Int?
    let order_category_id: Int?
    let from_country_id: Int?
    let from_region_id: Int?
    let from_city: String?
    let to_country_id: Int?
    let to_region_id: Int?
    let to_city: String?
    let start_date: String?
    let end_date: String?
    let cargo_tonnage_m3: Int?
    let cargo_tonnage_kq: Int?
    let size_x: String?
    let size_y: String?
    let size_z: String?
    let price: String?
    let price_valyuta: Int?
    let coordinates_x: String?
    let coordinates_y: String?
    let category: TimeLineItemOwnerOrRegion?
    let valyuta: TimeLineItemValyuta?
    let from_country: TimeLineItemOwnerOrRegion?
    let from_region: TimeLineItemOwnerOrRegion?
    let to_country: TimeLineItemOwnerOrRegion?
    let to_region: TimeLineItemOwnerOrRegion?
    
}

class EditElanController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {
    
    
    @IBOutlet weak var fromCountrySelectBtn: CustomSelectButton!
    @IBOutlet weak var fromCountryLbl: UILabel!
    @IBOutlet weak var fromCountryTextField: UITextField!
    @IBOutlet weak var fromCitySelectBtn: CustomSelectButton!
    @IBOutlet weak var fromCityLbl: UILabel!
    @IBOutlet weak var fromCityTextField: UITextField!
    @IBOutlet weak var fromCityHeight: NSLayoutConstraint!
    @IBOutlet weak var fromRegionTextField: UITextField!
    @IBOutlet weak var fromRegionHeight: NSLayoutConstraint!
    @IBOutlet weak var toCountrySelectBtn: CustomSelectButton!
    @IBOutlet weak var toCountryLbl: UILabel!
    @IBOutlet weak var toCountryTextField: UITextField!
    @IBOutlet weak var toCitySelectBtn: CustomSelectButton!
    @IBOutlet weak var toCityLbl: UILabel!
    @IBOutlet weak var toCityTextField: UITextField!
    @IBOutlet weak var toCityHeight: NSLayoutConstraint!
    @IBOutlet weak var toRegionTextField: UITextField!
    @IBOutlet weak var toREgionHeight: NSLayoutConstraint!
    @IBOutlet weak var yukTypeSelectBtn: CustomSelectButton!
    @IBOutlet weak var yukTypeLbl: UILabel!
    @IBOutlet weak var yukTypeTextField: UITextField!
    @IBOutlet weak var yukTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var yukWeightTextField: UITextField!
    @IBOutlet weak var yukWeightHeight: NSLayoutConstraint!
    @IBOutlet weak var yukVolumeTextField: UITextField!
    @IBOutlet weak var yukVolumeHeight: NSLayoutConstraint!
    @IBOutlet weak var yukLengthTextField: UITextField!
    @IBOutlet weak var yukLengthHeight: NSLayoutConstraint!
    @IBOutlet weak var yukEnTextField: UITextField!
    @IBOutlet weak var yukEnHeight: NSLayoutConstraint!
    @IBOutlet weak var yukHundurTextField: UITextField!
    @IBOutlet weak var yukHundurHeight: NSLayoutConstraint!
    @IBOutlet weak var dateSelectBtn: CustomSelectButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var valyutaSelectBtn: CustomSelectButton!
    @IBOutlet weak var valyutaLbl: UILabel!
    @IBOutlet weak var valyutaTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var mapTextField: UITextField!
    @IBOutlet weak var mapSelectBtn: CustomSelectButton!
    @IBOutlet weak var typeLbl: UILabel!
    
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var ovalView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bigActionBar: UIView!
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    
    var selectedAdvId: Int?
    var selectedAdv: TimeLineDataItem?
    
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
    var errorMessages = [String]()
    var dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addConnectionView()
        setUpDesign()
        pickerViewSettings()
        getCountries()
        
        
    }
    
    
    
    func setUpDesign(){
        
        customBtnArray = [fromCountrySelectBtn, fromCitySelectBtn, toCountrySelectBtn, toCitySelectBtn, yukTypeSelectBtn, dateSelectBtn, valyutaSelectBtn]
        scrollView.delegate = self
        
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = false
        createShadow2(view: ovalView)
        setUpBackButton()
        
        changeBtn.layer.cornerRadius = 12
        cancelBtn.layer.cornerRadius = 12
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
        })
        
        if((UserDefaults.standard.string(forKey: "USERID"))! ==  "3"){
            yukWeightHeight.constant = 0
            yukVolumeHeight.constant = 0
            yukEnHeight.constant = 0
            yukHundurHeight.constant = 0
            yukLengthHeight.constant = 0
            typeLbl.text = "Avtomobil tipi"
            // yukTypeHeight.constant = 0
        }
        
        if(selectedAdv?.from_region_id == nil){
            fromCityHeight.constant = 0
        }
        else{
            getRegions(countryId: (selectedAdv?.from_country_id)!, type: 1, firstTime: true)
        }
        if(selectedAdv?.to_region_id == nil){
            toCityHeight.constant = 0
        }
        else{
            getRegions(countryId: (selectedAdv?.to_country_id)!, type: 2, firstTime: true)
        }
        
        fromRegionTextField.text = self.selectedAdv?.from_city
        toRegionTextField.text = self.selectedAdv?.to_city
        priceTextField.text = self.selectedAdv?.price
        selectedFromCountry = "\(selectedAdv?.from_country_id ?? 0)"
        selectedFromCity = "\(selectedAdv?.from_region_id ?? 0)"
        selectedToCountry = "\(selectedAdv?.to_country_id ?? 0)"
        selectedToCity = "\(selectedAdv?.to_region_id ?? 0)"
        selectedValyuta = "\(selectedAdv?.valyuta?.id ?? 0)"
        
        if((UserDefaults.standard.string(forKey: "USERID")) == "3"){
            selectedType = "\(selectedAdv?.car_type?.id ?? 0)"
        }
        else
        {
            selectedType = "\(selectedAdv?.category?.id ?? 0)"
        }
        
        //   selectedFromCity =
        
    }
    
    //    override func viewDidLayoutSubviews() {
    //        <#code#>
    //    }
    
    func createShadow2(view: UIView){
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 15.0
        
        
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
    
    func pickerViewSettings(){
        pickerViews = [fromCountryPicker, fromCityPicker, toCountryPicker, toCityPicker, typePicker, valyutaPicker]
        
        for i in 0..<pickerViews.count{
            pickerViews[i].delegate = self
            pickerViews[i].dataSource = self
        }
        
        let fromCountryTapGesture = UITapGestureRecognizer(target: self, action: #selector(fromCountryTapped))
        fromCitySelectBtn.isUserInteractionEnabled = true
        fromCountryTapGesture.cancelsTouchesInView = false
        fromCountrySelectBtn.addGestureRecognizer(fromCountryTapGesture)
        
        let fromCityTapGesture = UITapGestureRecognizer(target: self, action: #selector(fromCityTapped))
        fromCitySelectBtn.isUserInteractionEnabled = true
        fromCityTapGesture.cancelsTouchesInView = false
        fromCitySelectBtn.addGestureRecognizer(fromCityTapGesture)
        
        let toCountryTapGesture = UITapGestureRecognizer(target: self, action: #selector(toCountryTapped))
        toCountrySelectBtn.isUserInteractionEnabled = true
        toCountryTapGesture.cancelsTouchesInView = false
        toCountrySelectBtn.addGestureRecognizer(toCountryTapGesture)
        
        let toCityTapGesture = UITapGestureRecognizer(target: self, action: #selector(toCityTapped))
        toCitySelectBtn.isUserInteractionEnabled = true
        toCityTapGesture.cancelsTouchesInView = false
        toCitySelectBtn.addGestureRecognizer(toCityTapGesture)
        
        let typeTapGesture = UITapGestureRecognizer(target: self, action: #selector(typeTapped))
        yukTypeSelectBtn.isUserInteractionEnabled = true
        typeTapGesture.cancelsTouchesInView = false
        yukTypeSelectBtn.addGestureRecognizer(typeTapGesture)
        
        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTapped))
        dateSelectBtn.isUserInteractionEnabled = true
        dateTapGesture.cancelsTouchesInView = false
        dateSelectBtn.addGestureRecognizer(dateTapGesture)
        
        let valyutaTapGesture = UITapGestureRecognizer(target: self, action: #selector(valyutaTapped))
        valyutaSelectBtn.isUserInteractionEnabled = true
        valyutaTapGesture.cancelsTouchesInView = false
        valyutaSelectBtn.addGestureRecognizer(valyutaTapGesture)
        
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        mapSelectBtn.isUserInteractionEnabled = true
        mapTapGesture.cancelsTouchesInView = false
        mapSelectBtn.addGestureRecognizer(mapTapGesture)
        
        mapTextField.isEnabled = false
        
        
        hiddenTextFields = [fromCountryTextField, fromCityTextField, toCountryTextField, toCityTextField, yukTypeTextField, valyutaTextField] as! [UITextField]
        
        for i in 0..<hiddenTextFields.count{
            hiddenTextFields[i].inputView = pickerViews[i]
        }
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        firstDatePicker.datePickerMode = .date
        startDateTextField.inputView = firstDatePicker
        
        secondDatePicker.datePickerMode = .date
        endDateTextField.inputView = secondDatePicker
        
        let loc = Locale(identifier: "az")
        firstDatePicker.locale = loc
        secondDatePicker.locale = loc
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        
        let startDate = formatter1.date(from: (self.selectedAdv?.start_date!)!)
        let endDate = formatter1.date(from: (self.selectedAdv?.end_date!)!)
        
        firstDatePicker.date = startDate!
        secondDatePicker.date = endDate!
        
        dateLbl.text = dateFormatter.string(from: startDate!) + " - " + dateFormatter.string(from: endDate!)
        
        //haradanCityHeight.constant = 0
        // haradanRegionHeight.constant = 0
        //  harayaCityViewHeight.constant = 0
        //  harayaRegionViewHeight.constant = 0
        
        fromCountryTextField.delegate = self
        fromCityTextField.delegate = self
        toCountryTextField.delegate = self
        toCityTextField.delegate = self
        yukTypeTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        valyutaTextField.delegate = self
        mapTextField.delegate = self
        
        //        mapTextField.isEnabled = false
        //        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        //        mapTextField.isUserInteractionEnabled = true
        //        mapTextField.addGestureRecognizer(mapTapGesture)
    }
    
    @objc func fromCountryTapped(){
        fromCountryTextField.becomeFirstResponder()
    }
    
    @objc func fromCityTapped(){
        fromCityTextField.becomeFirstResponder()
    }
    
    @objc func toCountryTapped(){
        toCountryTextField.becomeFirstResponder()
    }
    
    @objc func toCityTapped(){
        toCityTextField.becomeFirstResponder()
    }
    
    @objc func typeTapped(){
        yukTypeTextField.becomeFirstResponder()
    }
    
    @objc func dateTapped(){
        //print("DateTapped")
        startDateTextField.becomeFirstResponder()
    }
    
    @objc func valyutaTapped(){
        valyutaTextField.becomeFirstResponder()
    }
    
    @objc func mapTapped(){
        performSegue(withIdentifier: "segueToMapController", sender: self)
    }
    
    
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == fromCountryPicker || pickerView == toCountryPicker){
            return countryList.count
        }
            
        else if(pickerView == typePicker){
            return tipler.count
        }
            
        else if(pickerView == valyutaPicker){
            return valyutas.count
        }
        else if(pickerView == fromCityPicker){
            return fromRegionList.count+1
        }
        else if(pickerView == toCityPicker){
            return toRegionList.count+1
        }
        else{
            return 5
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == fromCountryPicker || pickerView == toCountryPicker){
            
            return countryList[row].name
            
        }
            
        else if(pickerView == typePicker){
            
            return tipler[row].name
            
            
        }
        else if(pickerView == valyutaPicker){
            
            return valyutas[row].code
            
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
            fromCountryLbl.text = countryList[row].name
            selectedFromCountry = "\(countryList[row].id!)"
            getRegions(countryId: countryList[row].id!, type: 1, firstTime: false)
        }
        if(pickerView == fromCityPicker){
            if(row != 0){
                fromCityLbl.text = fromRegionList[row-1].name
                selectedFromCity = "\(fromRegionList[row-1].id!)"
            }
            else{
                fromCityLbl.text = "Seçilməyib"
                selectedFromCity = ""
            }
        }
        
        if(pickerView == toCountryPicker){
            toCountryLbl.text = countryList[row].name
            selectedToCountry = "\(countryList[row].id!)"
            getRegions(countryId: countryList[row].id!, type: 2, firstTime: false)
        }
        
        if(pickerView == toCityPicker){
            if(row != 0){
                toCityLbl.text = toRegionList[row-1].name
                selectedToCity = "\(toRegionList[row-1].id!)"
            }
            else{
                toCityLbl.text = "Seçilməyib"
                selectedToCity = ""
            }
        }
        
        if(pickerView == valyutaPicker){
            valyutaLbl.text = valyutas[row].code
            selectedValyuta = "\(valyutas[row].id!)"
        }
        if(pickerView == typePicker){
            yukTypeLbl.text = tipler[row].name
            selectedType = "\(tipler[row].id!)"
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 0..<customBtnArray.count{
            customBtnArray[i].backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.05)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == startDateTextField){
            dateLbl.text = dateFormatter.string(from: firstDatePicker.date) + " - "
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                self.endDateTextField.becomeFirstResponder()
            })
            
        }
        if(textField == endDateTextField){
            dateLbl.text = dateFormatter.string(from: firstDatePicker.date) + " - " + dateFormatter.string(from: secondDatePicker.date)
        }
        
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
        //self.navigationController?.popViewController(animated: true)
        if(selectedAdv?.from_region_id != nil){
            getRegions(countryId: (selectedAdv?.from_country_id)!, type: 1, firstTime: true)
        }
        if(selectedAdv?.to_region_id != nil){
            getRegions(countryId: (selectedAdv?.to_country_id)!, type: 2, firstTime: true)
        }
        getCountries()
        
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
                            if(self.selectedAdv?.from_country_id == countryArray[i].id){
                                DispatchQueue.main.async {
                                    self.fromCountryLbl.text = countryArray[i].name
                                    self.fromCountryPicker.selectRow(i, inComponent: 0, animated: true)
                                }
                                
                            }
                            if(self.selectedAdv?.to_country_id == countryArray[i].id){
                                DispatchQueue.main.async {
                                    self.toCountryLbl.text = countryArray[i].name
                                    self.toCountryPicker.selectRow(i, inComponent: 0, animated: true)
                                }
                                
                                
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        if((UserDefaults.standard.string(forKey: "USERROLE")) == "4")
                        {
                            self.getCargoTypes()
                            
                        }
                        else
                            
                        {
                            self.getCarTypes()
                        }
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
    
    func getCarTypes(){
        tipler = []
        let carUrl = "http://209.97.140.82/api/v1/car/types"
        guard let url = URL(string: carUrl) else {return}
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(CarTypeData.self, from: data)
                    print(jsonData)
                    for i in 0..<jsonData.data.count{
                        self.tipler.append(jsonData.data[i])
                        if(self.selectedAdv?.car_type?.id == self.tipler[i].id){
                            DispatchQueue.main.async {
                                self.yukTypeLbl.text = self.tipler[i].name
                                self.typePicker.selectRow(i, inComponent: 0, animated: true)
                            }
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.getValyutas()
                        
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
        let carUrl = "http://209.97.140.82/api/v1/order/categories"
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
                        if(self.selectedAdv?.category?.id == self.tipler[i].id){
                            DispatchQueue.main.async {
                                self.yukTypeLbl.text = self.tipler[i].name
                                self.typePicker.selectRow(i, inComponent: 0, animated: true)
                            }
                            
                        }
                        
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
    
    
    func getAdvDetails(){
        
        var orderDetailUrl = ""
        if((UserDefaults.standard.string(forKey: "USERROLE")) == "3")
        {
            orderDetailUrl = "http://209.97.140.82/api/v1/driver/detail/" + "\((self.selectedAdv?.id)!)"
        }
        else{
            orderDetailUrl = "http://209.97.140.82/api/v1/order/detail/" + "\((self.selectedAdv?.id)!)"
        }
        
        
        
        
        guard let url = URL(string: orderDetailUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                // let outputStr  = String(data: data, encoding: String.Encoding.utf8)
                // print(outputStr!)
                do{
                    let jsonData = try JSONDecoder().decode(EditOrderModel.self, from: data)
                    DispatchQueue.main.async {
                        self.coord_x = jsonData.data?.coordinates_x ?? ""
                        self.coord_y = jsonData.data?.coordinates_y ?? ""
                        self.mapTextField.text = self.coord_x + ", " + self.coord_y
                        self.yukWeightTextField.text = "\(jsonData.data?.cargo_tonnage_kq ?? 0)"
                        self.yukVolumeTextField.text = "\(jsonData.data?.cargo_tonnage_m3 ?? 0)"
                        self.yukLengthTextField.text = "\(jsonData.data?.size_x ?? "")"
                        self.yukEnTextField.text = "\(jsonData.data?.size_y ?? "")"
                        self.yukHundurTextField.text = "\(jsonData.data?.size_z ?? "")"
                        
                    }
                    
                }
                    
                catch let jsonError{
                    DispatchQueue.main.async {
                        print(jsonError)
                        self.view.endEditing(true)
                        self.connView.isHidden = true
                        self.view.makeToast("Xəta baş verdi: Json Error")
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
    
    func getValyutas(){
        valyutas = []
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
                    
                    for j in 0..<self.valyutas.count{
                        if(self.selectedAdv?.price_valyuta == self.valyutas[j].id){
                            DispatchQueue.main.async {
                                self.valyutaLbl.text = self.valyutas[j].code
                                self.valyutaPicker.selectRow(j, inComponent: 0, animated: true)
                            }
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.getAdvDetails()
                        
                    }
                    
                }
                    
                catch let jsonError{
                    print(jsonError)
                    DispatchQueue.main.async {
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
    
    func getRegions(countryId: Int, type: Int, firstTime: Bool){
        if(type == 1){
            fromRegionList = []
        }
        if(type == 2){
            toRegionList = []
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
                                            self.fromCityHeight.constant = 91
                                            self.view.layoutIfNeeded()
                                            if(firstTime){
                                                for i in 0..<self.fromRegionList.count{
                                                    if(self.selectedAdv?.from_region_id == self.fromRegionList[i].id){
                                                        self.fromCityLbl.text = self.fromRegionList[i].name
                                                        self.fromCityPicker.selectRow(i+1, inComponent: 0, animated: true)
                                                    }
                                                }
                                            }
                                            else{
                                                self.fromCityLbl.text = "Seçilməyib"
                                                self.fromCityPicker.selectRow(0, inComponent: 0, animated: true)
                                            }
                                        })
                                        
                                    }
                                }
                                if(type == 2){
                                    self.toRegionList.append(regionArray[i])
                                    DispatchQueue.main.async {
                                        self.toCityPicker.reloadAllComponents()
                                        UIView.animate(withDuration: 0.2, animations: {
                                            self.toCityHeight.constant = 91
                                            self.view.layoutIfNeeded()
                                            if(firstTime){
                                                for i in 0..<self.toRegionList.count{
                                                    if(self.selectedAdv?.to_region_id == self.toRegionList[i].id){
                                                        self.toCityLbl.text = self.toRegionList[i].name
                                                        self.toCityPicker.selectRow(i+1, inComponent: 0, animated: true)
                                                    }
                                                }
                                            }
                                            else{
                                                self.toCityLbl.text = "Seçilməyib"
                                                self.toCityPicker.selectRow(0, inComponent: 0, animated: true)
                                            }
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
                                        self.fromCityHeight.constant = 0
                                        self.view.layoutIfNeeded()
                                    })
                                    
                                }
                            }
                            if(type == 2){
                                DispatchQueue.main.async {
                                    UIView.animate(withDuration: 0.2, animations: {
                                        self.toCityHeight.constant = 0
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
        if(segue.identifier == "segueToRequiredList")
        {
            let VC = segue.destination as! ErrorMessageController
            VC.errorMessages = self.errorMessages
        }
    }
    
    func updateDriverAdv(){
        
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
        
        let loginUrl = "http://209.97.140.82/api/v1/driver/update"
        
        guard let url = URL(string: loginUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters: [String: Any] = [
            "id": "\((selectedAdv?.id)!)",
            "from_country_id": selectedFromCountry,
            "from_region_id": selectedFromCity,
            "from_city": fromRegionTextField.text!,
            "to_country_id": selectedToCountry,
            "to_region_id": selectedToCity,
            "to_city": toRegionTextField.text!,
            "start_date": startDate,
            "end_date": endDate,
            "price": priceTextField.text!,
            "price_valyuta": selectedValyuta,
            "coordinates_x": coord_x,
            "coordinates_y": coord_y,
            "car_type": selectedType
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
                
                //    let outputStr  = String(data: data, encoding: String.Encoding.utf8)
                //    print(outputStr)
                do{
                    
                    let addOrderResponse = try JSONDecoder().decode(EditOrderModel.self, from: data)
                    DispatchQueue.main.async {
                        
                        if(addOrderResponse.status == "success"){
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
    
    func updateOrderAdv(){
        
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
        
        let loginUrl = "http://209.97.140.82/api/v1/order/update"
        
        guard let url = URL(string: loginUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters: [String: Any] = [
            "id": "\((selectedAdv?.id)!)",
            "from_country_id": selectedFromCountry,
            "from_region_id": selectedFromCity,
            "from_city": fromRegionTextField.text!,
            "to_country_id": selectedToCountry,
            "to_region_id": selectedToCity,
            "to_city": toRegionTextField.text!,
            "start_date": startDate,
            "end_date": endDate,
            "cargo_tonnage_m3": yukVolumeTextField.text!,
            "cargo_tonnage_kq": yukWeightTextField.text!,
            "order_category_id": selectedType,
            "size_x": yukLengthTextField.text!,
            "size_y": yukEnTextField.text!,
            "size_z": yukHundurTextField.text!,
            "price": priceTextField.text!,
            "price_valyuta": selectedValyuta,
            "coordinates_x": coord_x,
            "coordinates_y": coord_y,
            
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
                
                //    let outputStr  = String(data: data, encoding: String.Encoding.utf8)
                //    print(outputStr)
                do{
                    
                    let addOrderResponse = try JSONDecoder().decode(EditOrderModel.self, from: data)
                    DispatchQueue.main.async {
                        
                        if(addOrderResponse.status == "success"){
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
    
    
    @IBAction func changeClicked(_ sender: Any) {
        if((UserDefaults.standard.string(forKey: "USERROLE")) == "4"){
            updateOrderAdv()
        }
        else{
            updateDriverAdv()
        }
    }
    
    
    
}
