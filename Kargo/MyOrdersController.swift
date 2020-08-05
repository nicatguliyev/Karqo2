//
//  MyOrdersController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 11/4/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class MyOrdersController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var menuBtn = UIButton()
    var menuBarItem = UIBarButtonItem()
    var navBarColor = UIColor()
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var myOrderCollectionView: UICollectionView!
    var orders = [TimeLineDataItem]()
    var selectedOrder: TimeLineDataItem?
    @IBOutlet weak var basliqLbl: UILabel!
    
    var selectedLang: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLang = UserDefaults.standard.string(forKey: "Lang")
        basliqLbl.text = "my_orders".addLocalizableString(str: selectedLang!)
        
        myOrderCollectionView.delegate  = self
        myOrderCollectionView.dataSource = self
        
        addConnectionView()
        setUpMenuButton()
        setUpNavigationBar()
        myOrderCollectionView.register(UINib(nibName: "FindOrderCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell2")
        
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight, .topRight], cornerRadius: 90.0)
        })
        
        getDriverAdvs()
        
        
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
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! FindOrderCollectionCell
        
        cell.tipLbl.text = "Yükün növü"
        
        createShadow(view: cell.mainView)
        createShadow2(view: cell.nameView)
        cell.removeBtn.isHidden = true
        cell.editBtn.isHidden = true
        cell.nameView.layer.cornerRadius = 10
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            cell.priceView.roundCorners(corners: [.bottomRight, .topLeft], cornerRadius: 50.0)
        })
        
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
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.width - 32) , height: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 22, left: 0, bottom: 40, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedOrder = orders[indexPath.row]
        performSegue(withIdentifier: "segueToSifarisDetail", sender: self)
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
    
    func getDriverAdvs(){
        let ordersUrl = "http://carryup.az/api/v1/driver/orders"
        
        guard let url = URL(string: ordersUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            guard let data = data else {return}
            //let output =   String(data: data, encoding: String.Encoding.utf8)
            //print("output: \(output)")
            
            if(error == nil){
                //guard let data = data else {return}
                
                do{
                    let jsonData = try JSONDecoder().decode(TimeLine.self, from: data)
                    if(jsonData.data != nil){
                        self.orders = jsonData.data!
                        // DispatchQueue
                    }
                    
                }
                    
                catch _{
                    
                    DispatchQueue.main.async {
                        self.view.makeToast("Xəta baş verdi")
                    }
                }
                
                
                DispatchQueue.main.async {
                    self.connView.isHidden = true
                    self.myOrderCollectionView.reloadData()
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
        if(segue.identifier == "segueToSifarisDetail"){
            let VC = segue.destination as! OrderDetailController
            VC.selectedOrder = self.selectedOrder
        }
    }
    
    
    
}
