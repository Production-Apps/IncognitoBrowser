//
//  CoreDataStack.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/23/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    //Singleton which is a shared single instance of this class
    static let shared = CoreDataStack()
    
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "PrivateBrowser")
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persitant stores: \(error)")
            }
        }
        return container
    }()
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
