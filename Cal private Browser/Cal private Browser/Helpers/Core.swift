//
//  Core.swift
//  Cal private Browser
//
//  Created by FGT MAC on 11/8/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import Foundation

//Use to check if is the first time the app runs to present the onboarding
class Core {
    static let shared = Core()
    
    
    func isNewUser() -> Bool {
        //if is a new user the "isNewUser" value does not exist yet so will return false so we use ! to flip to true
        //Resulting in isNewUser = true during the first run and isNewUser = false during future runs after "setIsNotNewUser" is invoke at the end of the onboarding
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    //is invoke at the end of the onboarding to prevent the onboaring from showing again
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
