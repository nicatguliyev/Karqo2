//
//  MenuViewController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/6/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var darkView = UIView()
    @IBOutlet weak var menuHeaderView: UIView!
    @IBOutlet weak var headerWidth: NSLayoutConstraint!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    var selectedIndexPath: IndexPath?
    var menuNames = ["Sürücü tap", "Elanlarım", "Ödəniş", "Bildirişlərim", "Profilim", "Tənzimləmələr", "Çıxış"]
    var menuImages = ["searchIcon.png", "elanIcon.png", "transferIcon.png", "ringIcon.png", "profilIcon2.png", "settingIcon.png", "logoutIcon.png" ]
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    static var staticSelf: MenuViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuViewController.staticSelf = self
        selectedIndexPath = IndexPath(row: 0, section: 0)
        setupDesign()
        
        if let avatar = vars.user?.user?.avatar{
            let avatarUrl = URL(string: avatar)
            self.userImage.sd_setImage(with: avatarUrl)

        }
        phoneNumber.text = vars.user?.user?.phone?.components(separatedBy: ",")[0]
        userName.text = vars.user?.user?.name
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        darkView.addGestureRecognizer(revealViewController().tapGestureRecognizer())

        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        darkView.frame = self.revealViewController().frontViewController.view.bounds
        self.revealViewController().frontViewController.view.addSubview(darkView)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
    }
    
    func setupDesign(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.menuHeaderView.roundCorners(corners: [.bottomLeft], cornerRadius: 70)
            
            self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
          
        })
        
        if(UIScreen.main.bounds.height < 600){
            imageHeight.constant = 70
            imageWidth.constant = 70
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        darkView.removeFromSuperview()
        self.view.removeGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    self.revealViewController()?.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib: [MenuTableViewCell] = Bundle.main.loadNibNamed("MenuTableViewCell", owner: self, options: nil) as! [MenuTableViewCell]
        let cell = nib[0]
        cell.greenView.layer.cornerRadius = 20
       // cell.numberBtn.layer.cornerRadius = cell.numberBtn.frame.width / 2
        cell.menuNAmeLbl.text = menuNames[indexPath.row]
        cell.menuIcon.image = UIImage(named: menuImages[indexPath.row])
       
          //  cell.numberBtn.isHidden = true
        
        if(indexPath == selectedIndexPath){
            cell.greenView.backgroundColor =  UIColor(red: 0/255, green: 193/255, blue: 138/255, alpha: 1)
            cell.menuNAmeLbl.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    //        cell.numberBtn.titleLabel?.textColor = UIColor.white
            
            let image2 = UIImage(named: menuImages[indexPath.row])
            let img = image2?.overlayImage(color: UIColor.white)
            cell.menuIcon.image = img
        }
        else
        {
            cell.greenView.backgroundColor = UIColor.clear
            cell.menuNAmeLbl.textColor = UIColor(red: 68/255, green: 86/255, blue: 108/255, alpha: 1)
           // cell.numberBtn.titleLabel?.textColor = UIColor(red: 68/255, green: 86/255, blue: 108/255, alpha: 1)
            
            let image2 = UIImage(named: menuImages[indexPath.row])
            let img = image2?.overlayImage(color: UIColor(red: 164/255, green: 168/255, blue: 186/255, alpha: 1))
            cell.menuIcon.image = img
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView.cellForRow(at: IndexPath(row: 0, section: 0)) != nil)
        {
            let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MenuTableViewCell
            firstCell!.greenView.backgroundColor = UIColor.clear
            firstCell!.menuNAmeLbl.textColor = UIColor(red: 68/255, green: 86/255, blue: 108/255, alpha: 1)
            
            let image3 = UIImage(named: menuImages[0])
            let img3 = image3?.overlayImage(color: UIColor(red: 164/255, green: 168/255, blue: 186/255, alpha: 1))
            firstCell!.menuIcon.image = img3
        }
        
       
        
        if(indexPath.row != 6 ){
            let cell:MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
             selectedIndexPath = indexPath
             cell.greenView.backgroundColor = UIColor(red: 0/255, green: 193/255, blue: 138/255, alpha: 1)
            cell.menuNAmeLbl.textColor = UIColor.white
            let image2 = UIImage(named: menuImages[indexPath.row])
            let img = image2?.overlayImage(color: UIColor.white)
            cell.menuIcon.image = img
            
        }
        else
        {
            if(tableView.cellForRow(at: selectedIndexPath!) != nil){
                let cell:MenuTableViewCell = tableView.cellForRow(at: selectedIndexPath!) as! MenuTableViewCell
                cell.greenView.backgroundColor = UIColor(red: 0/255, green: 193/255, blue: 138/255, alpha: 1)
                cell.menuNAmeLbl.textColor = UIColor.white
                let image2 = UIImage(named: menuImages[selectedIndexPath!.row])
                let img = image2?.overlayImage(color: UIColor.white)
                cell.menuIcon.image = img
                tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
            }
            
            self.revealViewController()?.revealToggle(animated: true)
            self.revealViewController()?.performSegue(withIdentifier: "segueToExit", sender: self)
           
        }
        
        if(indexPath.row == 0){
            performSegue(withIdentifier: "segueToFind", sender: self)
        }
        else if(indexPath.row == 1){
            performSegue(withIdentifier: "segueToElan", sender: self)

        }
        else if(indexPath.row == 2){
            performSegue(withIdentifier: "segueToPay", sender: self)
        }
        else if(indexPath.row == 3){
            performSegue(withIdentifier: "segueToBildiris", sender: self)
        }
        else if(indexPath.row == 4){
            performSegue(withIdentifier: "segueToProfil", sender: self)
        }
        else if(indexPath.row == 5){
            performSegue(withIdentifier: "segueToSettings", sender: self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
      ///  print("Selected: \(tableView.indexPathForSelectedRow?.row)")
       // print("DeSelected: \(indexPath.row)")
        
        if(tableView.cellForRow(at: indexPath) != nil){

                let cell:MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
                
                cell.greenView.backgroundColor = UIColor.clear
                cell.menuNAmeLbl.textColor = UIColor(red: 68/255, green: 86/255, blue: 108/255, alpha: 1)
                
                let image2 = UIImage(named: menuImages[indexPath.row])
                let img = image2?.overlayImage(color: UIColor(red: 164/255, green: 168/255, blue: 186/255, alpha: 1))
                cell.menuIcon.image = img
                //print(indexPath.row)
            }
    
    }
    
    func changeProfileImage(x: String){
        let avatarUrl = URL(string: x)
            self.userImage.sd_setImage(with: avatarUrl)
    }
    func changePhoneNumber(x: String){
         self.phoneNumber.text = x
    }
    
    func changeName(x: String){
        self.userName.text = x
    }
    
}


extension UIImage {
    
    func overlayImage(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        color.setFill()
        
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
        
        context!.setBlendMode(CGBlendMode.colorBurn)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context!.draw(self.cgImage!, in: rect)
        
        context!.setBlendMode(CGBlendMode.sourceIn)
        context!.addRect(rect)
        context!.drawPath(using: CGPathDrawingMode.fill)
        
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return coloredImage
    }
    
}
