//
//  InformationController.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/2/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit

class InformationController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var slideScroll: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var page1 = FirstInfPage()
    var page2 = FirstInfPage()
    var page3 = FirstInfPage()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        designButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.addPages()
        })

    }
    
    func designButtons(){
        createShadow(view: loginBtn)
        createShadow(view: registerBtn)
    }
    
    
    func createShadow(view: UIView){
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowOpacity = 10
        view.layer.shadowRadius = 3
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 5.0
    }
    
    func addPages(){
        let screenWidth = UIScreen.main.bounds.size.width
        horizontalScrollView.contentSize = CGSize(width: screenWidth * CGFloat(3), height: horizontalScrollView.frame.height)
        
        page1 = Bundle.main.loadNibNamed("FirstInfPage", owner: self, options: nil)?.first as! FirstInfPage
        page1.frame = CGRect(x: view.frame.size.width * CGFloat(0), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        horizontalScrollView.addSubview(page1)
    
        page2 = Bundle.main.loadNibNamed("FirstInfPage", owner: self, options: nil)?.first as! FirstInfPage
        page2.frame = CGRect(x: view.frame.size.width * CGFloat(1), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        horizontalScrollView.addSubview(page2)
        
        page3 = Bundle.main.loadNibNamed("FirstInfPage", owner: self, options: nil)?.first as! FirstInfPage
        page3.frame = CGRect(x: view.frame.size.width * CGFloat(2), y: 0, width: view.frame.size.width, height: horizontalScrollView.frame.height)
        horizontalScrollView.addSubview(page3)
        
        createShadow(view: page1.mainView)
        createShadow(view: page2.mainView)
        createShadow(view: page3.mainView)
        
        page1.mainView.layer.cornerRadius = 16
        page2.mainView.layer.cornerRadius = 16
        page3.mainView.layer.cornerRadius = 16
        
        page1.greenView.layer.cornerRadius = 2
        page2.greenView.layer.cornerRadius = 2
        page3.greenView.layer.cornerRadius = 2
        
        
        if(UIScreen.main.bounds.height < 580.0){
            page1.imageHeight.constant = 120
            page2.imageHeight.constant = 120
            page3.imageHeight.constant = 120
            
            page1.imageWidth.constant = 120
            page2.imageWidth.constant = 120
            page2.imageWidth.constant = 120
            
            page1.kargoLbl.font = page1.kargoLbl.font.withSize(28)
            page1.titleLable.font = page1.titleLable.font.withSize(17)
            page1.contentLbl.font = page1.contentLbl.font.withSize(14)
            
            page2.kargoLbl.font = page1.kargoLbl.font.withSize(28)
            page2.titleLable.font = page1.titleLable.font.withSize(17)
            page2.contentLbl.font = page1.contentLbl.font.withSize(14)
            
            page3.kargoLbl.font = page1.kargoLbl.font.withSize(28)
            page3.titleLable.font = page1.titleLable.font.withSize(17)
            page3.contentLbl.font = page1.contentLbl.font.withSize(14)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == slideScroll)
        {
            let pageNumber = slideScroll.contentOffset.x / scrollView.frame.size.width
            pageControl.currentPage = Int(pageNumber)
            
        }
    }
    

}
