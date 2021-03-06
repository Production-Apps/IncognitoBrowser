//
//  CalculatorViewController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/19/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit


enum HandlePasscode {
    case create
    case reset
}

class CalculatorViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var displayLabel: UILabel!
    
    //MARK: - Properties
    
    private var calculatorController = CalculatorController()
    
    private let defaults = UserDefaults.standard
    
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
    
    private var wrongPasscodeCounter = 0//if gets to 3x then it will show alert to reset passcode

    //MARK: - View Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Core.shared.isNewUser(){
            //Show onboarding/Welcome screen
            let vc = storyboard?.instantiateViewController(identifier: "Welcome") as! WelcomeViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
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
    
    //Triggered to enter browser upon correct PIN
    @IBAction func SwipeActionTriggered(_ sender: UISwipeGestureRecognizer) {
        
        //Read saved passcode to authenticate user
        let passcode = defaults.string(forKey: "Passcode")
        //Remove comas from the user entry
        let providedPasscode = displayLabel.text?.replacingOccurrences(of: ",", with: "")
        if sender.state == .ended {
            if providedPasscode == passcode {
                provideFeedback(success: true)
                performSegue(withIdentifier: "BrowserSegue", sender: nil)
            }else{
                
                provideFeedback(success: false)
                wrongPasscodeCounter += 1
                if wrongPasscodeCounter >= 3 {
                    //Show alert to reset passcode
                    //Show disclosure that if passcode is reset all data will be wipe
                    shouldAlert(type: .reset)
                    //reset counter to zero
                    wrongPasscodeCounter = 0
                }//Create else statement see if a userdefault for first run exist
                print(wrongPasscodeCounter)
                
            }
        }
    }
    
    //MARK: - Private Methods
    private func provideFeedback(success: Bool) {
        let feedback = UINotificationFeedbackGenerator()
        
        if success{
            //print("Correct passcode")
            displayLabel.textColor = .white
            feedback.notificationOccurred(.success)
        }else{
           
            UIView.transition(with: displayLabel, duration: 0.7, options: .transitionCrossDissolve) {
                self.displayLabel.textColor = .red
            } completion: { (nil) in
                self.displayLabel.textColor = .white
                
                //Set display to zero
                self.tempValue = "0"
                self.displayValue = 0.0
            }

            
            //Init taptic feedback
            feedback.notificationOccurred(.error)
        }
    }
    
    private func shouldAlert(type: HandlePasscode)  {
        
        //TODO:Sanitized passcode checking if is a four digit passcode
        //Erase all bookmarks if passcode is succesfuly reset
        
        let alert = UIAlertController(title: "Reset Passcode.", message: "If you reset your passcode all your saved data will be erease.", preferredStyle: .alert)
        var passcodeTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new passcode"
            textField.keyboardType = .decimalPad
            passcodeTextField = textField
            
        }
        
        
       
        
        let savePasscodeAction = UIAlertAction(title: "Save", style: .default) { (_) in
            //Save new passcode to Userdefaults
            
            //Check if the textfield is populated and if  the lenght is 4
            guard let passcodeTextField = passcodeTextField, let passcode = passcodeTextField.text else{
                return
            }
            self.defaults.setValue(passcode, forKey: "Passcode")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //savePasscodeAction.isEnabled = newPasscode.count == 4
            
        alert.addAction(savePasscodeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
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
