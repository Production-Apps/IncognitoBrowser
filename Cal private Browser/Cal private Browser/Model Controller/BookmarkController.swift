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
    func loadFoldersFromPersistentStore(completion: @escaping ([Folder]?,Error?) -> Void) {
        
        let fetchRequest:NSFetchRequest<Folder> = Folder.fetchRequest()
        
        let sort = NSSortDescriptor(key: #keyPath(Folder.title), ascending: true)
        
        fetchRequest.sortDescriptors = [sort]
        
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
    
    func saveBookmark(title: String, url: URL, folder: Folder) {
        let bookmark = Bookmark(title: title, url: url)
        //Save with a relationship to the specific folder
        bookmark.location = folder
        saveToPersistentStore()
    }
    
    func saveFolder(title: String) {
        let _ = Folder(title: title)
        saveToPersistentStore()
    }
    
    func updateFolder(title: String, folder: Folder) {
        folder.title = title
        saveToPersistentStore()
    }
    
    func resetContext() {
        CoreDataStack.shared.mainContext.reset()
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
