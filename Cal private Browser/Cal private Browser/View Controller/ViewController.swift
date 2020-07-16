//
//  ViewController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/16/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    
    //MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        updateViews()
        loadHomePage()
    }
    
    //MARK: - Actions
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func bookmarkButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        webView.reload()
        updateViews()
    }
    
    @IBAction func terminateSession(_ sender: UIBarButtonItem) {
        //TODO: Take user back to calculator view
    }
    
    
    //MARK: - Private Methods
    func updateViews() {
        
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        
    }
    
    func loadHomePage() {
        //TODO: Add user defaults to save 
        let homePageURL = URL(string: "https://www.google.com")!
        let request = URLRequest(url: homePageURL)
        webView.load(request)
    }

}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let url = URL(string: "http://www.\(searchBar.text!)"){
            //TODO: Check if url starts with http:// or https:// if not then add it to the string
            webView.load(URLRequest(url: url))
        }else{
            //TODO: Error handleling
            print("URL could not be loaded!")
        }
    }
}


//MARK: - WKNavigationDelegate
extension ViewController: WKUIDelegate {
    
}

extension ViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if isViewLoaded{
            activityIndicator.startAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateViews()
        activityIndicator.stopAnimating()
    }
}
