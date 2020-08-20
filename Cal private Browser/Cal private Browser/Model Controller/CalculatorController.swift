//
//  CalculatorController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 8/20/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import Foundation

struct CalculatorController {
    
    //Tuple to groupe related data
    private var intermediateCalculation:  (num1: Double, symbol: String)?
    
    
    mutating func calculateResult(for number: Double , symbol: String? ) -> Double? {
        
        if let calcMethod = symbol {
            switch calcMethod {
            case "+/-":
                return number * -1
            case "AC":
                return 0
            case "%":
                return number * 0.01
            case "=":
                return performTwoNumCalculation(n2: number)
            default:
                intermediateCalculation = (num1: number, symbol: calcMethod)
            }
        }
        return nil
    }
    
    private func performTwoNumCalculation(n2: Double) -> Double? {
        if let n1 = intermediateCalculation?.num1,
            let operation = intermediateCalculation?.symbol{
            switch operation {
            case "÷":
                return n1 / n2
            case "×":
                return n1 * n2
            case "+":
                return n1 + n2
            case "-":
                return n1 - n2
            default:
                fatalError("Operation passed is does not match any of the cases.")
            }
        }
        return nil
    }
    
}
