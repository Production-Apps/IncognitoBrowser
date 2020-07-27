//
//  BookmarkHandler.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/23/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import Foundation
import CoreData


class BookmarkController {
    
    //Create a array to hold the bookmarks
    var bookmarks: [Bookmark]{
        loadFromPersistentStore()
    }
    
    
    //Fetch Method with closure to load array from CoreData
    func loadFromPersistentStore() -> [Bookmark] {
        
        let fetchRequest:NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        
        do {
           //Return the fetch request which will be add it to the bookmarks array above due to the computed property
           return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
        } catch {
            print("Error fetching data \(error)")
            return []
        }
    }
    
    func delete(index: IndexPath) {
        //guard var bookmarks = bookmarks else { return }
         
    }
    
    func save(title: String, url: URL, folder: String) {
        let _ = Bookmark(title: title, url: url, folder: folder)
        saveToPersistentStore()
    }
    
    
    //Save Method the array to CoreData
    private func saveToPersistentStore() {
        do{
            try CoreDataStack.shared.mainContext.save()
        }catch{
            print("Error saving data to CoreData \(error)")
        }
    }
    
}
