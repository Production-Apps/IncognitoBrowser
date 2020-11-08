//
//  OnboardingViewController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 11/2/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    //MARK: - Properties
    private var titles:[String] =  ["Welcome","1.Create a passcode","2.Enter passcode and swipe"]
    private var desc: [String] = ["","Please create a numeric passcode after the welcome screen.","When you want to browse the web, simply enter passcode and swipe left to right."]
    
    
    //MARK: - Oulets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    //MARK: - Private methods
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
 
    
    //MARK: - Actions
    @IBAction func pageChanged(_ sender: UIPageControl) {
//        scrollView.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat(pageControl.currentPage), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
        print("Page change \(sender.currentPage)")
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        //Move next
    }
    
}

    //MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Hello")
    }
    
}
