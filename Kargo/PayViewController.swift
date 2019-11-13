//
//  PayViewController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/12/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import AnyFormatKit


struct PriceDataModel: Decodable {
    let data: [PriceModel]?
}

struct PriceModel: Decodable {
    let id: Int?
    let month_count: Int?
    let display_name: String?
    let amount_azn: Float?
    let amount: Float?
    let valyuta_id: Int?
    let valyuta: TimeLineItemValyuta?
    
}

class PayViewController: UIViewController, UITextFieldDelegate, SWRevealViewControllerDelegate, UITableViewDelegate, UITableViewDataSource , UIPickerViewDelegate, UIPickerViewDataSource {
 
    var menuBtn = UIButton()
    var menuBarItem = UIBarButtonItem()
    @IBOutlet weak var bigActionBar: UIView!
   // @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var priceTable: UITableView!
    var selectedPriceIndex = 0
    var selectedValyutaIndex = 0
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    var valyutas = [TimeLineItemValyuta]()
    @IBOutlet weak var valyutaTextField: UITextField!
    var picker = UIPickerView()
    @IBOutlet weak var valyutaView: CustomSelectButton!
    @IBOutlet weak var valyutaLbl: UILabel!
    var prices = [PriceModel]()
    var tryAgaintype = 1
    @IBOutlet weak var bottomView: SenedeBaxButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMenuButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
            self.bottomView.roundCorners(corners: [.topRight], cornerRadius: 70.0)
        })          
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.revealViewController()?.delegate = self
        picker.delegate = self
        picker.dataSource = self
        
        valyutaTextField.inputView = picker
        
        let valyutaGesture = UITapGestureRecognizer(target: self, action: #selector(valyutaTapped))
        valyutaGesture.cancelsTouchesInView = false
        valyutaView.isUserInteractionEnabled = true
        valyutaView.addGestureRecognizer(valyutaGesture)
        
        addConnectionView()
        getValyutas()
        
    }
    

    
    @objc func valyutaTapped(){
        valyutaTextField.becomeFirstResponder()
    }
    
    @objc func transferTapped(){
        performSegue(withIdentifier: "segueToTransfer", sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = true
    }
    
    func revealControllerPanGestureBegan(_ revealController: SWRevealViewController!) {
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let nib: [PricesTableCell] = Bundle.main.loadNibNamed("PricesTableCell", owner: self, options: nil) as! [PricesTableCell]
        
          let cell = nib[0]
        cell.ovalView.layer.cornerRadius = 10.0
                cell.ovalView.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1).cgColor
                 cell.ovalView.layer.borderWidth = 1.0
        
        
        if(indexPath.row == selectedPriceIndex){
            cell.radioBtn.image = UIImage(named: "checked.png")
        }
        else{
            cell.radioBtn.image = UIImage(named: "unchecked.png")
        }
        
        cell.selectionStyle = .none
        cell.dateLbl.text = prices[indexPath.row].display_name
        cell.priceLbl.text = "\((prices[indexPath.row].amount)!) \((prices[indexPath.row].valyuta?.code)!)"
        
        return cell
     }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       selectedPriceIndex = indexPath.row
       if let cell = tableView.cellForRow(at: indexPath) as? PricesTableCell {
        UIView.transition(with: cell.radioBtn,
                            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { cell.radioBtn.image = UIImage(named: "checked.png") },
              completion: nil)
    }
        priceTable.reloadData()
    }
    
//    @IBAction func testClciked(_ sender: Any) {
//        UIView.transition(with: testImageView,
//                          duration: 0.3,
//        options: .transitionCrossDissolve,
//        animations: { self.testImageView.image = UIImage(named: "checked.png") },
//        completion: nil)
//    }
    
    
    func getValyutas(){
        valyutas = []
        connView.isHidden = false
        checkConnIndicator.isHidden = false
        checkConnButtonView.isHidden = true
        
        let carUrl = "http://209.97.140.82/api/v1/valyuta/list"
        guard let url = URL(string: carUrl) else {return}
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(ValyutaListData.self, from: data)
                    for i in 0..<jsonData.data!.count{
                        self.valyutas.append(jsonData.data![i])
                    }
                    DispatchQueue.main.async {
                        self.valyutaLbl.text = self.valyutas[0].code
                        self.getPrices()
                    }
                    self.tryAgaintype = 2
                }
                    
                catch _{
                  //  print(jsonError)
                    DispatchQueue.main.async {
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
    
    func getPrices(){
        connView.isHidden = false
        checkConnIndicator.isHidden = false
        checkConnButtonView.isHidden = true
        
        let carUrl = "http://209.97.140.82/api/v1/monthly/prices?valyuta=" + "\((valyutas[selectedValyutaIndex].id)!)"
        guard let url = URL(string: carUrl) else {return}
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                do{
                    let jsonData = try JSONDecoder().decode(PriceDataModel.self, from: data)
                    for i in 0..<jsonData.data!.count{
                        self.prices.append(jsonData.data![i])
                    }
                    DispatchQueue.main.async {
                        self.priceTable.reloadData()
                    }
                }
                    
                catch _{
                  //  print(jsonError)
                    DispatchQueue.main.async {
                        self.view.makeToast("Xəta baş verdi")
                    }
                }
                
                DispatchQueue.main.async {
                      self.connView.isHidden = true
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
        if(tryAgaintype == 1){
            getValyutas()
        }
        else{
            getPrices()
        }
      
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return valyutas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return valyutas[row].code
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        prices = []
        selectedPriceIndex = 0
        selectedValyutaIndex = row
        valyutaLbl.text = valyutas[row].code
        getPrices()
        
    }
    
    
}
