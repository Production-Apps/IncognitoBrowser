//
//  BookmarkViewController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/27/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit

protocol SelectedBookmarkDelegate {
    func loadSelectedURL(url: URL)
}

class BookmarkViewController: UIViewController {
    
    //MARK: - Properties
    private let bookmarkController = BookmarkController()
    private var bookmarkArray: [Bookmark]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var isEditingMode: Bool = false
    var bookmark: (title: String, url: URL)?
    var delegate: SelectedBookmarkDelegate?
    
    
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
        fetch()
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
    
    func fetch() {
        bookmarkController.loadFromPersistentStore(completion: { (data, error) in
            if let error = error  {
                print("Error fetching \(error)")
                return
            }
            
            if let data = data{
                self.bookmarkArray = data
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
        }
    }
}

//MARK: - UITableViewDelegate
extension BookmarkViewController: UITableViewDelegate{
    
}

//MARK: - UITableViewDataSource
extension BookmarkViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath)

        if let bookmarkArray = bookmarkArray{
            let data =  bookmarkArray[indexPath.row]
            //Data is a folder or is an actual url
            if data.folder == nil{
                cell.imageView?.image = UIImage(systemName: "folder")
                cell.textLabel?.text = data.title
            }else{
                cell.textLabel?.text = data.title
                cell.detailTextLabel?.text = data.title
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let bookmarkArray = bookmarkArray{
                let item = bookmarkArray[indexPath.row]
                bookmarkController.delete(item)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bookmarkArray = bookmarkArray, let selectedURL = bookmarkArray[indexPath.row].url{
            delegate?.loadSelectedURL(url: selectedURL)
            dismiss(animated: true, completion: nil)
        }
    }
}


extension BookmarkViewController: CreateBookmarkDelegate{
    func stateDidChange() {
        fetch()
    }
}
