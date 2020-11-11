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
    private var titles = ["Welcome","Easy to use","Security & Privacy","Create a passcode", "Access browser"]
    private var desc = ["The best private browser in the app store.",
        "One hand navigation, use hand gestures to go back and foward or simply use the easy nav controls.",
                        "Tap the lock icon to clear browser history and go back to calculator view.",
        "",
                        "Enter passcode and Swipe from left to right to access the browser."
    ]
    
    private let scrollView = UIScrollView()
    
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
        scrollView.frame = holderView.bounds
        holderView.addSubview(scrollView)
        
        for x in 0..<titles.count{
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
            imageView.image = UIImage(named: "welcome\(x + 1)")
            pageView.addSubview(imageView)
            
            //Configure button
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            
            button.setTitle("Continue", for: .normal)
            
            if x == titles.count{
                button.setTitle("Get started", for: .normal)
            }
            
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = x+1
            pageView.addSubview(button)
            
        }
        
        scrollView.contentSize = CGSize(width: holderView.frame.width * 3, height: 0)
        scrollView.isPagingEnabled = true
        
    }
    
    @objc private func didTapButton(_ button: UIButton) {
        guard button.tag < titles.count else {
            //dismiss if is not
            Core.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        //scroll to next page
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag) , y: 0), animated: true)
    }
    

 
}
