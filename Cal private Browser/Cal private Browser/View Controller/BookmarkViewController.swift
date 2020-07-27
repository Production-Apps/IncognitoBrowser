//
//  BookmarkViewController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/27/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    //MARK: - Properties
    private let bookmarkController = BookmarkController()
    private var isEditingEnable: Bool = false
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Actions
    
    @IBAction func editMode(_ sender: UIBarButtonItem) {
        isEditingEnable.toggle()
        toggleEditMode()
    }
    
    //MARK: - Private methods
    private func toggleEditMode() {
        if isEditingEnable{
            editButton.title = "Done"
            createButton.image = nil
            createButton.title = "New Folder"
            tableView.setEditing(true, animated: true)
        }else{
            editButton.title = "Edit"
            createButton.image = UIImage(systemName: "plus")
            tableView.setEditing(false, animated: true)
        }
    }
}

//MARK: - UITableViewDelegate
extension BookmarkViewController: UITableViewDelegate{
    
}

//MARK: - UITableViewDataSource
extension BookmarkViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkController.bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath)
        
        let data = bookmarkController.bookmarks[indexPath.row]
        
        //Data is a folder or is an actual url
        if data.folder == nil{
            cell.imageView?.image = UIImage(systemName: "folder")
            cell.textLabel?.text = data.title
        }else{
            cell.textLabel?.text = data.title
            cell.detailTextLabel?.text = data.title
        }
        return cell
    }
    
    
}
