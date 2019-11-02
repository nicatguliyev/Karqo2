    //
    //  ElanController.swift
    //  Kargo
    //
    //  Created by Nicat Guliyev on 9/15/19.
    //  Copyright © 2019 Nicat Guliyev. All rights reserved.
    //

    import UIKit

    struct AddOrderSuccessModel: Decodable{
    let status: String?
    let data: OrderDataModel?
    let error: [String]?
    let avatar: String?
    }

    struct OrderDataModel:Decodable {
    let id: Int?
    let user_id: Int?
    let order_category_id: String?
    let from_country_id: String?
    let from_region_id: String?
    let from_city: String?
    let to_country_id: String?
    let to_region_id: String?
    let to_city: String?
    let start_date: String?
    let end_date: String?
    let cargo_tonnage_m3: String?
    let cargo_tonnage_kq: String?
    let size_x: String?
    let size_y: String?
    let size_z: String?
    let price: String?
    let price_valyuta: String?
    let coordinates_x: String?
    let coordinates_y: String?
    }
    
    struct deletedMessageModel: Decodable{
        let status: String?
        let data: String?
        let error: [String]?
    }

    class ElanController: UIViewController, SWRevealViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {



    @IBOutlet weak var bigActionBar: UIView!
    var menuBtn = UIButton()
    var menuBarItem = UIBarButtonItem()
    @IBOutlet weak var elanCollectionView: UICollectionView!
    @IBOutlet weak var advCollectionView: UICollectionView!

    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    var advs = [TimeLineDataItem]()
    var questionView = QuestionView()
    var clcikedRemoveBtn = UIButton()
    var questionIndicator = UIActivityIndicatorView()
    var selectedAdvId: Int?
        var selectedAdv: TimeLineDataItem?
        
    override func viewDidLoad() {
        super.viewDidLoad()
     //  print(vars.user?.data?.token)
        setUpMenuButton()
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
        })
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.revealViewController()?.delegate = self
        
         elanCollectionView.register(UINib(nibName: "FindOrderCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell2")
        
        addConnectionView()
        if(UserDefaults.standard.string(forKey: "USERROLE")! == "4"){
            getDriverAdvs(type: 1)
        }
        else
        {
            getDriverAdvs(type: 2)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
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


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return advs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! FindOrderCollectionCell
        createShadow(view: cell.mainView)
        createShadow2(view: cell.nameView)
        cell.nameView.layer.cornerRadius = 10
        cell.nameView.isHidden = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            cell.priceView.roundCorners(corners: [.bottomRight, .topLeft], cornerRadius: 50.0)
            self.createShadow2(view: cell.priceView)
        })
        
        cell.removeBtn.tag = self.advs[indexPath.row].id!
        cell.removeBtn.addTarget(self, action: #selector(deleteAdvFromList), for: .touchUpInside)
        
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editAdv), for: .touchUpInside)
        
        if(UserDefaults.standard.string(forKey: "USERROLE")! == "4"){
            cell.tipLbl.text = "Yükün növü"
            
            cell.personNameLbl.text = advs[indexPath.row].owner?.name
            let fromCountryName = advs[indexPath.row].from_country?.name
            let fromRegionName = advs[indexPath.row].from_region?.name
            let fromCityName = advs[indexPath.row].from_city
            
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
            
            
            let toCountryName = advs[indexPath.row].to_country?.name
            let toRegionName = advs[indexPath.row].to_region?.name
            let toCityName = advs[indexPath.row].to_city
            
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
            
            let startDate = advs[indexPath.row].start_date
            let endDate = advs[indexPath.row].end_date
            
            if(startDate != nil && endDate != nil){
                cell.dateLbl.text = startDate! + " / " + endDate!
            }
            
            if let price = advs[indexPath.row].price, let valyuta = advs[indexPath.row].valyuta?.code{
                cell.priceLbl.text = price + " " + valyuta
            }
            else
            {
                cell.priceLbl.text = "null"
            }
            cell.typeLbl.text = advs[indexPath.row].category?.name
        }
        else{
            cell.tipLbl.text = "Nəqliyyat vasitəsinin tipi"
            cell.personNameLbl.text = advs[indexPath.row].owner?.name
            let fromCountryName = advs[indexPath.row].from_country?.name
            let fromRegionName = advs[indexPath.row].from_region?.name
            let fromCityName = advs[indexPath.row].from_city
            
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
            
            
            let toCountryName = advs[indexPath.row].to_country?.name
            let toRegionName = advs[indexPath.row].to_region?.name
            let toCityName = advs[indexPath.row].to_city
            
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
            
            let startDate = advs[indexPath.row].start_date
            let endDate = advs[indexPath.row].end_date
            
            if(startDate != nil && endDate != nil){
                cell.dateLbl.text = startDate! + " / " + endDate!
            }
            
            if let price = advs[indexPath.row].price, let valyuta = advs[indexPath.row].valyuta?.code{
                cell.priceLbl.text = price + " " + valyuta
            }
            else
            {
                cell.priceLbl.text = "null"
            }
            cell.typeLbl.text = advs[indexPath.row].car_type?.name
        }
        
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.width - 32) , height: 348)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 22, left: 0, bottom: 40, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 40.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           // performSegue(withIdentifier: "segueToEditElan", sender: self)
        }

    @objc func deleteAdvFromList(sender: UIButton){
        selectedAdvId = sender.tag
        clcikedRemoveBtn = sender
        addQuestionView()
        
    }
        
        @objc func editAdv(sender: UIButton){
            //selectedAdvId = sender.tag
            self.selectedAdv = self.advs[sender.tag]
            performSegue(withIdentifier: "segueToEditElan", sender: self)
            
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

    func addConnectionView(){
        if let connectionView = Bundle.main.loadNibNamed("CheckConnectionView", owner: self, options: nil)?.first as? CheckConnectionView {
            connectionView.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 80)
            self.view.addSubview(connectionView);
            connectionView.buttonView.clipsToBounds = true
            
            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.checkIndicator

        }
    }


    func addQuestionView(){
         if let questionView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as? QuestionView {
            
            self.questionView = questionView
            self.questionIndicator = questionView.indicator
            questionView.yesBTN.layer.cornerRadius = 15.0
            questionView.cancelBtn.layer.cornerRadius = 15.0
            
            
            
            questionView.cancelBtn.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
            questionView.yesBTN.addTarget(self, action: #selector(yesClicked), for: .touchUpInside)

            DispatchQueue.main.asyncAfter(wallDeadline: .now()+0.001, execute: {
                questionView.deleteView.roundCorners(corners: [.topRight, .bottomLeft], cornerRadius: 90.0)
            })
          
          //  let currentWindow: UIWindow? = UIApplication.shared.keyWindow
            questionView.frame = UIApplication.shared.keyWindow!.frame
            UIApplication.shared.keyWindow?.addSubview(questionView)
            
            
            
        }
    }

    @objc func cancelClicked(){
        self.questionView.removeFromSuperview()
    }

    @objc func yesClicked(){
        self.deleteAdv(advId: selectedAdvId!)
    
    }
        

        func deleteAdv(advId: Int){
            
            self.questionView.indicator.isHidden = false
            self.questionView.deleteView.isHidden = true
            
            var deleteUrl = ""
            
            if(UserDefaults.standard.string(forKey: "USERROLE")! == "4"){
                deleteUrl = "http://209.97.140.82/api/v1/order/delete"
            }
            else
            {
                deleteUrl = "http://209.97.140.82/api/v1/driver/delete"
            }
            
            
            guard let url = URL(string: deleteUrl) else {return}
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            
            urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let parameters: [String: Any] = [
                "id": "\(advId)"
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
                    
                    let outputStr  = String(data: data, encoding: String.Encoding.utf8)
                    print(outputStr!)
                    do{
                        let jsonData = try JSONDecoder().decode(deletedMessageModel.self, from: data)
                        print("DeleteAdv: \(jsonData)")
                        if(jsonData.status == "success"){
                            DispatchQueue.main.async {
                                self.view.makeToast("Elan silindi.")
                                let deletionCell = self.clcikedRemoveBtn.superview?.superview as! UICollectionViewCell
                                let deletionIndexPath = self.advCollectionView.indexPath(for: deletionCell)!
                                self.advs.remove(at: deletionIndexPath.row)
                                self.advCollectionView.deleteItems(at: [deletionIndexPath])
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.view.makeToast("Elan silinmədi. Xəta baş verdi")
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
                                self.view.makeToast("Elan silinmədi: İnternet bağlantısını yoxlayın")
                            }
                            
                        }
                    }
                }
                
                
                }.resume()
            
        }

    func getDriverAdvs(type: Int){
        var carUrl = ""
        if(type == 1)
        {
            carUrl = "http://209.97.140.82/api/v1/order/all"
        }
        else
        {
            carUrl = "http://209.97.140.82/api/v1/driver/all"
        }
        
        guard let url = URL(string: carUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            guard let data = data else {return}
           // let output =   String(data: data, encoding: String.Encoding.utf8)
           // print("output: \(output)")
            
            
            
            if(error == nil){
                //guard let data = data else {return}
                
                DispatchQueue.main.async {
                    self.connView.isHidden = true
                    self.advCollectionView.reloadData()
                }
                
                do{
                    let jsonData = try JSONDecoder().decode(TimeLine.self, from: data)
                    print(jsonData)
                    if(jsonData.data != nil){
                       self.advs = jsonData.data!
                      // DispatchQueue
                    }
                    
                    DispatchQueue.main.async {
                        self.advCollectionView.reloadData()
                    }
                }
                    
                catch let jsonError{
                    DispatchQueue.main.async {
                        print(jsonError)
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
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if(segue.identifier == "segueToEditElan"){
                let VC = segue.destination as! EditElanController
                VC.selectedAdv = self.selectedAdv
            }
        }


    }
