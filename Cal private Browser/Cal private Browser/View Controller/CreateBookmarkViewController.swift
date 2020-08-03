//
//  CreateBookmarkViewController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/27/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit

class CreateBookmarkViewController: UIViewController {
    
    //MARK: - Properties
    var newBookmarkData: (title: String, url: URL)?
    var bookmarkController: BookmarkController?
    
    //private var folderName: Folder?
    private var folderArray: [Folder]?
    private var didSaveChanges = false
    
     //MARK: - Outlets
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var urlLabel: UITextField!
    @IBOutlet weak var folderPicker: UIPickerView!
    @IBOutlet weak var toolbarTitle: UIBarButtonItem!
    

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFolders()
        updateViews()
        folderPicker.delegate = self
        folderPicker.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //In case the use dimiss the view manualy without saving changes
        //This prevent a new folder from being create in a situation were no folders exist and the user enters the viewcontroller to save a bookmark which will automallycaly create a "new folder" but it will reset context if the user dimiss the view without pressing cancel or save
        if !didSaveChanges{
            bookmarkController?.resetContext()
        }
    }
    
    //MARK: - Private Methods
    private func updateViews() {
        if folderArray!.count < 1{
            folderArray?.append(Folder(title: "New Folder"))//If no folders exist create one
        }
        //preselect first folder
        folderPicker.selectRow(0, inComponent: 0, animated: true)
        //automatically fillout all fields
        titleLabel.text = newBookmarkData?.title
        urlLabel.text = newBookmarkData?.url.absoluteString
        toolbarTitle.title = "New Bookmark"
    }
    
    private func loadFolders()  {
        bookmarkController?.loadFoldersFromPersistentStore(completion: { (data, error) in
            self.folderArray = data
        })
    }
    
   //MARK: - Action
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        //TODO: if new folder mode enable create a folder else create a bookmark
        guard let title = titleLabel.text, !title.isEmpty else{
            titleLabel.attributedPlaceholder = NSAttributedString(string: "Please specify a title.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        didSaveChanges = true
        //create bookmark
        let selectedFolderIndex = folderPicker.selectedRow(inComponent: 0)//Index of selected folder
        
        if let urlString = urlLabel.text, let url = URL(string: urlString),let folderArray = folderArray {
            //TODO:Check if a folder is selected if not default to folder at index 0
            let folderName = folderArray[selectedFolderIndex]
            bookmarkController?.saveBookmark(title: title, url: url, folder: folderName)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        bookmarkController?.resetContext()
        dismiss(animated: true, completion: nil)
    }
}

    //MARK: - UIPickerViewDelegate

extension CreateBookmarkViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let folders = folderArray else { return "" }
        let title = folders[row].title
        return title
    }
}


//MARK: - UIPickerViewDataSource

extension CreateBookmarkViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return folderArray?.count ?? 1
    }
}
