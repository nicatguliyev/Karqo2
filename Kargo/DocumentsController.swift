//
//  DocumentsController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 9/15/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import Alamofire

class DocumentsController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    @IBOutlet weak var bigActionBar: UIView!
    @IBOutlet weak var editIcon: UIButton!
    
    var connView = UIView()
    var checkConnButtonView = UIView()
    var checkConnIndicator = UIActivityIndicatorView()
    
    var type: Int?
    var foreignPassportUrl: String?
    var carRegisterDoc: String?
    var halfCarRegisterUrl: String?
    var selectedRow: Int?
    
    var imageController = UIImagePickerController()
    var selectedImage: UIImage?
    
    var newforeignPassport: UIImage?
    var newCarRegister: UIImage?
    var newHalfCarRegister: UIImage?
    var image2 = UIImage()
    var first = false
    var scnd = false
    var third = false

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var image1Height: NSLayoutConstraint!
    @IBOutlet weak var image2Height: NSLayoutConstraint!
    @IBOutlet weak var image3Height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        if let flowLayout = documentCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
//            let w = documentCollectionView.frame.width - 40
//            flowLayout.estimatedItemSize = CGSize(width: w, height: 300)
//        }
//

         self.revealViewController()?.panGestureRecognizer()?.isEnabled = false
    
        editIcon.layer.cornerRadius = 27
        setUpBackButton()
        
        if(type == 2){
            addConnectionView()
            getProfileDetails()
        }
        else
        {
            editIcon.isHidden = true
            setImages()
         
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bigActionBar.roundCorners(corners: [.bottomRight], cornerRadius: 70.0)
        })
        
        imageController.delegate = self
        imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imageController.allowsEditing  = false
        
        imageView1.layer.cornerRadius = 10
        imageView2.layer.cornerRadius = 10
        imageView3.layer.cornerRadius = 10
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(image1Tapped))
        imageView1.isUserInteractionEnabled = true
        imageView1.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(image2Tapped))
          imageView2.isUserInteractionEnabled = true
          imageView2.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(image3Tapped))
          imageView3.isUserInteractionEnabled = true
          imageView3.addGestureRecognizer(tapGesture3)
        
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
    
    @objc func image1Tapped(){
        if(type == 2){
            selectedRow = 0
            imageView1.layer.borderWidth = 10
            imageView1.layer.borderColor = UIColor(red: 0/255, green: 193/255, blue: 138/255, alpha: 1).cgColor
            imageView2.layer.borderWidth = 0
            imageView3.layer.borderWidth = 0
        }
    }
    
    @objc func image2Tapped(){
        if(type == 2){
            selectedRow = 1
            imageView2.layer.borderWidth = 10
            imageView2.layer.borderColor = UIColor(red: 0/255, green: 193/255, blue: 138/255, alpha: 1).cgColor
            imageView1.layer.borderWidth = 0
            imageView3.layer.borderWidth = 0
        }

       }
    
    @objc func image3Tapped(){
        if(type == 2){
            selectedRow = 2
            imageView3.layer.borderWidth = 10
            imageView3.layer.borderColor = UIColor(red: 0/255, green: 193/255, blue: 138/255, alpha: 1).cgColor
            imageView2.layer.borderWidth = 0
            imageView1.layer.borderWidth = 0
        }

       }
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
    }

    func addConnectionView(){
        if let connectionView = Bundle.main.loadNibNamed("CheckConnectionView", owner: self, options: nil)?.first as? CheckConnectionView {
            connectionView.frame = CGRect(x: 0, y: 75, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 75)
            self.view.addSubview(connectionView);
            connectionView.buttonView.clipsToBounds = true

            connView = connectionView
            checkConnButtonView = connectionView.buttonView
            checkConnIndicator = connectionView.checkIndicator

            connectionView.tryButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        }
    }

    @objc func tryAgain(){
        getProfileDetails()
    }
    
    func getProfileDetails(){
        self.connView.isHidden = false
        self.checkConnIndicator.isHidden = false
        self.checkConnButtonView.isHidden = true
        
        let userId =  UserDefaults.standard.string(forKey: "USERID")!
        let driverDetailUrl = "http://209.97.140.82/api/v1/user/profile/\(userId)"
        guard let url = URL(string: driverDetailUrl) else {return}
        print(driverDetailUrl)
        
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 8.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: urlRequest){(data, response, error) in
            
            if(error == nil){
                guard let data = data else {return}
                
                do{
                    let jsonData = try JSONDecoder().decode(DriverProfileData.self, from: data)
                    if(jsonData.status == "success"){
                      self.foreignPassportUrl = jsonData.data?.foreign_passport
                        self.carRegisterDoc = jsonData.data?.car_register_doc
                        self.halfCarRegisterUrl = jsonData.data?.half_car_register_doc
                        DispatchQueue.main.async {
                            self.setImages()
                            //  self.documentCollectionView.reloadData()
                        }
                    }
                    
                }
                    
                catch _{
                    DispatchQueue.main.async {
                        self.view.makeToast("Json Error")
                      
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
                           self.checkConnIndicator.isHidden = true
                           self.checkConnButtonView.isHidden = false
                        }
                        
                    }
                }
            }
            }.resume()
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        if(selectedRow == nil){
            self.view.makeToast("Dəyişmək istədiyiniz şəkili seçin")
        }
        else
        {
            self.present(imageController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil{
            
            selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            updateDocument()
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func updateDocument(){
        connView.isHidden = false
        checkConnIndicator.isHidden = false
        checkConnButtonView.isHidden = true
        
        var url = ""
        
        if(selectedRow == 0) {
            url = "http://209.97.140.82/api/v1/user/update/foreign_passport"
        }
        else if(selectedRow == 1 ){
            url = "http://209.97.140.82/api/v1/user/update/car_register_doc"
        }
        else{
              url = "http://209.97.140.82/api/v1/user/update/half_car_register_doc"
        }
        
        let headers = [
            "Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "USERTOKEN"))!,
            "Content-type":"multipart/form-data",
            "Content-Disposition":"form-data"
            
        ]
        
        let imgData = selectedImage!.jpegData(compressionQuality: 0.2)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            
            if let imgData = imgData{
                multipartFormData.append(imgData, withName: "document",fileName: "document.png", mimeType: "image/png")
            }
            
        }, usingThreshold:UInt64.init(),
            to: url, //URL Here
            method: .post,
            headers: headers, //pass header dictionary here
            encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseString { response in
                        
                        self.connView.isHidden = true
                        guard let data = response.data else {return}
                        
                        
                        if let responseCode = response.response?.statusCode{
                            
                            if(responseCode == 200)
                            {
                                
                                
                                do {
                                    let responseData = try JSONDecoder().decode(AddOrderSuccessModel.self, from: data)
                                    if(responseData.status == "success"){
                                       
                                        DispatchQueue.main.async {
                                            if(self.selectedRow == 0)
                                            {
                                                //self.newforeignPassport = self.selectedImage
                                                let ratio = CGFloat(((self.selectedImage?.size.width)!)) / CGFloat(((self.selectedImage?.size.height)!))
                                                
                                                let newHeight = Int(self.imageView1.frame.width / CGFloat(ratio))
                                                self.image1Height.constant = CGFloat(newHeight)
                                                self.imageView1.image = self.selectedImage
                                                self.view.makeToast("Xarici passport  dəyişdirildi")
                                            }
                                            else if(self.selectedRow == 1){
                                                //self.newCarRegister = self.selectedImage
                                                let ratio = CGFloat(((self.selectedImage?.size.width)!)) / CGFloat(((self.selectedImage?.size.height)!))
                                            
                                                let newHeight = Int(self.imageView2.frame.width / CGFloat(ratio))
                                                self.image2Height.constant = CGFloat(newHeight)
                                                self.imageView2.image = self.selectedImage
                                                 self.view.makeToast("Nəqliyyat vasitəsinin qeydiyyat şəhadətnaməsi dəyişdirildi")
                                            }
                                            else{
                                              //  self.newHalfCarRegister = self.selectedImage
                                                let ratio = CGFloat(((self.selectedImage?.size.width)!)) / CGFloat(((self.selectedImage?.size.height)!))
                                                
                                                    let newHeight = Int(self.imageView3.frame.width / CGFloat(ratio))
                                                    self.image3Height.constant = CGFloat(newHeight)
                                                    self.imageView3.image = self.selectedImage
                                                self.view.makeToast("Yarımqoşqunun qeydiyyat şəhadətnaməsi dəyişdirildi")
                                            }
                                             self.selectedImage = nil
                                         //    self.documentCollectionView.reloadData()
                                        }
                                    }
                                    else
                                    {
                                        DispatchQueue.main.async {
                                            self.view.makeToast("Xəta: Fayl dəyişdirilmədi")
                                            //self.userImage.image = nil
                                        }
                                    }
                                }
                                    
                                    
                                    
                                catch{
                                    
                                    DispatchQueue.main.async {
                                        self.view.makeToast("Xəta: Json Error. Fayl dəyişdirilmədi")
                                        //self.userImage.image = nil
                                    }
                                }
                                
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    self.view.makeToast("Xəta \(responseCode): Fayl dəyişdirilmədi")
                                    // self.userImage.image = nil
                                }
                            }
                        }
                        
                        if let error = response.error as NSError?
                        {
                            if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorTimedOut{
                                self.view.makeToast("Fayl dəyişdirilmədi. İnternet bağlantısını yoxlayın")
                            }
                            else{
                                self.view.makeToast("Bilinməyən xəta. Fayl dəyişdirilmədi")
                            }
                            
                        }
                        
                    }
                    
                    break
                case .failure( _):
                    self.connView.isHidden = true
                    //print(error)
                    self.view.makeToast("Bilinməyən xəta. Fayl dəyişdirilmədi")
                    break
                }
        })
        
    }
    
    func getAspectRatioAccordingToiPhones(cellImageFrame:CGSize,downloadedImage: UIImage)->CGFloat {
           let widthOffset = downloadedImage.size.width - cellImageFrame.width
           let widthOffsetPercentage = (widthOffset*100)/downloadedImage.size.width
           let heightOffset = (widthOffsetPercentage * downloadedImage.size.height)/100
           let effectiveHeight = downloadedImage.size.height - heightOffset
           return(effectiveHeight)
       }
    
    func setImages(){
        if let foreignPassportUrl = foreignPassportUrl{
            
            //imageView1.sd_setImage(with: <#T##URL?#>, placeholderImage: <#T##UIImage?#>, options: <#T##SDWebImageOptions#>, completed: <#T##SDExternalCompletionBlock?##SDExternalCompletionBlock?##(UIImage?, Error?, SDImageCacheType, URL?) -> Void#>)
            
                 
            
                    imageView1.sd_setImage(with: URL(string: foreignPassportUrl), completed: {image, error, cachType, imageURL in
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                            let ratio = CGFloat((image?.size.width)!) / CGFloat((image?.size.height)!)
                            print(ratio)
                            let newHeight = Int(self.imageView1.frame.width / CGFloat(ratio))
                            self.image1Height.constant = CGFloat(newHeight)
                            self.imageView1.image = image
                        })
                        
                       
                    })
                }
                if let carRegisterDoc = carRegisterDoc{
                    imageView2.sd_setImage(with: URL(string: carRegisterDoc), completed: {image, error, cachType, imageURL in
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                            
                            let ratio = CGFloat((image?.size.width)!) / CGFloat((image?.size.height)!)
                            let newHeight = Int(self.imageView2.frame.width / CGFloat(ratio))
                            self.image2Height.constant = CGFloat(newHeight)
                            self.imageView2.image = image
                        })
                      
                    })
                }
                if let halfCarRegisterUrl = halfCarRegisterUrl{
                    imageView3.sd_setImage(with: URL(string: halfCarRegisterUrl), completed: {image, error, cachType, imageURL in
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                            
                            let ratio = CGFloat((image?.size.width)!) / CGFloat((image?.size.height)!)
                            let newHeight = Int(self.imageView3.frame.width / CGFloat(ratio))
                            self.image3Height.constant = CGFloat(newHeight)
                            self.imageView3.image = image
                        })
                       
                    })
                }
    }
    
    
}
