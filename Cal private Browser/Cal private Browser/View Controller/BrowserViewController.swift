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
    private var homePage: String?
    private let notification = NotificationCenter.default
 

    
    //MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var sideNavButtonView: UIView!
    @IBOutlet weak var forwardDragButton: UIButton!
    @IBOutlet weak var backDragButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        
        setupUI()
        loadHomePage()
        updateViews()
        
        setupObservers()
        setupNotifications()
        //Set the last selected folder to none or -1 to prevent the app from crashing on the first run
        //Because otherwise it would look for index 0 which does not exist
        UserDefaults.standard.set(-1, forKey: "lastSelectedRow")
    }
    
    deinit {
        observation = nil
    }
    
    //MARK: - Actions
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIBarButtonItem) {
        webView.goForward()
        searchBar.text = webView.url?.absoluteString
    }
    
    @IBAction func bookmarkButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func terminateSession(_ sender: UIBarButtonItem) {
        cleanData()
        
        //Add taptic feedback when the lock button is pressed
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
    }
    
    @IBAction func backOptionalButton(_ sender: UIButton) {
        goBack()
        
    }
    
    @IBAction func forwardOptinalButton(_ sender: UIButton) {
        webView.goForward()
    }
    
    @IBAction func scrollUp(_ sender: UIButton) {

        UIView.animate(withDuration: 0.4) {
            //self.webView.evaluateJavaScript("window.scrollTo({top: 0, behavior: 'smooth'})", completionHandler: nil)
            self.webView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
        
    }
    
    
    //MARK: - Private Methods
    private func setupDelegates(){
        searchBar.delegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
    }
    
    private func setupUI(){
        
        sideNavButtonView.layer.cornerRadius = 15
        sideNavButtonView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        errorLabel.isHidden = true
        
        webView.allowsBackForwardNavigationGestures = true
        
        searchBar.showsBookmarkButton = true
        
    }
    
    private func updateViews() {
        
        backButton.isEnabled = webView.canGoBack
        backDragButton.isEnabled = webView.canGoBack
        
        forwardButton.isEnabled = webView.canGoForward
        forwardDragButton.isEnabled = webView.canGoForward
        searchBar.autocapitalizationType = .none
        
    }
    
    private func loadHomePage() {
        //TODO: Add user defaults to save
        homePage = "http://www.google.com"
        webView.load(URLRequest(url: URL(string: homePage!)!))
    }
    
    private func fullScreen(_ isEnable: Bool) {
        self.searchBar.isHidden = isEnable
        self.toolBar.isHidden = isEnable

        if isEnable{
            webView.frame = self.view.frame
        }
    }
    
    func goBack() {
        webView.evaluateJavaScript("window.removeEventListener('beforeunload")
        webView.stopLoading()
        webView.goBack()
        searchBar.text = webView.url?.absoluteString
    }
    
    @objc private func appEnterBackground(){
        //Clear all cookies
        cleanData()
    }
    
    private func cleanData() {
        //Clear last selected folder
        UserDefaults.standard.set(-1, forKey: "lastSelectedRow")
        
        navigationController?.popViewController(animated: true)
        
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        //print("[WebCacheCleaner] All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                //print("[WebCacheCleaner] Record \(record) deleted")
            }
        }
       }
    
    private func setupObservers(){
        //add observer to get estimated progress value
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
    }
    
    private func setupNotifications(){
        //Check if app will resign to go to homepage so no unwanted previews show on relaunch
        notification.addObserver(self, selector: #selector(appEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func sanitizeURLString(urlString: String) {
        
        var sanitizedURL: String = ""
        
        if urlString.hasPrefix("http://"){
            sanitizedURL = urlString
        }else if urlString.hasPrefix("www."){
            sanitizedURL = "http://\(urlString)"
        }else if urlString.contains("."){
            sanitizedURL = "http://www.\(urlString)"
        }else{
            //Create a google query
            let cleanQuery = urlString.replacingOccurrences(of: " ", with: "+")
            sanitizedURL =  "http://www.google.com/search?q=\(cleanQuery)"
        }
        
        if let url = URL(string: sanitizedURL){
            webView.load(URLRequest(url: url))
        }else{
            //TODO: Error handleling
            print("URL could not be loaded!")
        }
    }
    
    private func displayError(shouldShow: Bool){
        webView.isHidden = shouldShow
        errorLabel.isHidden = !shouldShow
        
    }

    //MARK: - General overwrite methods
    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.progress = Float(self.webView.estimatedProgress);
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookmarkSegue"{
            if let bookmarkVC = segue.destination as?
                BookmarkViewController{
                guard let webData = webView, let title = webData.title, let url = webData.url else {return}
                bookmarkVC.bookmark = (title: title, url: url.absoluteURL)
                bookmarkVC.browserVC = self
            }
        }
    }
    
}

//MARK: - UISearchBarDelegate
extension BrowserViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        if let urlString = searchBar.text, !urlString.isEmpty {
            sanitizeURLString(urlString: urlString)
        }
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if webView.isLoading{
            webView.stopLoading()
            progressView.isHidden = true
        }else{
            webView.reload()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        webView.stopLoading()
        searchBar.resignFirstResponder()
    }
}


//MARK: - WKNavigationDelegate
extension BrowserViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        fullScreen(false)
        //Set searchbar text to the current url
        searchBar.text = webView.url?.absoluteString
        progressView.isHidden = !webView.isLoading
        
         searchBar.setImage(UIImage(systemName: webView.isLoading ? "xmark" : "arrow.counterclockwise"), for: .bookmark, state: .normal)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateViews()
        progressView.isHidden = !webView.isLoading
        //Handle internet connection errors
        displayError(shouldShow: false)
        searchBar.setImage(UIImage(systemName: webView.isLoading ? "xmark" : "arrow.counterclockwise"), for: .bookmark, state: .normal)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        
        if navigationAction.navigationType == .linkActivated{
            //When user click on a link
            webView.load(URLRequest(url: url))
            decisionHandler(.allow)
        }else{
            //When user explicitly types an URL
            decisionHandler(.allow)
        }
    }
    
    //TODO:Handle internet connection errors
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let errorDesc = error.localizedDescription.description
        if errorDesc != ""{
            displayError(shouldShow: true)
            errorLabel.text = errorDesc
            print("Connection Error: \(errorDesc)")
        }
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

extension BrowserViewController: SelectedBookmarkDelegate{
    func loadSelectedURL(url: URL) {
        webView.load(URLRequest(url: url))
    }

}
