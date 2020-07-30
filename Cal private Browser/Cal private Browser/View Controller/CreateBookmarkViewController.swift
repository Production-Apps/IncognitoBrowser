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
    var folders: [Folder]?
    var bookmarkController: BookmarkController?
    var bookmark: (title: String, url: URL)?
    var newFolderMode = false
    
    private var folderName: Folder?
    
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
        folderPicker.dataSource = self
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
            if let urlString = urlLabel.text, let url = URL(string: urlString),let folderName = folderName {
                bookmarkController?.saveBookmark(title: title, url: url, folder: folderName)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

    //MARK: - UIPickerViewDelegate

extension CreateBookmarkViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let folders = folders else { return "" }
        let data = folders[row]
        return data.title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let folders = folders else { return }
        folderName = folders[row]
    }
}


//MARK: - UIPickerViewDataSource

extension CreateBookmarkViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return folders?.count ?? 1
    }
}
