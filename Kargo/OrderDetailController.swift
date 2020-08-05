//
//  OrderDetailController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 8/3/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import SDWebImage


struct  OrderDetail:Decodable {
    let open: Bool?
    let requested: Bool?
    let data: OrderDetailDataModel?
}

struct OrderDetailDataModel:Decodable {
    let id: Int?
    let user_id: Int?
    let order_category_id: Int?
    let from_city: String?
    let to_city: String?
    let cargo_tonnage_m3: Int?
    let cargo_tonnage_kq: Int?
    let price: String?
    let start_date: String?
    let end_date: String?
    let owner: TimeLineItemOwnerOrRegion?
    let category: TimeLineItemOwnerOrRegion?
    let from_country: TimeLineItemOwnerOrRegion?
    let from_region: TimeLineItemOwnerOrRegion?
    let to_country: TimeLineItemOwnerOrRegion?
    let to_region: TimeLineItemOwnerOrRegion?
}

struct UserDetailModel: Decodable {
    let status: String?
    let data: UserDetailDataModel?
    let requested_orders: [OrderDataModel2]?
}

struct UserDetailDataModel: Decodable{
    let id: Int?
    let username: String?
    let name: String?
    let avatar: String?
    let phone: String?
    let car_tonnage_kq: Int?
    let car_tonnage_m3: Int?
    let foreign_passport: String?
    let car_register_doc: String?
    let half_car_register_doc: String?
    let car_brand: TimeLineItemValyuta?
    let car_model: TimeLineItemValyuta?
    let car_type: TimeLineItemOwnerOrRegion?
}

struct SendRequestModel: Decodable{
    let status: String?
    let error: [String]?
}

class OrderDetailController: UIViewController, UIScrollViewDelegate
    
    
{
    
    @IBOutlet weak var orderOwnerNameLbl: UILabel!
    @IBOutlet weak var userImageView: UIView!
    @IBOutlet weak var contactsView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var voenView: UIView!
    @IBOutlet weak var destinationView: UIView!
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var yukTypeLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var volumeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var messageView: CustomView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var bottomView: SenedeBaxButtonView!
    @IBOutlet weak var acceptLbl: UILabel!
    @IBOutlet weak var haradanLbl: UILabel!
    @IBOutlet weak var harayaLbl: UILabel!
    @IBOutlet weak var kateqoriyaLbl: UILabel!
    @IBOutlet weak var cekiLbl: UILabel!
    @IBOutlet weak var olcuLbl: UILabel!
    @IBOutlet weak var tarixLbl: UILabel!
    
    
    var selectedOrder: TimeLineDataItem?
    var driverId: Int?
    
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    
    var phoneNumbers: String?
    @IBOutlet weak var phoneView: CustomView!
    @IBOutlet weak var whatsAppView: CustomView!
    var selectedLanguage: String?
    
    var actionType = 0
    
    @IBOutlet weak var thirdView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedLanguage = UserDefaults.standard.string(forKey: "Lang")
        
