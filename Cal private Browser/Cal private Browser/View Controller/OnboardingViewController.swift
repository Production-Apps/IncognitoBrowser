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
    
    private var scrollWidth: CGFloat! = 0.0
    private var scrollHeight: CGFloat! = 0.0
    
    
    //MARK: - Oulets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupSlide()
    }
    
    //MARK: - Private methods
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupSlide(){
        
    }
    
    //MARK: - Actions
    @IBAction func pageChanged(_ sender: UIPageControl) {
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

    //MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate{
    
}
