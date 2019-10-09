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
  
    override func viewDidLoad() {
        super.viewDidLoad()

       
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
