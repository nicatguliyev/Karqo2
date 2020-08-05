//
//  PayWebviewController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 8/3/20.
//  Copyright © 2020 Nicat Guliyev. All rights reserved.
//

import UIKit
import WebKit

class PayWebviewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var amount: Float?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController()?.panGestureRecognizer()?.isEnabled = false
        
        let urlString = "http://carryup.az/iba/index.php?i=" + UserDefaults.standard.string(forKey: "USERID")! + "&action=pay&amount=\(amount!)"
        print(urlString)
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request)

        // Do any additional setup after loading the view.
    }
    

 

}
