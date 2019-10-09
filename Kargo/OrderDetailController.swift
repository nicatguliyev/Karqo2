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
}

class OrderDetailController: UIViewController

    
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
    
    
    var selectedOrder: TimeLineDataItem?
    var driverId: Int?
    
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var thirdView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.userImageView.roundCorners(corners: [.bottomRight], cornerRadius: 90.0)
            self.contactsView.roundCorners(corners: [.bottomRight], cornerRadius: 90.0)
            self.priceBtn.roundCorners(corners: [.bottomRight, .topLeft], cornerRadius: 60.0)
            self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
            
        })
        getOrderDetails()
        setupDesign()
        addConnectionView()
        
     
    }
    
    func setupDesign(){
//        if(UIScreen.main.bounds.height < 580){
//            nameLbl.font = nameLbl.font.withSize(18.0)
//            userImageWidth.constant = 70.0
//            userImageHeight.constant = 70.0
//        }
//        if(UIScreen.main.bounds.height > 730 && UIScreen.main.bounds.height < 800)
//        {
//            userImageWidth.constant = 100.0
//            userImageHeight.constant = 100.0
//        }
//        if(UIScreen.main.bounds.height > 800)
//        {
//            userImageWidth.constant = 120.0
//            userImageHeight.constant = 120.0
//        }
//
//        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(bottomViewClicked))
//        tapgesture.cancelsTouchesInView = false
//        bottomView.addGestureRecognizer(tapgesture)
//        bottomView.isUserInteractionEnabled = true
        
        setUpBackButton()
        createShadow2(view: voenView)
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
    
    func getOrderDetails(){
        
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
       // tipler = []
        let carUrl = "http://209.97.140.82/api/v1/order/detail/\((selectedOrder?.id)!)"
        guard let url = URL(string: carUrl) else {return}
        
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("Bearer " + (vars.user?.data?.token)!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                
                  // let output =   String(data: data, encoding: String.Encoding.utf8)
               //  print("output: \(output)")
                
                do{
                    let jsonData = try JSONDecoder().decode(OrderDetail.self, from: data)
                    
                    self.driverId = jsonData.data?.owner?.id ?? 0
                    
                    DispatchQueue.main.async {
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
                        
                        
                        let startDate = jsonData.data?.start_date ?? "null"
                        let endDate = jsonData.data?.end_date ?? "null"
                        
                        self.dateLbl.text = startDate + " - " + endDate
                        
                        
                        if let price = self.selectedOrder?.price, let valyuta = self.selectedOrder?.valyuta?.code{
                            self.priceBtn.setTitle(price + " " + valyuta, for: .normal)
                        }
                       
                        
                        self.getDriverDetail()
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
    
    func getDriverDetail(){
        
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        // tipler = []
        let driverDetailUrl = "http://209.97.140.82/api/v1/user/profile/\(driverId!)"
        guard let url = URL(string: driverDetailUrl) else {return}
        
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("Bearer " + (vars.user?.data?.token)!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                
                // let output =   String(data: data, encoding: String.Encoding.utf8)
                //  print("output: \(output)")
                
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
    
    
    

}
