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
    private var dragViewOrigin: CGPoint?
    
    //MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var dragButtonView: UIView!
    @IBOutlet weak var dragButton: UIButton!
    @IBOutlet weak var forwardDragButton: UIButton!
    @IBOutlet weak var backDragButton: UIButton!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        
        setupUI()
        updateViews()
        loadHomePage()
        
        setupObservers()
        setupNotifications()
    }
    
    deinit {
        observation = nil
    }
    
    //MARK: - Actions
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        webView.goBack()
        searchBar.text = webView.url?.absoluteString
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIBarButtonItem) {
        webView.goForward()
        searchBar.text = webView.url?.absoluteString
    }
    
    @IBAction func bookmarkButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func terminateSession(_ sender: UIBarButtonItem) {
        cleanData()
    }
    
    @IBAction func dragGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        
        if let viewToDrag = sender.view{
            viewToDrag.center = CGPoint(x: viewToDrag.center.x + translation.x, y: viewToDrag.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: dragButtonView)
            
            if sender.state == .ended{
                dragViewOrigin = viewToDrag.center
                print("Save origin \(dragViewOrigin!)")
            }
        }
        
        
    }
    
    @IBAction func showDragButtons(_ sender: UIButton) {
        forwardDragButton.isHidden.toggle()
        forwardDragButton.isEnabled = webView.canGoForward
        
        backDragButton.isHidden.toggle()
        backDragButton.isEnabled = webView.canGoBack
        
        
    }
    
    @IBAction func backDragButton(_ sender: UIButton) {
        webView.goBack()
        forwardDragButton.isHidden = true
        backDragButton.isHidden = true
    }
    
    @IBAction func forwardDragButton(_ sender: Any) {
        webView.goForward()
        forwardDragButton.isHidden = true
        backDragButton.isHidden = true
    }
    
    
    
    //MARK: - Private Methods
    private func setupDelegates(){
        searchBar.delegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
    }
    
    private func setupUI(){
        view.bringSubviewToFront(dragButtonView)
        
        forwardDragButton.isHidden = true
        backDragButton.isHidden = true
        
        webView.allowsBackForwardNavigationGestures = true
        
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .bookmark, state: .normal)
    }
    
    private func setupPanGestures(view: UIView){
        //TODO: Position at the middle of the screen
//        dragButtonView.frame =  self.view.center
        
        self.view.bringSubviewToFront(dragButtonView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector( BrowserViewController.handlePanGesture(sender:)))
        dragButtonView.isUserInteractionEnabled = true
        view.addGestureRecognizer(pan)
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer){
        
        let dragView = sender.view!
        let translation = sender.translation(in: self.view)
        
        switch sender.state {
        case .began, .changed:
            dragView.center = CGPoint(x: dragView.center.x + translation.x, y: dragView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
        case .ended:
            //Save the last position to user defaults to always start at the last position
            break
        default:
            break
        }
    }
    
    private func updateViews() {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        searchBar.autocapitalizationType = .none
        
    }
    
    private func loadHomePage() {
        //TODO: Add user defaults to save
        homePage = "http://www.fritzgt.com"
        webView.load(URLRequest(url: URL(string: homePage!)!))
    }
    
    private func fullScreen(_ isEnable: Bool) {
        self.searchBar.isHidden = isEnable
        self.toolBar.isHidden = isEnable
        if isEnable{
            webView.frame = self.view.frame
        }
    }
    
    @objc private func appEnterBackground(){
        //Clear all cookies
        cleanData()
    }
    
    private func cleanData() {
        navigationController?.popViewController(animated: true)
        
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("[WebCacheCleaner] All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[WebCacheCleaner] Record \(record) deleted")
            }
        }
       }
    
    private func setupObservers(){
        //add observer to get estimated progress value
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
    }
    
    private func setupNotifications(){
        //Check if app will resign to go to homepage so no unwanted previews show on relaunch
        notification.addObserver(self, selector: #selector(appEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
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
                //bookmarkVC.delegate = self
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
        fullScreen(false)
        progressView.isHidden = !webView.isLoading
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateViews()
        progressView.isHidden = !webView.isLoading
        //Set searchbar text to the current url
        searchBar.text = webView.url?.absoluteString
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        if navigationAction.navigationType == .linkActivated{
            webView.load(URLRequest(url: url))
            decisionHandler(.allow)
        }else{
            decisionHandler(.allow)
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
