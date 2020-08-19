//
//  CalculatorViewController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/19/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var displayLabel: UILabel!
    
    //MARK: - Properties
    private var isFinishTypingNumber: Bool = true

    //MARK: - View Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Actions
    
    @IBAction func calcButtonPressed(_ sender: UIButton){
        
        //Set to true to clear the textfield the next time user start typing
        isFinishTypingNumber = true
    }
    
    
    @IBAction func numButtonPressed(_ sender: UIButton){
        if let numVal = sender.currentTitle {
            
            if isFinishTypingNumber{
                displayLabel.text = numVal
                //Set to signal that we just start typing so the following numbers will be appended to the string in the else statement below
                isFinishTypingNumber = false
            }else{
                displayLabel.text?.append(numVal)
            }
        }
        
    }
    

}
