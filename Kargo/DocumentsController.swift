//
//  DocumentsController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 9/15/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class DocumentsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var editIcon: UIButton!
    
    var foreignPassportUrl: String?
    var carRegisterDoc: String?
    var halfCarRegisterUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.userImage.sd_setImage(with: avatarUrl)

        editIcon.layer.cornerRadius = 27
        setUpBackButton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
        })
        
        
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "documentCellId", for: indexPath) as! DocumentCollectionCell
        cell.docImage.layer.cornerRadius = 10
        cell.contentView.layer.cornerRadius = 10
        
        if(indexPath.row == 0){
             cell.docNameLbl.text = "Xarici passport"
            if let foreignPassportUrl = foreignPassportUrl
            {
                cell.docImage.sd_setImage(with: URL(string: foreignPassportUrl))
            }
        }
        else if(indexPath.row == 1){
            cell.docNameLbl.text = "Nəq.vasitəsinin qeydiyyat şəhadətnaməsi"
            if let carRegisterDoc = carRegisterDoc
            {
                cell.docImage.sd_setImage(with: URL(string: carRegisterDoc))
            }
        }
        else{
             cell.docNameLbl.text = "Yarımqoşqunun qeydiyyat şəhadətnaməsi"
            if let halfCarRegisterUrl = halfCarRegisterUrl
            {
                cell.docImage.sd_setImage(with: URL(string: halfCarRegisterUrl))
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.width - 32) , height: 300)
    }
    
}
