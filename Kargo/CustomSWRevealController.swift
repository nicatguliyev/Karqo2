//
//  CustomSWRevealController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/27/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class CustomSWRevealController: SWRevealViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func exit() -> () {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToExit")
        {
            let VC = segue.destination as! ExitPopupController
            VC.exit = self.exit
        }
    }
    
}
