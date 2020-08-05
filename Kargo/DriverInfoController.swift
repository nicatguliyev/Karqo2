//
//  DriverInfoController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/8/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class DriverInfoController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate
{

    @IBOutlet weak var userImageView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var contactsView: UIView!
    @IBOutlet weak var userImageHeight: NSLayoutConstraint!
    @IBOutlet weak var userImageWidth: NSLayoutConstraint!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var tableParentView: UIView!
    @IBOutlet weak var whatsAppView: CustomView!
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    var paramaterNames = [String]()
    var paramValues = [String]()
    var selectedOrder: TimeLineDataItem?
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    var foreignPassportUrl: String?
    var carRegisterUrl: String?
    var halfcarRegisterUrl: String?
    @IBOutlet weak var whatsappView: CustomView!
    @IBOutlet weak var phoneView: CustomView!
    @IBOutlet weak var messageView: CustomView!
    var phoneNumbers: String?
    var actionType = 0
    @IBOutlet weak var myAdvCollectionView: UICollectionView!
    @IBOutlet weak var muyAdvCollectionHeight: NSLayoutConstraint!
    var driverId = Int()
    var acceptedCell: BildirisDetailCollectionCell?
    var questionView = QuestionView()
    var selectedLanguage: String?
    @IBOutlet weak var lookDocumentsLbl: UILabel!
    
    
    @IBOutlet weak var distanceBetwenTableAndBottom: NSLayoutConstraint!
    var requestedOrders = [OrderDataModel2]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLanguage = UserDefaults.standard.string(forKey: "Lang")
        paramaterNames = [
            "brend".addLocalizableString(str: selectedLanguage!),
            "model".addLocalizableString(str: selectedLanguage!),
            "type_of_transport".addLocalizableString(str: selectedLanguage!),
            "capacity_m3".addLocalizableString(str: selectedLanguage!),
            "capacity_kg".addLocalizableString(str: selectedLanguage!)
        ]
        lookDocumentsLbl.text = "look_documents".addLocalizableString(str: selectedLanguage!)
        
        addConnectionView()
        print(driverId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
           self.userImageView.roundCorners(corners: [.bottomRight], cornerRadius: 90.0)
             self.contactsView.roundCorners(corners: [.bottomRight], cornerRadius: 90.0)
            self.bottomView.roundCorners(corners: [.topRight], cornerRadius: 90.0)
             self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
            
        })
        setupDesign()
        createShadow2(view: tableParentView)
        getDriverDetail()
        
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
        
               myAdvCollectionView.register(UINib(nibName: "BildirisDetailCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell3")
        
    }
    
    @objc func messageTapped(){
        actionType = 3
        if(self.phoneNumbers != nil){
            let numbers = phoneNumbers!.components(separatedBy: ",")
            if(numbers.count > 1){
                performSegue(withIdentifier: "segueToPhoneNumbers", sender: self)
            }
            else{
                  UIApplication.shared.open(URL(string: "sms:" + numbers[0])!, options: [:], completionHandler: nil)
            }
            
        }
        
    }
    
    @objc func phoneTapped(){
        actionType = 2
        if(self.phoneNumbers != nil){
            let numbers = phoneNumbers!.components(separatedBy: ",")
            if(numbers.count > 1){
                performSegue(withIdentifier: "segueToPhoneNumbers", sender: self)
            }
            else{
                UIApplication.shared.open(URL(string: "tel:" + numbers[0])!, options: [:], completionHandler: nil)
            }
            
        }
        
    }
    
    @objc func whatsappTapped(){
        actionType = 1
        if(self.phoneNumbers != nil){
            let numbers = phoneNumbers!.components(separatedBy: ",")
            UIApplication.shared.open(URL(string: "https://api.whatsapp.com/send?phone=" + numbers[0])!, options: [:], completionHandler: nil)

            
        }
        
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
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(bottomViewClicked))
        tapgesture.cancelsTouchesInView = false
        bottomView.addGestureRecognizer(tapgesture)
        bottomView.isUserInteractionEnabled = true
        
        nameLbl.text = selectedOrder?.owner?.name
        
        setUpBackButton()
    }
    
    @objc func bottomViewClicked(){
        performSegue(withIdentifier: "segueToDocuments", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paramaterNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib: [InfoTableViewCell] = Bundle.main.loadNibNamed("InfoTableViewCell", owner: self, options: nil) as! [InfoTableViewCell]
        let cell = nib[0]
        
        cell.paramNameLbl.text = paramaterNames[indexPath.row] 
        if(paramaterNames.count == paramValues.count){
            cell.paramValLbl.text = paramValues[indexPath.row]
        }
        
        
        return cell
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
    
    func addQuestionView(){
         if let questionView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as? QuestionView {
            
            self.questionView = questionView
          //  self.questionIndicator = questionView.indicator
            questionView.yesBTN.layer.cornerRadius = 15.0
            questionView.cancelBtn.layer.cornerRadius = 15.0
            self.questionView.deleteView.isHidden = true
            self.questionView.indicator.isHidden = false
          
          //  let currentWindow: UIWindow? = UIApplication.shared.keyWindow
            questionView.frame = UIApplication.shared.keyWindow!.frame
            UIApplication.shared.keyWindow?.addSubview(questionView)
            
            
            
        }
    }
    
    @objc func tryAgain(){
        
    }
    
    @objc func backClciked(){
        vars.isNotf = false
        self.navigationController?.popViewController(animated: true)
    }

    func createShadow2(view: UIView){
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 15.0
        infoTableView.layer.cornerRadius = 15
    }
    
    func getDriverDetail(){
        
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        // tipler = []
        var driverDetailUrl = ""
        if(vars.isNotf == true){
            driverDetailUrl = "http://carryup.az/api/v1/user/profile/\((vars.notfsenderId!))"
        }
        else
        {
            if(selectedOrder != nil){
                driverDetailUrl = "http://carryup.az/api/v1/user/profile/\((selectedOrder?.owner?.id)!)"
            }
            else{
                driverDetailUrl =    "http://carryup.az/api/v1/user/profile/\((driverId))"
            }
            
        }
        
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
              //    print("output: \(output)")
                
                do{
                    let jsonData = try JSONDecoder().decode(UserDetailModel.self, from: data)
                    let avatar = jsonData.data?.avatar
                    if(vars.isNotf == true || self.selectedOrder == nil){
                        self.requestedOrders = jsonData.requested_orders ?? []
                    }
                    
                    if let avatar = avatar{
                        let avatarUrl = URL(string: avatar)
                        DispatchQueue.main.async {
                            self.userImage.sd_setImage(with: avatarUrl)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.nameLbl.text = jsonData.data?.name
                        if(vars.isNotf == true || self.selectedOrder == nil){
                            self.myAdvCollectionView.reloadData()
                            let x = (self.requestedOrders.count * 332)
                            let y = (self.requestedOrders.count - 1) * 12
                            self.muyAdvCollectionHeight.constant = CGFloat(x + y)
                        }
                    }
                    if let carMarka = jsonData.data?.car_brand?.code{
                        self.paramValues.append(carMarka)
                    }
                    
                    if let carModel = jsonData.data?.car_model?.code{
                        self.paramValues.append(carModel)
                    }
                    
                    if let carType = jsonData.data?.car_type?.name{
                        self.paramValues.append(carType)
                    }
                    
                    if let carWeight = jsonData.data?.car_tonnage_kq{
                        self.paramValues.append("\(carWeight)")
                    }
                    if let carVolume = jsonData.data?.car_tonnage_m3{
                        self.paramValues.append("\(carVolume)")
                    }
                    
                    self.driverId = (jsonData.data?.id)!
                    
                    self.foreignPassportUrl = jsonData.data?.foreign_passport
                    self.carRegisterUrl = jsonData.data?.car_register_doc
                    self.halfcarRegisterUrl = jsonData.data?.half_car_register_doc
                    self.phoneNumbers = jsonData.data?.phone
                    
                    
                }
                    
                catch let jsonError{
                    print("JsonError: \(jsonError)")
                    self.view.makeToast("Json Error")
                }
                
                DispatchQueue.main.async {
                    self.connView.isHidden = true
                    self.infoTableView.reloadData()
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToDocuments")
        {
            let VC  = segue.destination as! DocumentsController
            VC.foreignPassportUrl = self.foreignPassportUrl
            VC.carRegisterDoc = self.carRegisterUrl
            VC.halfCarRegisterUrl = self.halfcarRegisterUrl
            VC.type = 1
        }
        if(segue.identifier == "segueToPhoneNumbers"){
            let VC = segue.destination as! PhoneViewController
            VC.phoneNumbers = self.phoneNumbers ?? ""
            VC.actionType = self.actionType
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requestedOrders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! BildirisDetailCollectionCell
        
        cell.confirmBtn.tag = requestedOrders[indexPath.row].id!
        cell.confirmBtn.superview?.tag = indexPath.row
        cell.confirmBtn.addTarget(self, action: #selector(confirmRequest), for: .touchUpInside)
                  
        var fromText = requestedOrders[indexPath.row].from_country?.name
        if(requestedOrders[indexPath.row].from_region != nil){
            fromText = (fromText ?? "") + "/" + (requestedOrders[indexPath.row].from_region?.name ?? "")
        }
        if(requestedOrders[indexPath.row].from_city != nil){
            fromText = (fromText ?? "") + "/" + (requestedOrders[indexPath.row].from_city ?? "")
        }
        cell.fromCountryLbl.text = fromText
        
        
        var toText = requestedOrders[indexPath.row].to_country?.name
        if(requestedOrders[indexPath.row].to_region != nil){
            toText = (toText ?? "") + "/" + (requestedOrders[indexPath.row].to_region?.name ?? "")
        }
        if(requestedOrders[indexPath.row].to_city != nil){
            toText = (toText ?? "") + "/" + (requestedOrders[indexPath.row].to_city ?? "")
        }
        cell.toCountryLbl.text = toText
        
        
        if(requestedOrders[indexPath.row].start_date != nil && requestedOrders[indexPath.row].end_date != nil &&
            requestedOrders[indexPath.row].start_date != "" && requestedOrders[indexPath.row].end_date != ""){
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDate = dateFormatter.date(from: requestedOrders[indexPath.row].start_date!)
            let endDate = dateFormatter.date(from: requestedOrders[indexPath.row].end_date!)
            
            dateFormatter.dateFormat = "d MMM yyyy"
            dateFormatter.locale = Locale.init(identifier: "az")
            let goodDate = dateFormatter.string(from: startDate!) + " - " + dateFormatter.string(from: endDate!)
            cell.dateLbl.text = goodDate
            
        }
        
        if(requestedOrders[indexPath.row].category != nil){
            cell.typeLbl.text = requestedOrders[indexPath.row].category?.name!
        }
        
        if(requestedOrders[indexPath.row].price != "" && requestedOrders[indexPath.row].price != nil &&
            requestedOrders[indexPath.row].valyuta != nil){
            cell.priceLbl.text = requestedOrders[indexPath.row].price! + " " + (requestedOrders[indexPath.row].valyuta?.code)!
        }
    
    
        createShadow2(view: cell.mainView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            cell.priceView.roundCorners(corners: [.bottomRight, .topLeft], cornerRadius: 50.0)
            cell.confirmBtn.roundCorners(corners: [.bottomRight, .topLeft], cornerRadius: 50.0)
            //  self.createShadow2(view: cell.priceView)
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (self.view.frame.width) , height: 332)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 22, left: 0, bottom: 22, right: 0)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 16
//    }
//    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    
    @objc func confirmRequest(sender: UIButton){
        
               //  self.questionView.indicator.isHidden = false
               //  self.questionView.deleteView.isHidden = true
                 addQuestionView()
                 
                 let confirmUrl = "http://carryup.az/api/v1/user/request/confirm"
                 
                 guard let url = URL(string: confirmUrl) else {return}
                 
                 var urlRequest = URLRequest(url: url)
                 urlRequest.httpMethod = "POST"
                 
                 urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
                 urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                 
                 let parameters: [String: Any] = [
                    "order_id": "\(sender.tag)",
                    "user_id": "\(self.driverId)"
                 ]
                 
                 
                 urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
                 
                 let sessionConfig = URLSessionConfiguration.default
                 sessionConfig.timeoutIntervalForRequest = 4.0
                 sessionConfig.timeoutIntervalForResource = 60.0
                 let session = URLSession(configuration: sessionConfig)
                 
                 session.dataTask(with: urlRequest){(data, response, error) in
                     
                     DispatchQueue.main.async {
                        self.questionView.removeFromSuperview()
                     }
                     
                     if(error == nil){
                         guard let data = data else {return}
                         
                         //let outputStr  = String(data: data, encoding: String.Encoding.utf8)
                        // print(outputStr!)
                         do{
                             let jsonData = try JSONDecoder().decode(SendRequestModel.self, from: data)
                             if(jsonData.status == "success"){
                                 DispatchQueue.main.async {
                                     self.view.makeToast("Müraciəti təsdiqlədiniz")
                                    let deletingCell = sender.superview?.superview as! BildirisDetailCollectionCell
                                     let deletionIndexPath = self.myAdvCollectionView.indexPath(for: deletingCell)!
                                    self.requestedOrders.remove(at: deletionIndexPath.row)
                                    self.myAdvCollectionView.deleteItems(at: [deletionIndexPath])
                                    let x = (self.requestedOrders.count * 332)
                                    let y = (self.requestedOrders.count - 1) * 12
                                    self.muyAdvCollectionHeight.constant = CGFloat(x + y)
                                 }
                             }
                             else
                             {
                                 DispatchQueue.main.async {
                                     self.view.makeToast("Xəta: Müraciət təsdiq edilmədi")
                                 }
                             }
                         }
                             
                         catch let jsonError{
                             DispatchQueue.main.async {
                                 print(jsonError)
                                 self.view.makeToast("Xəta: Json error")
                             }
                         }
                     }
                     else
                     {
                         
                         if let error = error as NSError?
                         {
                             
                             if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                                 DispatchQueue.main.async {
                                     self.view.makeToast("Xəta: İnternet bağlantısını yoxlayın")
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
    
    

    
   func createShadow(view: UIView){
       
       view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
       view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
       view.layer.shadowOpacity = 0.1
       view.layer.shadowRadius = 1
       view.layer.masksToBounds = false
       view.layer.cornerRadius = 15.0
   }
   
   
}
