//
//  CustomActionBar.swift
//  Kargo
//
//  Created by Nicat Guliyev on 11/13/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import Foundation


struct HttpResponseData {
    var data: Data?
    var error: Error?
}

class CustomActionBar {
//    var connView: UIView?
//    var checkConnButtonView: UIView?
//    var checkConnIndicator: UIActivityIndicatorView?
//    var viewController: UIViewController?
//
//    init(connView: UIView, checkConnButtonView: UIView, checkConnIndicator: UIActivityIndicatorView, viewController: UIViewController){
//        self.connView = connView
//        self.checkConnButtonView = checkConnButtonView
//        self.checkConnIndicator = checkConnIndicator
//        self.viewController = viewController
//
//    }
//
//    func addConnectionView(){
//        if let connectionView = Bundle.main.loadNibNamed("CheckConnectionView", owner: self, options: nil)?.first as? CheckConnectionView {
//            connectionView.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 80)
//
//            self.viewController?.view.addSubview(connectionView);
//            connectionView.buttonView.clipsToBounds = true
//
//            connView = connectionView
//            checkConnButtonView = connectionView.buttonView
//            checkConnIndicator = connectionView.checkIndicator
//
//
//
//           // connectionView.tryButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
//        }
//    }
    
//    @objc func tryAgain(){
//
//    }
    
    let url: String?
    
    init (url: String){
        self.url = url
    }
    
    func getValyutas(completion: @escaping (Data? , Error?) -> Void){
      //  tipler = []
        let carUrl = url
        //var response1 = HttpResponseData(data: nil, error: nil)
        let url = URL(string: carUrl!)
        
        URLSession.shared.dataTask(with: url!){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                completion(data, nil)
            }
            else
            {
                
                if let error = error as NSError?
                {
                    if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                        DispatchQueue.main.async {
                          //  self.connView.isHidden = false
                      //      self.checkConnButtonView.isHidden = false
                       //     self.checkConnIndicator.isHidden = true
                        }
                    }
                }
                
                 completion(nil, error)
            }
            
            
            }.resume()
        
        //return response1
        
    }
    
    func method(arg: Bool, completion: @escaping (Int) -> ()) {
        print("First line of code executed")
        var x = 5
        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
            x = 10
            completion(x)
        })
        
    }
    
    
}