        haradanLbl.text = "from".addLocalizableString(str: selectedLanguage!)
        harayaLbl.text = "to".addLocalizableString(str: selectedLanguage!)
        kateqoriyaLbl.text = "cargo_type".addLocalizableString(str: selectedLanguage!)
        tarixLbl.text = "date".addLocalizableString(str: selectedLanguage!)
        cekiLbl.text = "capacity_kg".addLocalizableString(str: selectedLanguage!)
        olcuLbl.text = "capacity_m3".addLocalizableString(str: selectedLanguage!)
        acceptLbl.text = "accept".addLocalizableString(str: selectedLanguage!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            //            self.userImageView.roundCorners(corners: [.bottomRight], cornerRadius: 90.0)
            //            self.contactsView.roundCorners(corners: [.bottomRight], cornerRadius: 90.0)
            //            self.priceView.roundCorners(corners: [.bottomRight, .topLeft], cornerRadius: 60.0)
            //            self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
            //
        })
        
        let messageGesture = UITapGestureRecognizer(target: self, action: #selector(messageTapped))
        messageView.isUserInteractionEnabled = true
        messageGesture.cancelsTouchesInView = false
        messageView.addGestureRecognizer(messageGesture)
        
        let phoneGesture = UITapGestureRecognizer(target: self, action: #selector(phoneTapped))
        phoneView.isUserInteractionEnabled = true
        phoneGesture.cancelsTouchesInView = false
        phoneView.addGestureRecognizer(phoneGesture)
        
        let whatsappGesture = UITapGestureRecognizer(target: self, action: #selector(whatsappTapped))
        whatsAppView.isUserInteractionEnabled = true
        whatsappGesture.cancelsTouchesInView = false
        whatsAppView.addGestureRecognizer(whatsappGesture)
        
        let bottomGesture = UITapGestureRecognizer(target: self, action: #selector(acceptTapped))
        bottomGesture.cancelsTouchesInView = false
        bottomView.isUserInteractionEnabled = true
        bottomView.addGestureRecognizer(bottomGesture)
        
        getOrderDetails()
        setupDesign()
        addConnectionView()
        
    }
    
    override func viewWillLayoutSubviews() {
        self.userImageView.roundCorners(corners: [.bottomRight], cornerRadius: 90.0)
        self.contactsView.roundCorners(corners: [.bottomRight], cornerRadius: 90.0)
        self.priceView.roundCorners(corners: [.bottomRight, .topLeft], cornerRadius: 60.0)
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
        self.bottomView.roundCorners(corners: [.topRight], cornerRadius: 90.0)
    }
    
    @objc func acceptTapped(){
        if(self.acceptLbl.text == "accept".addLocalizableString(str: selectedLanguage!)){
            SendRequest()
        }
    }
    
    @objc func messageTapped(){
        actionType = 3
        if(self.phoneNumbers != nil){
            performSegue(withIdentifier: "segueToPhoneNumbers", sender: self)
            
        }
        
    }
    
    @objc func phoneTapped(){
        actionType = 2
        if(self.phoneNumbers != nil){
            performSegue(withIdentifier: "segueToPhoneNumbers", sender: self)
            
        }
        
    }
    
    @objc func whatsappTapped(){
        actionType = 1
        if(self.phoneNumbers != nil){
            performSegue(withIdentifier: "segueToPhoneNumbers", sender: self)
            
        }
        
    }
    
    func setupDesign(){
        
        setUpBackButton()
        // createShadow2(view: voenView)
        createShadow2(view: destinationView)
        createShadow2(view: thirdView)
    }
    
    func setUpBackButton(){
        
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.setImage(UIImage(named: "whiteBackIcon.png"), for: UIControl.State.normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 30)
        
        backButton.addTarget(self, action: #selector(backClciked), for: .touchUpInside)
        
        barItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = barItem
    }
    
    @objc func backClciked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func createShadow2(view: UIView){
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 30.0
        
    }
    
    
    
    func addConnectionView(){
        if let connectionView = Bundle.main.loadNibNamed("CheckConnectionView", owner: self, options: nil)?.first as? CheckConnectionView {
            connectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            // let currentWindow = UIApplication.shared.keyWindow
            // currentWindow?.addSubview(connectionView)
            self.view.addSubview(connectionView);
            connectionView.buttonView.clipsToBounds = true
            
            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.checkIndicator
            
            
            
            connectionView.tryButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        }
    }
    
    @objc func tryAgain(){
        getOrderDetails()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToPhoneNumbers"){
            let VC = segue.destination as! PhoneViewController
            VC.phoneNumbers = self.phoneNumbers ?? ""
            VC.actionType = self.actionType
        }
    }
    
    func getOrderDetails(){
        
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        // tipler = []
        let carUrl = "http://carryup.az/api/v1/order/detail/\((selectedOrder?.id)!)"
        guard let url = URL(string: carUrl) else {return}
        
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                
                //let output =   String(data: data, encoding: String.Encoding.utf8)
                // print("output: \(output)")
                
                do{
                    let jsonData = try JSONDecoder().decode(OrderDetail.self, from: data)
                    
                    self.driverId = jsonData.data?.owner?.id ?? 0
                    
                    DispatchQueue.main.async {
                        
                        if(jsonData.requested ?? true){
                            self.acceptLbl.text = "pending".addLocalizableString(str: self.selectedLanguage!)
                        }
                        
                        let fromCntry = jsonData.data?.from_country?.name ?? ""
                        let fromRegion = jsonData.data?.from_region?.name ?? ""
                        let fromCity = jsonData.data?.from_city ?? ""
                        
                        var fromTxt = fromCntry + ", " + fromRegion
                        if(fromCity != ""){
                            fromTxt = fromTxt + ", " + fromCity
                        }
                        self.fromLbl.text = fromTxt
                        
                        
                        let toCntry = jsonData.data?.to_country?.name ?? ""
                        let toRegion = jsonData.data?.to_region?.name ?? ""
                        let toCity = jsonData.data?.to_city ?? ""
                        
                        var toTxt = toCntry + ", " + toRegion
                        if(toCity != ""){
                            toTxt = toTxt + ", " + toCity
                        }
                        self.toLbl.text = toTxt
                        
                        self.yukTypeLbl.text = jsonData.data?.category?.name
                        
                        if let weight = jsonData.data?.cargo_tonnage_kq{
                            self.weightLbl.text = "\(weight)"
                        }
                        if let volume = jsonData.data?.cargo_tonnage_m3{
                            self.volumeLbl.text = "\(volume)"
                        }
                        
                        
                        let startDate = jsonData.data?.start_date ?? ""
                        let endDate = jsonData.data?.end_date ?? ""
                        if(startDate != "" && endDate != ""){
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let startDate = dateFormatter.date(from: startDate)
                            let endDate = dateFormatter.date(from: endDate)
                            
                            dateFormatter.dateFormat = "d MMM yyyy"
                            dateFormatter.locale = Locale.init(identifier: "az")
                            let goodDate = dateFormatter.string(from: startDate!) + " - " + dateFormatter.string(from: endDate!)
                            self.dateLbl.text = goodDate
                            
                        }
                        
                        
                        if let price = self.selectedOrder?.price, let valyuta = self.selectedOrder?.valyuta?.code{
                            // self.priceBtn.setTitle(price + " " + valyuta, for: .normal)
                            self.priceLbl.text = price + " " + valyuta
                        }
                        
                        if(jsonData.open!){
                            self.getOrderOwnerDetail()
                        }
                        else{
                            let refreshAlert = UIAlertController(title: "Ödəniş", message: "Ödəniş etməmisiniz.", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            
                          
                            self.present(refreshAlert, animated: true, completion: nil)
                        }
                        
                    }
                }
                    
                catch let jsonError{
                    print("JsonError: \(jsonError)")
                    self.view.makeToast("JsonError")
                }
                
                DispatchQueue.main.async {
                    // self.tipPickerView.reloadAllComponents()
                    // self.tipLbl.text  = self.tipler[0].name
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
    
    func getOrderOwnerDetail(){
        
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        // tipler = []
        let driverDetailUrl = "http://carryup.az/api/v1/user/profile/\(driverId!)"
        guard let url = URL(string: driverDetailUrl) else {return}
        
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                
                //       let output =   String(data: data, encoding: String.Encoding.utf8)
                //        print("output: \(output)")
                
                do{
                    let jsonData = try JSONDecoder().decode(UserDetailModel.self, from: data)
                    let avatar = jsonData.data?.avatar
                    
                    if let avatar = avatar{
                        let avatarUrl = URL(string: avatar)
                        DispatchQueue.main.async {
                            self.userImage.sd_setImage(with: avatarUrl)
                        }
                    }
                    
                    if let ownerName = jsonData.data?.name{
                        DispatchQueue.main.async {
                            self.orderOwnerNameLbl.text = ownerName
                        }
                        
                    }
                    self.phoneNumbers = jsonData.data?.phone
                    
                    
                }
                    
                catch let jsonError{
                    print("JsonError: \(jsonError)")
                    self.view.makeToast("Json Error")
                }
                
                DispatchQueue.main.async {
                    // self.tipPickerView.reloadAllComponents()
                    // self.tipLbl.text  = self.tipler[0].name
                    self.connView.isHidden = true
                }
            }
            else
            {
                
                
                if let error = error as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        self.checkConnIndicator.isHidden = true
                        self.checkConnButtonView.isHidden = false
                    }
                }
            }
            
            
        }.resume()
        
    }
    
    func SendRequest(){
        
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        let loginUrl = "http://carryup.az/api/v1/user/request/" + "\((selectedOrder?.id)!)"
        
        guard let url = URL(string: loginUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: urlRequest){(data, response, error) in
            
            DispatchQueue.main.async {
                self.connView.isHidden = true
            }
            guard let data = data else {return}
            
            //  let output =   String(data: data, encoding: String.Encoding.utf8)
            //  print("output: \(output)")
            if(error == nil){
                
                do{
                    let responseModel = try JSONDecoder().decode(SendRequestModel.self, from: data)
                    if(responseModel.status == "success"){
                        DispatchQueue.main.async {
                            self.acceptLbl.text = "pending".addLocalizableString(str: self.selectedLanguage!)
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.view.makeToast("Xəta baş verdi.")
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        whatsAppView.backgroundColor = UIColor(red: 25/255, green: 82/255, blue: 95/255, alpha: 1)
        phoneView.backgroundColor = UIColor(red: 25/255, green: 82/255, blue: 95/255, alpha: 1)
        messageView.backgroundColor = UIColor(red: 25/255, green: 82/255, blue: 95/255, alpha: 1)
        
        
        
    }
    
    
    
}
