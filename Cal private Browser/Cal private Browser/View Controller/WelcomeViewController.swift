//
//  WelcomeViewController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 11/8/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var holderView: UIView! 

    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    
    //MARK: - Private methods
    private func configure()  {
        //Setup the scroll view
        let scrollView = UIScrollView(frame: holderView.bounds)
        holderView.addSubview(scrollView)
        
        for x in 0..<3{
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * holderView.frame.width, y: 0, width: holderView.frame.width, height: holderView.frame.height))
            scrollView.addSubview(pageView)
            
            //Setup title, image and button
        }
        
    }
    

 
}
