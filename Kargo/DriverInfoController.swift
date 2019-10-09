//
//  DriverInfoController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/8/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class DriverInfoController: UIViewController, UITableViewDelegate, UITableViewDataSource
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
    var paramaterNames = ["N/v-nin çəkisi(kq)", "N/v-nin tutumu(m3)"]
    var paramValues = [String]()
    var selectedOrder: TimeLineDataItem?
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    var foreignPassportUrl: String?
    var carRegisterUrl: String?
    var halfcarRegisterUrl: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addConnectionView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
           self.userImageView.roundCorners(corners: [.bottomRight], cornerRadius: 90.0)
             self.contactsView.roundCorners(corners: [.bottomRight], cornerRadius: 90.0)
            self.bottomView.roundCorners(corners: [.topRight], cornerRadius: 90.0)
             self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
            
        })
        setupDesign()
        createShadow2(view: tableParentView)
        getDriverDetail()

    }
    
    func setupDesign(){
        if(UIScreen.main.bounds.height < 580){
            nameLbl.font = nameLbl.font.withSize(18.0)
            userImageWidth.constant = 70.0
            userImageHeight.constant = 70.0
        }
        if(UIScreen.main.bounds.height > 730 && UIScreen.main.bounds.height < 800)
        {
            userImageWidth.constant = 100.0
            userImageHeight.constant = 100.0
        }
        if(UIScreen.main.bounds.height > 800)
        {
            userImageWidth.constant = 120.0
            userImageHeight.constant = 120.0
        }
        
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
    
    @objc func tryAgain(){
        
    }
    
    @objc func backClciked(){
        self.navigationController?.popViewController(animated: true)
    }

    func createShadow2(view: UIView){
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 30.0
        infoTableView.layer.cornerRadius = 30.0
    }
    
    func getDriverDetail(){
        
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        // tipler = []
        let driverDetailUrl = "http://209.97.140.82/api/v1/user/profile/\((selectedOrder?.owner?.id)!)"
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
                    
                    
                    if let carWeight = jsonData.data?.car_tonnage_kq{
                        self.paramValues.append("\(carWeight)")
                    }
                    if let carVolume = jsonData.data?.car_tonnage_m3{
                        self.paramValues.append("\(carVolume)")
                    }
                    self.foreignPassportUrl = jsonData.data?.foreign_passport
                    self.carRegisterUrl = jsonData.data?.car_register_doc
                    self.halfcarRegisterUrl = jsonData.data?.half_car_register_doc
                    
                    
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
        }
    }

    
    
   


}
