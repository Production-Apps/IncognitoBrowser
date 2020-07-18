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
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        updateViews()
        loadHomePage()
        observePageLoadProgress()
        webView.scrollView.delegate = self
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
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        webView.reload()
        updateViews()
    }
    
    @IBAction func terminateSession(_ sender: UIBarButtonItem) {
        //TODO: Take user back to calculator view
    }
    
    
    //MARK: - Private Methods
    private func updateViews() {
        
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        
        searchBar.autocapitalizationType = .none
        
    }
    
    private func loadHomePage() {
        //TODO: Add user defaults to save 
        let homePageURL = URL(string: "http://www.fritzgt.com")!
        let request = URLRequest(url: homePageURL)
        webView.load(request)
    }
    
    private func observePageLoadProgress() {
        observation = webView.observe(\.estimatedProgress, options: [.new]) { _, _ in
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    
    private func fullScreen(_ isEnable: Bool) {
        searchBar.isHidden = isEnable
        refreshButton.isHidden = isEnable
        toolBar.isHidden = isEnable
        
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


extension BrowserViewController: UIScrollViewDelegate{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if(position > 200){
            fullScreen(true)
        }else if (position < 50 ){
            fullScreen(false)
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        fullScreen(false)
    }
}
