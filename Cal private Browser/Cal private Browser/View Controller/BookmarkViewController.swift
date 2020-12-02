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
    private var isEditModeEnable: Bool = false
   
    private let defaults = UserDefaults.standard
    
    var bookmark: (title: String, url: URL)?
    var browserVC: BrowserViewController?//Use to set as delegate to load web url when bookmark is selected
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        bookmarkController.delegate = self
        fetchFolders()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let lastSelectedRow = defaults.integer(forKey: "lastSelectedRow")
        print("lastSelectedRow: ", lastSelectedRow)
        
        if lastSelectedRow >= 0{
           //performSegue(withIdentifier: "FolderDetailSegue", sender: nil)
          
        }

    }
    
    //MARK: - Actions
    
    @IBAction func editMode(_ sender: UIBarButtonItem) {
        toggleEditMode()
    }
    
    @IBAction func NewFolderButton(_ sender: UIBarButtonItem) {
        manageFolder(for: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    private func toggleEditMode() {
        isEditModeEnable.toggle()
        
        if isEditModeEnable{
            editButton.title = "Done"
            tableView.setEditing(true, animated: true)
        }else{
            editButton.title = "Edit"
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
    
    private func manageFolder(for folder: Folder?){
        
        
        let alert = UIAlertController(title: folder != nil ? "Rename Folder" : "New Folder" , message: "Enter title below", preferredStyle: .alert)
        var titleTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.text = folder?.title//Set the title to current title
            textField.placeholder = "Please enter a title"
            textField.autocapitalizationType = .words
            titleTextField = textField
        }
        
        let setTitleAction =  UIAlertAction(title: "Save", style: .default) { (_) in
            
            guard let titleTextField = titleTextField,let title = titleTextField.text, !title.isEmpty else {return}
            
            //Save the title to context
            if let folder = folder{
                self.bookmarkController.updateFolder(title: title, folder: folder)
            }else{
                self.bookmarkController.saveFolder(title: title)
            }
            
            //Reload tableview
            self.tableView.reloadData()
        }
        
        let addCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(setTitleAction)
        alert.addAction(addCancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Overwrite methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewBMSegue"{
            if let createBookmarkVC = segue.destination as? CreateBookmarkViewController{
                createBookmarkVC.newBookmarkData = bookmark
                //Pass incetance to be delegate
                createBookmarkVC.bookmarkController = bookmarkController
            }
        }else if segue.identifier == "FolderDetailSegue"{
            if let detailVC = segue.destination as? FolderDetailViewController{
                guard let folders = folderArray, let indexPath = tableView.indexPathForSelectedRow, let browserVC = browserVC else { return }
                
                let selectedFolder = folders[indexPath.row]
                detailVC.folder = selectedFolder
                //Pass the incetance of browserVC as delegate to load the selected URL
                detailVC.delegate = browserVC
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //Prevent segue if editing is true and you click on a folder, so instead you can rename a folder
        if tableView.isEditing && identifier == "FolderDetailSegue"{
            return false
        }
        return true
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditModeEnable{
            //Show alert to with current folder name to rename folder
            guard let folderArray = folderArray else {return}
            let selectedFolder = folderArray[indexPath.row]
            manageFolder(for: selectedFolder)
        }
        
 
        defaults.set(indexPath.row, forKey: "lastSelectedRow")

    }
}


extension BookmarkViewController: CreateBookmarkDelegate{
    func stateDidChange() {
        fetchFolders()
    }
}
