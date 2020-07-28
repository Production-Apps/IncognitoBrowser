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
    var bookmarkController: BookmarkController?
    var bookmark: (title: String, url: URL)?
    var newFolderMode = false
    private var folders: [Folder]?
    
     //MARK: - Outlets
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var urlLabel: UITextField!
    @IBOutlet weak var folderPicker: UIPickerView!
    @IBOutlet weak var toolbarTitle: UIBarButtonItem!
    

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        folderPicker.delegate = self
        updateViews()
    }
    
    //MARK: - Private Methods
    private func updateViews() {
        if newFolderMode{
            titleLabel.placeholder = "Enter New Folder"
            urlLabel.isHidden = true
            folderPicker.isHidden = true
            toolbarTitle.title = "New Folder"
        }else{
            titleLabel.text = bookmark?.title
            urlLabel.text = bookmark?.url.absoluteString
            toolbarTitle.title = "New Bookmark"
        }
    }
    
    
   //MARK: - Action
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        //TODO: if new folder mode enable create a folder else create abookmark
        guard let title = titleLabel.text else{return}
        if newFolderMode{
            //create folder
            bookmarkController?.saveFolder(title: title)
        }else{
            //create bookmark
            if let urlString = urlLabel.text, let url = URL(string: urlString){
                
                bookmarkController?.saveBookmark(title: title, url: url, folder: "")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        //TODO: Reset Manage object context
    }
}

    //MARK: - UIPickerViewDelegate
extension CreateBookmarkViewController: UIPickerViewDelegate{
    //Setup picker
}
