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
    private var folderArray: [Folder]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var isEditingMode: Bool = false
    
    var bookmark: (title: String, url: URL)?
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        bookmarkController.delegate = self
        fetchFolders()
    }
    
    //MARK: - Actions
    
    @IBAction func editMode(_ sender: UIBarButtonItem) {
        isEditingMode.toggle()
        toggleEditMode()
    }
    
    //MARK: - Private methods
    private func toggleEditMode() {
        if isEditingMode{
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
    
    private func fetchFolders() {
        bookmarkController.loadFoldersFromPersistentStore(completion: { (data, error) in
            if let error = error  {
                print("Error fetching \(error)")
                return
            }
            if let data = data{
                self.folderArray = data
            }
        })
    }
    
    //MARK: - Overwrite methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewBMSegue"{
            if let createBookmarkVC = segue.destination as? CreateBookmarkViewController{
                createBookmarkVC.bookmarkController = bookmarkController
                createBookmarkVC.bookmark = bookmark
                createBookmarkVC.newFolderMode = isEditingMode
            }
        }else if segue.identifier == "FolderDetailSegue"{
            if let detailVC = segue.destination as? FolderDetailViewController{
                guard let folders = folderArray, let indexPath = tableView.indexPathForSelectedRow else { return }
                let selectedFolder = folders[indexPath.row]
                detailVC.folder = selectedFolder
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension BookmarkViewController: UITableViewDelegate{
    
}

//MARK: - UITableViewDataSource
extension BookmarkViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
        if let folderArray = folderArray{
            let data =  folderArray[indexPath.row]
            cell.textLabel?.text = data.title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let folderArray = folderArray{
                let item = folderArray[indexPath.row]
                bookmarkController.delete(item)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}


extension BookmarkViewController: CreateBookmarkDelegate{
    func stateDidChange() {
        fetchFolders()
    }
}
