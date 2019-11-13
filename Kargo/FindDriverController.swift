//
//  FindDriverController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/6/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import OneSignal

struct TimeLineFullData: Decodable{
    let timeline: TimeLine?
}


struct TimeLine: Decodable {
    let current_page: Int?
    let data: [TimeLineDataItem]?
    let last_page: Int?
    let next_page_url: String?
    
}


struct  TimeLineDataItem:Decodable {
    let id: Int?
    let user_id: Int?
    let from_country_id: Int?
    let from_region_id: Int?
    let from_city: String?
    let to_country_id: Int?
    let to_region_id: Int?
    let to_city: String?
    let price: String?
    let price_valyuta: Int?
    let start_date: String?
    let end_date: String?
    let car_type: TimeLineItemOwnerOrRegion?
    let owner: TimeLineOwner?
    let valyuta: TimeLineItemValyuta?
    let category: TimeLineItemOwnerOrRegion?
    let from_country: TimeLineItemOwnerOrRegion?
    let from_region: TimeLineItemOwnerOrRegion?
    let to_country: TimeLineItemOwnerOrRegion?
    let to_region: TimeLineItemOwnerOrRegion?
}


struct TimeLineItemOwnerOrRegion:Decodable {
    let id: Int?
    let name: String?
}


struct TimeLineItemValyuta:Decodable {
    let id: Int?
    let code: String?
}

struct TimeLineOwner:Decodable {
    let id: Int?
    let name: String?
    let car_type: TimeLineItemOwnerOrRegion?
}

class FindDriverController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate, UIScrollViewDelegate{
  
    
    var menuBtn = UIButton()
    var menuBarItem = UIBarButtonItem()
    var navBarColor = UIColor()
    @IBOutlet weak var ovalView: UIView!
    @IBOutlet weak var driverCollectionView: UICollectionView!
    var serviceType = 1
    @IBOutlet weak var findDriverLbl: UILabel!
    @IBOutlet weak var allDriversLbl: UILabel!
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    var orders = [TimeLineDataItem]()
    var currentPage = 1
    var isLoading = false
    var nextPageUrl: String?
    var filterType = ""
    var selectedOrder: TimeLineDataItem?
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    var selectedFromCountry = ""
    var selectedFromRegion = ""
    var selectedTocountry = ""
    var selectedToRegion = ""
    var selectedCarType = ""
    var selectedCargoType = ""
    var startDate = ""
    var endDate = ""
    
    var elanType = ""
    var selectedAdv: TimeLineDataItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OneSignal.sendTag("user_id", value: "\((UserDefaults.standard.string(forKey: "USERID"))!)")
        
        if(vars.isNotf == true && UserDefaults.standard.string(forKey: "USERROLE") == "4"){
            DispatchQueue.main.asyncAfter(deadline: .now()+0.00001, execute: {
                self.performSegue(withIdentifier: "segueToNotf", sender: self)
            })
        }
        
