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
    private var titles = ["Secure Browsing","Easy to use","Security & Privacy","Create a passcode", "Access browser"]
    
    private var desc = ["Fully erase your browsing history and keep your bookmarks secured.",
        "One hand navigation, use hand gestures to go back and foward or simply use the easy nav controls.",
                        "Tap the lock icon to clear browser history and go back to calculator view.",
        "",
                        "1. Enter passcode \n2. Swipe from right to left to access the browser."
    ]
    
    private let scrollView = UIScrollView()
    private let textField = UITextField()
    private let defaults = UserDefaults.standard
    
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
            let title = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.width - 20, height: 120))
            let imageView = UIImageView(frame: CGRect(x: 10, y: 140, width: pageView.frame.width - 20, height: pageView.frame.height - 305))
            
            let textField = UITextField(frame: CGRect(x: 10, y: pageView.center.y, width: pageView.frame.width - 20, height: 40))
            
            let detail = UILabel(frame: CGRect(x: 10, y: pageView.frame.height - 180, width: pageView.frame.width - 20, height: 120))
            
            let button = UIButton(frame: CGRect(x: 10, y: pageView.frame.height-60, width: pageView.frame.width - 20, height: 50))
            
            let setCodebutton = UIButton(frame: CGRect(x: pageView.frame.width - 40, y: pageView.center.y, width: 30, height: 40))
            
            //Configure title
            title.textAlignment = .center
            title.font = UIFont(name: "Helvetica-Bold", size: 32)
            title.text = titles[x]
            pageView.addSubview(title)
            
            
            //Configure Detail
            detail.textAlignment = .center
            detail.numberOfLines = 10
            detail.font = UIFont(name: "Helvetica-Bold", size: 18)
            detail.text = desc[x]
            pageView.addSubview(detail)
            
            //Configure Textfield to create passcode
            textField.textAlignment = .center
            textField.placeholder = "Enter New Passcode"
            textField.keyboardType = .decimalPad
            textField.borderStyle = .roundedRect
            textField.font = UIFont(name: "Helvetica-Bold", size: 24)
            
            //Configure button
            setCodebutton.setTitleColor(.white, for: .normal)
            setCodebutton.backgroundColor = .black
            setCodebutton.setTitle(">", for: .normal)
            setCodebutton.layer.cornerRadius = 5
            
            if x == 3{
                pageView.addSubview(textField)
                pageView.addSubview(setCodebutton)
                //Will pass the value of the testfield
                textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
             
                button.isHidden = true
                
                setCodebutton.addTarget(self, action: #selector(setPasscode(_:)), for: .touchUpInside)
                
            }

            
            //Configure image view
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "welcome\(x + 1)")
            pageView.addSubview(imageView)
            
            //Configure button
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            button.setTitle("Continue", for: .normal)
            
            if x == titles.count - 1{
                button.setTitle("Get started", for: .normal)
            }
            
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = x+1
            pageView.addSubview(button)
            
        }
        
        scrollView.contentSize = CGSize(width: holderView.frame.width * 3, height: 0)
        scrollView.isPagingEnabled = true
        
    }
    
    @objc private func didTapButton(_ sender: UIButton) {
        guard sender.tag < titles.count else {
            //dismiss if is not
           // Core.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        
        moveToNextPage(sender.tag)
    }
    
    private func moveToNextPage(_ currentPage: Int){
        //scroll to next page
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(currentPage) , y: 0), animated: true)
    }

    @objc private func setPasscode(_ sender: UIButton){
        self.view.endEditing(true)
        
        guard let passcode = textField.text else { return }

        if  !passcode.isEmpty{
            
            //save passcode and move to next screen
            defaults.set(passcode, forKey: "Passcode")
            moveToNextPage(4)
        }else{
            //TODO: Let user know that a passcode must be create
//            DispatchQueue.main.async {
//                self.textField.attributedPlaceholder = NSAttributedString(string: "Create a passcode", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])}
//             
//            print("No passcode")
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let passcode = textField.text else {
        return
        }
        self.textField.text = passcode
    }
 
}



