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
    var bookmark: Bookmark?//Coming from tableview
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
    }
    
    
   //MARK: - Action
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

    //MARK: - UIPickerViewDelegate
extension CreateBookmarkViewController: UIPickerViewDelegate{
    
}
