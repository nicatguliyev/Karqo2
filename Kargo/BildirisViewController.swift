//
//  BildirisViewController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/16/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

struct BildirisList: Decodable {
    let list: BildirisTimeLine?
}

struct BildirisTimeLine: Decodable {
    let current_page: Int?
    let data: [BildirisDataItem]
    let last_page: Int?
    let next_page_url: String?
    
}


struct BildirisDataItem: Decodable {
    let sender_id: Int?
    let title: String?
    let created_at: String?
    let sender: UserModel?
    
}




class BildirisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SWRevealViewControllerDelegate {

    var menuBtn = UIButton()
    var menuBarItem = UIBarButtonItem()
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var bildirisTable: UITableView!
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    var bildirisler = [BildirisDataItem]()
    var currentPage = 1
    var isLoading = false
    var nextPageUrl: String?
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    var driverId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        setUpMenuButton()
        
    
        addConnectionView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
        })
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let nib = UINib.init(nibName: "CustomBildirisCell", bundle: nil)
        self.bildirisTable.register(nib, forCellReuseIdentifier: "MyCustomCell")
        self.revealViewController()?.delegate = self
        
        getNotifications(page: currentPage)

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
    
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
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
    
    @objc func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpDesign(){
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
        })
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    @objc func handleGesture(){
        print("Swipe")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bildirisler.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let nib: [CustomBildirisCell] = Bundle.main.loadNibNamed("CustomBildirisCell", owner: self, options: nil) as! [CustomBildirisCell]
        let cell = nib[0]
        
        cell.bildirisImg.sd_setImage(with: URL(string: (bildirisler[indexPath.row].sender?.avatar)!))
        cell.bildirisLbl.text = bildirisler[indexPath.row].title
        cell.dateLbl.text = bildirisler[indexPath.row].created_at
        
        cell.layer.zPosition=CGFloat(bildirisler.count-indexPath.row)
        
        cell.backView.layer.cornerRadius = 60
        cell.backView.layer.borderWidth = 1
        cell.backView.layer.borderColor = UIColor(red: 164/255, green: 168/255, blue: 186/255, alpha: 1).cgColor
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(UserDefaults.standard.string(forKey: "USERROLE") == "4"){
            self.driverId = bildirisler[indexPath.row].sender_id!
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                self.performSegue(withIdentifier: "segueToBildirisDetail", sender: self)
            })
                
        }
      
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 0..<bildirisler.count {
            let indexpath = IndexPath(row: i, section: 0)
            if(bildirisTable.cellForRow(at: indexpath) != nil){
            let cell:CustomBildirisCell = bildirisTable.cellForRow(at: indexpath) as! CustomBildirisCell
            cell.backView.backgroundColor = UIColor.clear
            }
        }
        
                let  height = scrollView.frame.size.height
                let contentYoffset = scrollView.contentOffset.y
                let distanceFromBottom = scrollView.contentSize.height - contentYoffset
                if distanceFromBottom < height {
                    
                    if(isLoading == false && nextPageUrl != nil){
                    getNotifications(page: currentPage)
                    
                }
               
            }
    }
    
    func revealControllerPanGestureBegan(_ revealController: SWRevealViewController!) {
        for i in 0..<20 {
            let indexpath = IndexPath(row: i, section: 0)
            if(bildirisTable.cellForRow(at: indexpath) != nil){
                let cell:CustomBildirisCell = bildirisTable.cellForRow(at: indexpath) as! CustomBildirisCell
                cell.backView.backgroundColor = UIColor.clear
            }
        }
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
          getNotifications(page: currentPage)
      }
    
    
    func getNotifications(page: Int){
           isLoading = true
           
          // tipler = []
        
        if(bildirisler.count == 0){
            self.connView.isHidden = false
            self.checkConnButtonView.isHidden = true
            self.checkConnIndicator.isHidden = false
        }
           let carUrl = "http://209.97.140.82/api/v1/user/notifications?page=" + "\(page)"
           guard let url = URL(string: carUrl) else {return}
           
           var urlRequest = URLRequest(url: url)
        
           print((UserDefaults.standard.string(forKey: "USERTOKEN"))!)
           
           urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
           urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
           
           URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
               
               if(error == nil){
                   guard let data = data else {return}
                   do{
                       let jsonData = try JSONDecoder().decode(BildirisList.self, from: data)
                    self.nextPageUrl = jsonData.list!.next_page_url ?? nil
                   // self.driverId = jsonData.list?.data[]
                    if(self.nextPageUrl != nil)
                    {
                        self.currentPage = self.currentPage + 1
                    }
                    for i in 0..<jsonData.list!.data.count{
                        self.bildirisler.append(jsonData.list!.data[i])
                    }
                       DispatchQueue.main.async {
                        //print("Bildirilser: \(self.bildirisler)")
                        self.connView.isHidden = true
                        self.bildirisTable.reloadData()
                       }
                       
                   }
                       
                   catch let jsonError{
                       DispatchQueue.main.async {
                           print(jsonError)
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
                            if(self.bildirisler.count == 0){
                                self.connView.isHidden = false
                                self.checkConnButtonView.isHidden = false
                                self.checkConnIndicator.isHidden = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToBildirisDetail"){
            let VC = segue.destination as! DriverInfoController
            VC.driverId = self.driverId
        }
    }
    
}
