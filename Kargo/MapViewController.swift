//
//  MapViewController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 9/19/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UIGestureRecognizerDelegate{

    @IBOutlet weak var map: MKMapView!
    var setCoord: ((String, String) -> ())?
    var coord_x = ""
    var coord_y = ""
    var backButton = UIButton()
    var barItem = UIBarButtonItem()
    var doneButton = UIButton()
    var barItem2 = UIBarButtonItem()
    var center  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
     //   longPress.minimumPressDuration = 0.2
     //   longPress.delegate = self
        map.isUserInteractionEnabled = true
      //  map.addGestureRecognizer(longPress)
        setUpBackButton()
        
        
       // self.map.zset

        // Do any additional setup after loading the view.
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        center = "\(mapView.centerCoordinate.latitude)" + ", " + "\(mapView.centerCoordinate.longitude)"
        print(center)
    }
    
//    @objc func longPressed(gesture: UILongPressGestureRecognizer){
//        if(gesture.state == .began){
//            self.map.removeAnnotations(self.map.annotations)
//            let touchPoint = gesture.location(in: self.map)
//            let touchMapCoord = self.map.convert(touchPoint, toCoordinateFrom: self.map)
//
//            let annot  = MKPointAnnotation()
//            annot.coordinate = touchMapCoord
//            coord_x = "\(touchMapCoord.latitude)"
//            coord_y = "\(touchMapCoord.longitude)"
//
//            annot.title = "Yükün yeri"
//            self.map.addAnnotation(annot)
//            self.map.setCenter(touchMapCoord, animated: true)
//
//        }
//
//    }
    
    func setUpBackButton(){
        
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.setImage(UIImage(named: "whiteBackIcon.png"), for: UIControl.State.normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 30)
        
        backButton.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
        
        barItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = barItem
        
        doneButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        doneButton.setImage(UIImage(named: "whiteDone.png"), for: UIControl.State.normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 0)
        
        doneButton.addTarget(self, action: #selector(doneClicked), for: .touchUpInside)
        
        barItem2 = UIBarButtonItem(customView: doneButton)
        
        self.navigationItem.rightBarButtonItem = barItem2
    
    }
    
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneClicked(){
        //center = "\(map.centerCoordinate.latitude)" + ", " + "\(map.centerCoordinate.longitude)"
        coord_x = "\(map.centerCoordinate.longitude)"
        coord_y = "\(map.centerCoordinate.latitude)"
          //    print(center)
        setCoord!(String(coord_x.prefix(10)), String(coord_y.prefix(10)))
        self.navigationController?.popViewController(animated: true)
    //    self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
