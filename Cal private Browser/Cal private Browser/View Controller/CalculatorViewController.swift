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
        
        //Can be force unwrap because there will always be a num
        guard let number = Double(displayLabel.text!) else {
            fatalError("Cannot convert number into Double.")
        }
        
        if let calcMethod = sender.currentTitle {
            switch calcMethod {
            case "+/-":
                displayLabel.text = String(number * -1)
            case "AC":
                displayLabel.text = "0"
            case "%":
                displayLabel.text = String(number * 0.01)
            case "÷":
            //Do something
                displayLabel.text = "0"
            case "×":
            //Do something
                displayLabel.text = "0"
            case "+":
            //Do something
                displayLabel.text = "0"
            case "=":
            //Do something
                displayLabel.text = "0"
            default:
                print("Case not found")
            }
        }
        
    }
    
    
    @IBAction func numButtonPressed(_ sender: UIButton){
        if let numVal = sender.currentTitle {
            
            if isFinishTypingNumber{
                displayLabel.text = numVal
                //Set to signal that we just start typing so the following numbers will be appended to the string in the else statement below
                isFinishTypingNumber = false
            }else{
                //prevent more than one decimal to be type by user
                if numVal == "."{
                    
                    guard let currDisplayVal = Double(displayLabel.text!) else {
                        fatalError("Cannot convert current value into double")
                    }
                    
                    //Check if the rounded value is equal to the current value
                    //EX: on label 8.2 --- rounded 8 = isInt is False
                    //EX: on label 8 --- rounded 8 = isInt is True
                    let isInt = floor(currDisplayVal) == currDisplayVal
                    
                    //If it is Int then we allow a decimal point
                    //If is not then it means that we have a decimal value already so we cannot allow more decimal points to be enter
                    if !isInt{
                        //By returning we wont allow more decimal points to be enter
                        return
                    }
                    
                }
                
                displayLabel.text?.append(numVal)
            }
        }
        
    }
    

}
