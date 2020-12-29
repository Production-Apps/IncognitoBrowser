//
//  FolderDetailViewController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/29/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit

protocol SelectedBookmarkDelegate {
    func loadSelectedURL(url: URL)
}

class FolderDetailViewController: UIViewController {
    
    //MARK: - Properties
    var folder: Folder?
    var delegate: SelectedBookmarkDelegate?
    private let defaults = UserDefaults.standard
    
    private var isEditModeEnable: Bool = false
    private let bookmarkController =  BookmarkController()
    private var bookmarkArray: [Bookmark]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UIBarButtonItem!
    
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        loadBookmarks()
        //set title
        titleLabel.title = folder?.title
    }
    
    //MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        //Use to clear the last selected folder
        defaults.set(-1, forKey: "lastSelectedRow")
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        toggleEditMode()
    }
    
    //MARK: - Private Methods
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadBookmarks() {
        if let bookmarks = folder?.bookmarks, let data = bookmarks.allObjects as? [Bookmark]{
            bookmarkArray = data
        }
    }

    private func toggleEditMode() {
        isEditModeEnable.toggle()
        if isEditModeEnable{
            editButton.title = "Done"
            cancelButton.isEnabled = false
            tableView.setEditing(true, animated: true)
        }else{
            editButton.title = "Edit"
            cancelButton.isEnabled = true
            tableView.setEditing(false, animated: true)
        }
    }
}

//MARK: - UITableViewDelegate
extension FolderDetailViewController: UITableViewDelegate{
    
}

//MARK: - UITableViewDataSource
extension FolderDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder?.bookmarks?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath)
        
        if let bookmarkArray = bookmarkArray {
            let bookmark = bookmarkArray[indexPath.row]
            cell.textLabel?.text = bookmark.title
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let bookmarkArray = bookmarkArray, let selectedURL = bookmarkArray[indexPath.row].url{
            delegate?.loadSelectedURL(url: selectedURL)
            //Dismiss the two viewcontrollers currently on the top
            presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let bookmarkArray = bookmarkArray{
                let item = bookmarkArray[indexPath.row]
                bookmarkController.delete(item)
                tableView.deleteRows(at: [indexPath], with: .fade)
                loadBookmarks()
            }
        }
    }
    
}
