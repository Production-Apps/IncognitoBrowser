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
    private let bookmarkController =  BookmarkController()
    private var bookmarkArray: [Bookmark]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        fetchBookmarks()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        tableView.isEditing.toggle()
    }
    
    //MARK: - Private Methods
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchBookmarks(){
        bookmarkController.loadBookmarksFromPersistentStore { (data, error) in
            if let error = error {
                print("Error loading bookmarks \(error)")
            }
            
            if let data = data{
                self.bookmarkArray = data
                self.tableView.reloadData()
            }
        }
    }

}

//MARK: - UITableViewDelegate
extension FolderDetailViewController: UITableViewDelegate{
    
}

//MARK: - UITableViewDataSource
extension FolderDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath)
        
        if let bookmarkArray = bookmarkArray {
            let data = bookmarkArray[indexPath.row]
            //TODO: Create logic to show only bookmarks from the selected folder
            cell.textLabel?.text = data.title
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bookmarkArray = bookmarkArray, let selectedURL = bookmarkArray[indexPath.row].url{
            delegate?.loadSelectedURL(url: selectedURL)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //delete logic
        }
    }
    
}