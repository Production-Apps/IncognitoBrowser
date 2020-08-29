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
    
    //MARK: - Propertieslet numberFormatter = NumberFormatter()
    private var calculatorController = CalculatorController()
    
    private var isFinishTypingNumber: Bool = true
    
    private var displayValue: Double {
        get{
            let cleanVal = displayLabel.text!.replacingOccurrences(of: ",", with: "")
            guard let doubleValue = Double(cleanVal) else { return 0.0 }
            return doubleValue
        }
        
        set{
            
            displayLabel.text = newValue.withCommas()
        }
    }
    private var tempValue: String = ""

    //MARK: - View Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Actions
    
    @IBAction func calcButtonPressed(_ sender: UIButton){
        //Set to true to clear the textfield the next time user start typing
        isFinishTypingNumber = true

        if let result = calculatorController.calculateResult(for: displayValue, symbol: sender.currentTitle){
            displayValue = result
        }
        
    }
    
    @IBAction func numButtonPressed(_ sender: UIButton){
        if let numVal = sender.currentTitle {
            
            if isFinishTypingNumber{
                tempValue = numVal
                //Set to signal that we just start typing so the following numbers will be appended to the string in the else statement below
                isFinishTypingNumber = false
            }else{
                numberFormatter.alwaysShowsDecimalSeparator = false
                //prevent more than one decimal to be type by user
                if numVal == "."{
                    numberFormatter.alwaysShowsDecimalSeparator = true
                    //Check if the rounded value is equal to the current value
                    //EX: on label 8.2 --- rounded 8 = isInt is False
                    //EX: on label 8 --- rounded 8 = isInt is True
                    let isInt = floor(displayValue) == displayValue
                    
                    //If it is Int then we allow a decimal point
                    //If is not then it means that we have a decimal value already so we cannot allow more decimal points to be enter
                    if !isInt{
                        //By returning we wont allow more decimal points to be enter
                        return
                    }
                    
                }
                tempValue += numVal
                displayLabel.text?.append(numVal)
            }
            if let totalDouble = Double(tempValue){
                
                displayValue = totalDouble
            }
        }
        
    }
    
    @IBAction func SwipeActionTriggered(_ sender: UISwipeGestureRecognizer) {
        
        //TODO: Implement userdefaults to save password and retrive it
        let passCode = "1234"
        
        if sender.state == .ended {
            if displayLabel.text == passCode {
                //Create segue
                print("Correct passcode")
                performSegue(withIdentifier: "BrowserSegue", sender: nil)
            }else{
                print("Incorrect passcode")
            }
        }
    }
}

let numberFormatter = NumberFormatter()

extension Double {
    func withCommas() -> String {
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.decimalSeparator = "."
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
