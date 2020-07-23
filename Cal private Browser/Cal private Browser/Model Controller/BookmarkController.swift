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
        
        return bookmarks
    }
    
    //Save Method the array to CoreData
    func save(bookmark: Bookmark) {
         
    }
    
    func delete(index: IndexPath) {
        //guard var bookmarks = bookmarks else { return }
         
    }
}
