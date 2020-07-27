//
//  BookmarkTableViewController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/16/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit

class BookmarkTableViewController: UITableViewController {
    
    //MARK: - Properties
    var targetURL: URL?
    private let bookmarkHandler = BookmarkController()
    private var bookmarks: [BookmarkController]?
    
    //MARK: - Outlets

    
    
    //MARK: - View lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkHandler.bookmarks.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarksCell", for: indexPath)

        // Configure the cell...

        return cell
    }

}
