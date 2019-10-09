//
//  BildirisViewController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/16/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class BildirisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SWRevealViewControllerDelegate {

    var menuBtn = UIButton()
    var menuBarItem = UIBarButtonItem()
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var bildirisTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMenuButton()
        //setUpDesign()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
        })
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let nib = UINib.init(nibName: "CustomBildirisCell", bundle: nil)
        self.bildirisTable.register(nib, forCellReuseIdentifier: "MyCustomCell")
        self.revealViewController()?.delegate = self

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
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let nib: [CustomBildirisCell] = Bundle.main.loadNibNamed("CustomBildirisCell", owner: self, options: nil) as! [CustomBildirisCell]
        let cell = nib[0]
        
        cell.layer.zPosition=CGFloat(20-indexPath.row)
        
        cell.backView.layer.cornerRadius = 60
        cell.backView.layer.borderWidth = 1
        cell.backView.layer.borderColor = UIColor(red: 164/255, green: 168/255, blue: 186/255, alpha: 1).cgColor
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 0..<20 {
            let indexpath = IndexPath(row: i, section: 0)
            if(bildirisTable.cellForRow(at: indexpath) != nil){
            let cell:CustomBildirisCell = bildirisTable.cellForRow(at: indexpath) as! CustomBildirisCell
            cell.backView.backgroundColor = UIColor.clear
            }
        }
        
    }
    
    func revealControllerPanGestureBegan(_ revealController: SWRevealViewController!) {
        print("Basladi")
        for i in 0..<20 {
            let indexpath = IndexPath(row: i, section: 0)
            if(bildirisTable.cellForRow(at: indexpath) != nil){
                let cell:CustomBildirisCell = bildirisTable.cellForRow(at: indexpath) as! CustomBildirisCell
                cell.backView.backgroundColor = UIColor.clear
            }
        }
    }

    
    
}
