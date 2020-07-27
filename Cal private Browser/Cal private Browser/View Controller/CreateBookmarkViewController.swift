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
    var bookmark: (title: String, url: URL)?
    var newFolderMode = false
    private var folders: [Folder]?
    
     //MARK: - Outlets
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var urlLabel: UITextField!
    @IBOutlet weak var folderPicker: UIPickerView!
    

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
        }else{
            titleLabel.text = bookmark?.title
            urlLabel.text = bookmark?.url.absoluteString
        }
    }
    
    
   //MARK: - Action
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        //TODO: if new folder mode enable create a folder else create abookmark
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

    //MARK: - UIPickerViewDelegate
extension CreateBookmarkViewController: UIPickerViewDelegate{
    
}
