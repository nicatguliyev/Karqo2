//
//  ErrorMessageController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 8/23/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class ErrorMessageController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var errorMessages = [String]()
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var errorTable: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.layer.cornerRadius = 15.0
        closeBtn.layer.cornerRadius = 15.0
        errorTable.layer.cornerRadius = 15.0
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errorMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorCellId") as! ErrorMessageCell
        
        cell.errorMessage.text = errorMessages[indexPath.row]
        
        return cell
    }
    

    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
 

}
