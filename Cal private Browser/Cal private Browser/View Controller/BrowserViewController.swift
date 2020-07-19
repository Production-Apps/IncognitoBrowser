//
//  ViewController.swift
//  Cal private Browser
//
//  Created by FGT MAC on 7/16/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {
    
    //MARK: - Properties
    private var observation: NSKeyValueObservation?
    
    //MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        
        webView.allowsBackForwardNavigationGestures = true
        
        updateViews()
        loadHomePage()
        observePageLoadProgress()
        
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .bookmark, state: .normal)
    }
    
    deinit {
        observation = nil
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
    
    @IBAction func terminateSession(_ sender: UIBarButtonItem) {
        //TODO: Take user back to calculator view
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Private Methods
    private func updateViews() {
        
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        
        searchBar.autocapitalizationType = .none
        
    }
    
    private func loadHomePage() {
        //TODO: Add user defaults to save
        let homePageString = "fritzgt.com"
        let homePageURL = URL(string: "http://www.\(homePageString)")!
        let request = URLRequest(url: homePageURL)
        searchBar.text = homePageString
        webView.load(request)
    }
    
    private func observePageLoadProgress() {
        observation = webView.observe(\.estimatedProgress, options: [.new]) { _, _ in
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    
//    func observeAppEnterBackground()  {
//        NotificationCenter.default.addObserver(self, selector: #selector("appBecomeActive"), name: NSNotification.Name.UIApplication.willEnterForegroundNotification, object: nil )
//
//    }
//    
//     func appBecomeActive() {
//        print("background")
//    }
    
    private func fullScreen(_ isEnable: Bool) {
        
        self.searchBar.isHidden = isEnable
        self.toolBar.isHidden = isEnable
        if isEnable{
            webView.frame = self.view.frame

        }
    }
    
}

//MARK: - UISearchBarDelegate
extension BrowserViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        if let urlString = searchBar.text, !urlString.isEmpty {
            
            if let url = URL(string: "http://www.\(urlString)"){
                //TODO: Check if url starts with http:// or https:// if not then add it to the string
                webView.load(URLRequest(url: url))
            }else{
                //TODO: Error handleling
                print("URL could not be loaded!")
            }
        }
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        webView.reload()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


//MARK: - WKNavigationDelegate
extension BrowserViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if isViewLoaded{
            progressView.isHidden = false
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateViews()
        progressView.isHidden = true
    }
    
}


//MARK: - UIScrollViewDelegate
extension BrowserViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentContentOffset = Int(scrollView.contentOffset.y)
        
        if(currentContentOffset > 50){
            fullScreen(true)
        }else if (currentContentOffset < 10 ){
            fullScreen(false)
        }
    }
}
