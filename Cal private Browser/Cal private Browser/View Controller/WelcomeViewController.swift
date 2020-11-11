//
//  WelcomeViewController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 11/8/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //MARK: - Properties
    private var titles = ["Create a passcode","Enter passcode", "Swipe right to access"]
    
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
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.width - 20, height: 120))
            let imageView = UIImageView(frame: CGRect(x: 10, y: 140, width: pageView.frame.width - 20, height: pageView.frame.height - 205))
            let button = UIButton(frame: CGRect(x: 10, y: pageView.frame.height-60, width: pageView.frame.width - 20, height: 50))
            
            //Configure label
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica-Bold", size: 32)
            label.text = titles[x]
            pageView.addSubview(label)
            
            //Configure image view
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "welcome\(x)")
            pageView.addSubview(imageView)
            
            //Configure button
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            
            button.setTitle("Get started", for: .normal)
            
            if x == 1{
                button.setTitle("Continue", for: .normal)
            }
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            pageView.addSubview(button)
            
        }
        
        scrollView.contentSize = CGSize(width: holderView.frame.width * 3, height: 0)
        scrollView.isPagingEnabled = true
        
    }
    
    @objc private func didTapButton(_ button: UIButton) {
        
    }
    

 
}
