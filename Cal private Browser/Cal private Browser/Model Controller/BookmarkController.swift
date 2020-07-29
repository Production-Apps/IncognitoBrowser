//
//  BookmarkHandler.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/23/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import Foundation
import CoreData

protocol CreateBookmarkDelegate {
    func stateDidChange()
}

class BookmarkController {
    
    var delegate: CreateBookmarkDelegate?
    
    //Fetch Method with closure to load array from CoreData
    func loadBookmarksFromPersistentStore(completion: @escaping ([Bookmark]?,Error?) -> Void) {
        
        let fetchRequest:NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        do {
           //Return the fetch request which will be add it to the bookmarks array above due to the computed property
           let data = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            completion(data,nil)
        } catch {
            completion(nil,error)
        }
    }
    
    func loadFoldersFromPersistentStore(completion: @escaping ([Folder]?,Error?) -> Void) {
        
        let fetchRequest:NSFetchRequest<Folder> = Folder.fetchRequest()
        do {
           //Return the fetch request which will be add it to the bookmarks array above due to the computed property
           let data = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            completion(data,nil)
        } catch {
            completion(nil,error)
        }
    }
    
    func delete(_ item: NSManagedObject) {
        CoreDataStack.shared.mainContext.delete(item)
        saveToPersistentStore()
    }
    
    func saveBookmark(title: String, url: URL, folder: String) {
        let _ = Bookmark(title: title, url: url, folder: folder)
        saveToPersistentStore()
    }
    
    func saveFolder(title: String) {
        let _ = Folder(title: title)
        saveToPersistentStore()
    }
    
    //Save Method the array to CoreData
    private func saveToPersistentStore() {
        do{
            try CoreDataStack.shared.mainContext.save()
            delegate?.stateDidChange()
        }catch{
            print("Error saving data to CoreData \(error)")
        }
    }
    
}