        self.revealViewController()?.delegate = self
        navBarColor = UIColor(red: 0, green: 193, blue: 138, alpha: 1)
        setUpNavigationBar()
        setUpMenuButton()
        addConnectionView()
        
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.ovalView.roundCorners(corners: [.bottomRight, .topRight], cornerRadius: 90.0)
        })
        
        filterBtn.layer.cornerRadius = 12.0
        addBtn.layer.cornerRadius = 12.0

        if(UserDefaults.standard.string(forKey: "USERROLE") == "4"){
            elanType = "orderElan"
            findDriverLbl.text = "Sürücü tap"
            allDriversLbl.text = "Bütün sürücülər"
             getDrivers(currentPage: currentPage, fromCountry: selectedFromCountry, fromRegion: selectedFromRegion, toCountry: selectedTocountry, toRegion: selectedToRegion, startDate: startDate, endDate: endDate, carType: selectedCarType)
                 filterType = "driver"
        }
        else{
            elanType = "driverElan"
                findDriverLbl.text = "Yüklər"
            allDriversLbl.isHidden = true
                    // allDriversLbl.text = "Bütün sifarişlər"
                getOrders(currentPage: currentPage, fromCountry: selectedFromCountry, fromRegion: selectedFromRegion, toCountry: selectedTocountry, toRegion: selectedToRegion, startDate: startDate, endDate: endDate, cargoType: selectedCargoType)
                    filterType = "order"
          
        }
        
       driverCollectionView.register(UINib(nibName: "FindOrderCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell2")
    
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
        if(UserDefaults.standard.string(forKey: "USERROLE") == "3"){
              getOrders(currentPage: currentPage, fromCountry: selectedFromCountry, fromRegion: selectedFromRegion, toCountry: selectedTocountry, toRegion: selectedToRegion, startDate: startDate, endDate: endDate, cargoType: selectedCargoType)
            
        }
        else
        {
              getDrivers(currentPage: currentPage, fromCountry: selectedFromCountry, fromRegion: selectedFromRegion, toCountry: selectedTocountry, toRegion: selectedToRegion, startDate: startDate, endDate: endDate, carType: selectedCarType)
        }
       
    }
    
    func setUpMenuButton(){
        
        menuBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuBtn.setImage(UIImage(named: "menuIcon.png"), for: UIControl.State.normal)
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        menuBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 30)
        
        
        menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        menuBarItem = UIBarButtonItem(customView: menuBtn)
        
        self.navigationItem.leftBarButtonItem = menuBarItem
        revealViewController()?.rearViewRevealWidth = 300
        
        self.revealViewController()?.rearViewRevealOverdraw = 0
        self.revealViewController()?.bounceBackOnOverdraw = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = false
    }
    
    func setUpNavigationBar(){
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! FindOrderCollectionCell
            createShadow(view: cell.mainView)
            createShadow2(view: cell.nameView)
            cell.removeBtn.isHidden = true
            cell.editBtn.isHidden = true
            cell.nameView.layer.cornerRadius = 10
          //  cell.priceView.roundCorners(corners: [.bottomRight, .topLeft], cornerRadius: 50.0)
          //  self.createShadow2(view: cell.priceView)
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                cell.priceView.roundCorners(corners: [.bottomRight, .topLeft], cornerRadius: 50.0)
                self.createShadow2(view: cell.priceView)
            })
        
        if(UserDefaults.standard.string(forKey: "USERROLE") == "4"){
           cell.tipLbl.text = "Nəqliyyat vasitəsinin tipi"
            
            cell.personNameLbl.text = orders[indexPath.row].owner?.name
            let fromCountryName = orders[indexPath.row].from_country?.name
            let fromRegionName = orders[indexPath.row].from_region?.name
            let fromCityName = orders[indexPath.row].from_city
            
            var fullFrom = ""
            if let fromCountryName = fromCountryName{
                fullFrom = fullFrom + fromCountryName
            }
            if let fromRegionName = fromRegionName{
                fullFrom = fullFrom + ", " + fromRegionName
            }
            if let fromCityName = fromCityName{
                fullFrom = fullFrom + ", " + fromCityName
            }
            cell.fromCountryLbl.text = fullFrom
            
            
            let toCountryName = orders[indexPath.row].to_country?.name
            let toRegionName = orders[indexPath.row].to_region?.name
            let toCityName = orders[indexPath.row].to_city
            
            var fullTo = ""
            if let toCountryName = toCountryName{
                fullTo = fullTo + toCountryName
            }
            if let toRegionName = toRegionName{
                fullTo = fullTo + ", " + toRegionName
            }
            if let toCityName = toCityName{
                fullTo = fullTo + ", " + toCityName
            }
            cell.toCountryLbl.text = fullTo
            
            let startDate = orders[indexPath.row].start_date
            let endDate = orders[indexPath.row].end_date
            
                 if(startDate != nil && endDate != nil && startDate != "" && endDate != ""){
                      let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                      let startDate = dateFormatter.date(from: startDate!)
                      let endDate = dateFormatter.date(from: endDate!)
                            
                            dateFormatter.dateFormat = "d MMM yyyy"
                            dateFormatter.locale = Locale.init(identifier: "az")
                            let goodDate = dateFormatter.string(from: startDate!) + " - " + dateFormatter.string(from: endDate!)
                            cell.dateLbl.text = goodDate
                      //cell.dateLbl.text = startDate! + " / " + endDate!
                  }
            
            if let price = orders[indexPath.row].price, let valyuta = orders[indexPath.row].valyuta?.code{
                cell.priceLbl.text = price + " " + valyuta
            }
            else
            {
                cell.priceLbl.text = "null"
            }
           cell.typeLbl.text = orders[indexPath.row].car_type?.name
        }
        else{
            cell.tipLbl.text = "Yükün növü"
            cell.personNameLbl.text = orders[indexPath.row].owner?.name
            let fromCountryName = orders[indexPath.row].from_country?.name
            let fromRegionName = orders[indexPath.row].from_region?.name
            let fromCityName = orders[indexPath.row].from_city
            
            var fullFrom = ""
            if let fromCountryName = fromCountryName{
                fullFrom = fullFrom + fromCountryName
            }
            if let fromRegionName = fromRegionName{
                fullFrom = fullFrom + ", " + fromRegionName
            }
            if let fromCityName = fromCityName{
                fullFrom = fullFrom + ", " + fromCityName
            }
            cell.fromCountryLbl.text = fullFrom
            
            
            let toCountryName = orders[indexPath.row].to_country?.name
            let toRegionName = orders[indexPath.row].to_region?.name
            let toCityName = orders[indexPath.row].to_city
            
            var fullTo = ""
            if let toCountryName = toCountryName{
                fullTo = fullTo + toCountryName
            }
            if let toRegionName = toRegionName{
                fullTo = fullTo + ", " + toRegionName
            }
            if let toCityName = toCityName{
                fullTo = fullTo + ", " + toCityName
            }
            cell.toCountryLbl.text = fullTo
            
            let startDate = orders[indexPath.row].start_date
            let endDate = orders[indexPath.row].end_date
            
            if(startDate != nil && endDate != nil && startDate != "" && endDate != ""){
                let dateFormatter = DateFormatter()
                      dateFormatter.dateFormat = "yyyy-MM-dd"
                let startDate = dateFormatter.date(from: startDate!)
                let endDate = dateFormatter.date(from: endDate!)
                      
                      dateFormatter.dateFormat = "d MMM yyyy"
                      dateFormatter.locale = Locale.init(identifier: "az")
                      let goodDate = dateFormatter.string(from: startDate!) + " - " + dateFormatter.string(from: endDate!)
                      cell.dateLbl.text = goodDate
                //cell.dateLbl.text = startDate! + " / " + endDate!
            }
            
            if let price = orders[indexPath.row].price, let valyuta = orders[indexPath.row].valyuta?.code{
                cell.priceLbl.text = price + " " + valyuta
            }
            else
            {
                cell.priceLbl.text = "null"
            }
             cell.typeLbl.text = orders[indexPath.row].category?.name
        }
        
            return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

             return CGSize(width: (view.frame.width - 32) , height: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 22, left: 0, bottom: 90, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 40.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(UserDefaults.standard.string(forKey: "USERROLE") == "4"){
             selectedOrder = orders[indexPath.row]
             performSegue(withIdentifier: "SegueToDriverInfo", sender: self)
            
        }
        else
        {
            selectedOrder = orders[indexPath.row]
            performSegue(withIdentifier: "segueToOrderDetail", sender: self)
        }


    }
    
    func createShadow(view: UIView){
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 1
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 15.0
    }
    
    
    func createShadow2(view: UIView){
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
        //view.layer.cornerRadius = 30.0
    }
    
    
    @IBAction func evakClciked(_ sender: Any) {
        self.serviceType = 1
        performSegue(withIdentifier: "segueToYeniElan", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SegueToService")
        {
            let destVC = segue.destination as! ServiceViewController
            destVC.serviceType = self.serviceType
        }
        if(segue.identifier == "segueToOrderDetail"){
            let destVc = segue.destination as! OrderDetailController
            destVc.selectedOrder = self.selectedOrder
        }
        if(segue.identifier == "segueToOrderFilter")
        {
            
            let VC  = segue.destination as! FilterDriverController
            VC.findOrderFunction = self.findFromFilter
            VC.filterType = self.filterType
            VC.findDriverFunction = self.findDriverFromFilter
        }
        
        if(segue.identifier == "SegueToDriverInfo")
        {
            let VC  = segue.destination as! DriverInfoController
            VC.selectedOrder = self.selectedOrder
        }
        if(segue.identifier == "segueToYeniElan"){
            let VC  = segue.destination as! YeniElanController
            VC.elanType = self.elanType
            VC.showMessage = self.showMessage
        }
    }
    
    func getDrivers(currentPage: Int, fromCountry: String, fromRegion: String, toCountry: String, toRegion: String, startDate: String, endDate: String, carType: String){
        
        checkConnIndicator.isHidden = false
        checkConnButtonView.isHidden = true
        
        isLoading = true
        let timeLineUrl = "http://209.97.140.82/api/v1/driver/timeline"
        var urlComponent = URLComponents(string: timeLineUrl)
        
        urlComponent?.queryItems = [
            URLQueryItem(name: "page", value: "\(currentPage)"),
            URLQueryItem(name: "from_country_id", value: fromCountry),
            URLQueryItem(name: "from_region_id", value: fromRegion),
            URLQueryItem(name: "to_country_id", value: toCountry),
            URLQueryItem(name: "to_region_id", value: toRegion),
            URLQueryItem(name: "start_date", value: startDate),
            URLQueryItem(name: "end_date", value: endDate),
            URLQueryItem(name: "car_type", value: carType)
        ]
        
        var urlRequest = URLRequest(url: urlComponent!.url!)
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: urlRequest){(data, response, error) in
            if(error == nil){
                guard let data = data else {return}
                //   let output =   String(data: data, encoding: String.Encoding.utf8)
                // print("output: \(output)")
                
                do{
                    let jsonData = try JSONDecoder().decode(TimeLineFullData.self, from: data)
                    
                    self.nextPageUrl = jsonData.timeline?.next_page_url ?? nil
                    if(self.nextPageUrl != nil)
                    {
                        self.currentPage = self.currentPage + 1
                    }
                    let orderItems = (jsonData.timeline?.data)!
                    for i in 0..<orderItems.count{
                        self.orders.append(orderItems[i])
                    }
                    
                }
                    
                catch let jsonError{
                    self.view.makeToast("Json Error")
                    print(jsonError)
                }
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self.connView.isHidden = true
                    })
                    
                    self.driverCollectionView.reloadData()
                    
                }
            }
            else
            {
                
                
                if let error = error as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        
                        DispatchQueue.main.async {
                            if(self.orders.count == 0){
                                self.checkConnIndicator.isHidden = true
                                self.checkConnButtonView.isHidden = false
                            }
                            else
                            {
                                self.view.makeToast("İnternet bağlantısını yoxlayin")
                            }
                            
                        }
                        
                    }
                }
            }
            self.isLoading  = false
            
            
            }.resume()
        
        
    }
    
    func getOrders(currentPage: Int, fromCountry: String, fromRegion: String, toCountry: String, toRegion: String, startDate: String, endDate: String, cargoType: String){
        
        checkConnIndicator.isHidden = false
        checkConnButtonView.isHidden = true

        isLoading = true
        let timeLineUrl = "http://209.97.140.82/api/v1/order/timeline"
        var urlComponent = URLComponents(string: timeLineUrl)
        
        urlComponent?.queryItems = [
          URLQueryItem(name: "page", value: "\(currentPage)"),
          URLQueryItem(name: "from_country_id", value: fromCountry),
          URLQueryItem(name: "from_region_id", value: fromRegion),
          URLQueryItem(name: "to_country_id", value: toCountry),
          URLQueryItem(name: "to_region_id", value: toRegion),
          URLQueryItem(name: "start_date", value: startDate),
          URLQueryItem(name: "end_date", value: endDate),
          URLQueryItem(name: "order_category_id", value: cargoType)

        ]
        
        var urlRequest = URLRequest(url: urlComponent!.url!)
    
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: urlRequest){(data, response, error) in
           
            if(error == nil){
                guard let data = data else {return}
            //   let output =   String(data: data, encoding: String.Encoding.utf8)
               // print("output: \(output)")
               
                do{
                    let jsonData = try JSONDecoder().decode(TimeLineFullData.self, from: data)
             
                    self.nextPageUrl = jsonData.timeline?.next_page_url ?? nil
                    if(self.nextPageUrl != nil)
                    {
                        self.currentPage = self.currentPage + 1
                    }
                    let orderItems = (jsonData.timeline?.data)!
                    for i in 0..<orderItems.count{
                        self.orders.append(orderItems[i])
                    }
                    
                }
                    
                catch let jsonError{
                   self.view.makeToast("Json Error")
                   print(jsonError)
                }
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                       self.connView.isHidden = true
                    })
                
                    self.driverCollectionView.reloadData()
                    
                }
                
            }
            else
            {
                
                
                if let error = error as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        
                        DispatchQueue.main.async {
                            if(self.orders.count == 0){
                                self.checkConnIndicator.isHidden = true
                                self.checkConnButtonView.isHidden = false
                            }
                            else
                            {
                            self.view.makeToast("İnternet bağlantısını yoxlayin")
                            }
                            
                        }
                        
                    }
                }
            }
            
            self.isLoading  = false
            }.resume()
        
    }
    
    
    
    
    func findFromFilter(fromCountry: String, fromRegion: String, toCountry: String, toRegion: String, startDate: String, endDate: String, cargoType: String) -> (){
        selectedFromCountry = fromCountry
        selectedFromRegion = fromRegion
        selectedTocountry = toCountry
        selectedToRegion = toRegion
        selectedCargoType = cargoType
        self.startDate = startDate
        self.endDate = endDate
        addConnectionView()
        currentPage = 1
        orders = []
        driverCollectionView.reloadData()
            getOrders(currentPage: currentPage, fromCountry: fromCountry, fromRegion: fromRegion, toCountry: toCountry, toRegion: toRegion, startDate: startDate, endDate: endDate, cargoType: cargoType)
        
    }
    
    func findDriverFromFilter(fromCountry: String, fromRegion: String, toCountry: String, toRegion: String, startDate: String, endDate: String, carType: String) -> (){
        selectedFromCountry = fromCountry
        selectedFromRegion = fromRegion
        selectedTocountry = toCountry
        selectedToRegion = toRegion
        selectedCarType = carType
        self.startDate = startDate
        self.endDate = endDate
        addConnectionView()
        currentPage = 1
        orders = []
        driverCollectionView.reloadData()
        getDrivers(currentPage: currentPage, fromCountry: fromCountry, fromRegion: fromRegion, toCountry: toCountry, toRegion: toRegion, startDate: startDate, endDate: endDate, carType: carType)
        
    }
    
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            
            if(isLoading == false && nextPageUrl != nil){

                if(UserDefaults.standard.string(forKey: "USERROLE") == "3"){
                    print("currentpage \(currentPage)")
                    getOrders(currentPage: currentPage, fromCountry: selectedFromCountry, fromRegion: selectedFromRegion, toCountry: selectedTocountry, toRegion: selectedToRegion, startDate: startDate, endDate: endDate, cargoType: selectedCargoType)
                }
                else
                {
                    getDrivers(currentPage: currentPage, fromCountry: selectedFromCountry, fromRegion: selectedFromRegion, toCountry: selectedTocountry, toRegion: selectedToRegion, startDate: startDate, endDate: endDate, carType: selectedCarType)
                }
                
                
            }
        }
       
    }
    
    func showMessage() -> () {
        self.view.makeToast("Yeni elan əlavə edildi")
    }
    

    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
    }
    
}


extension UIView {
    func roundCornersWithBorder(corners: UIRectCorner, cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        maskLayer.borderWidth = 2
        maskLayer.borderColor = UIColor.gray.cgColor
        self.layer.mask = maskLayer
        
    }
    
}
