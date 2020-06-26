//
//  BrowserViewController.swift
//  SimpleBrowser
//
//  Created by Marcio Habigzang Brufatto on 26/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {
    
    @IBOutlet weak var urlAddress: UISearchBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    private var webView: WKWebView!
    private var backButton: UIBarButtonItem?
    private var forwardButton: UIBarButtonItem?
    private var progressBar: UIProgressView?
    private var browserViewModel: BrowserViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        addProgressBar()
        addAnchor()
    }
    
    private func initialSetup() {
        browserViewModel = BrowserViewModel()
        webView = WKWebView()
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        urlAddress.delegate = self
        
        let urlString = "https://www.apple.com.br"
        self.urlAddress.text = urlString
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        let backButton = UIBarButtonItem(
                    image: UIImage(systemName: "arrow.left")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
                    style: .plain,
                    target: self.webView,
                    action: #selector(WKWebView.goBack))
        
        let forwardButton = UIBarButtonItem(
                    image: UIImage(systemName: "arrow.right")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
                    style: .plain,
                    target: self.webView,
                    action: #selector(WKWebView.goForward))
        
        let historyButton = UIBarButtonItem(
                    image: UIImage(systemName: "book")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
                    style: .plain,
                    target: self,
                    action: #selector(openHistory))
        
        let reloadButton = UIBarButtonItem(
                    image: UIImage(systemName: "arrow.counterclockwise")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
                    style: .plain,
                    target: self.webView,
                    action: #selector(WKWebView.reload))
        
        self.toolBar.items = [backButton, forwardButton,
                             UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                             historyButton,
                             reloadButton
        ]
        
        self.backButton = backButton
        self.forwardButton = forwardButton
        
        self.backButton?.isEnabled = self.webView.canGoBack
        self.forwardButton?.isEnabled = self.webView.canGoForward
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
    }

    private func addAnchor() {
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.progressBar!.topAnchor.constraint(equalTo: self.urlAddress.bottomAnchor),
            self.progressBar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.progressBar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.webView.topAnchor.constraint(equalTo: self.progressBar!.bottomAnchor),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.toolBar.topAnchor),
        ])
    }
    
    private func addProgressBar() {
        let progressView = UIProgressView(progressViewStyle: .default)
        self.progressBar = progressView
        self.view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(0.0, animated: true)
        progressView.sizeToFit()

        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    @objc private func openHistory() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "ListSiteViewController") as! ListSiteViewController
        destination.browserViewModel = self.browserViewModel
        self.present(destination, animated: true)
    }
    
    //MARK: Observers
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "canGoBack" {
            self.backButton?.isEnabled = self.webView.canGoBack
        } else if keyPath == "canGoForward" {
            self.forwardButton?.isEnabled = self.webView.canGoForward
        } else if keyPath == "estimatedProgress", let progressView = self.progressBar {
            let newProgress = self.webView.estimatedProgress
            if Float(newProgress) > progressView.progress {
                progressView.setProgress(Float(newProgress), animated: true)
            } else {
                progressView.setProgress(Float(newProgress), animated: false)
            }
            if newProgress >= 1 {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                    progressView.isHidden = true
                })
            } else {
                progressView.isHidden = false
            }
        }
    }
}

extension BrowserViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        self.urlAddress.text = webView.url?.absoluteString
    }
}

extension BrowserViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let url = URL(string: "https://" + searchBar.text!) else { return }
        self.webView.load(URLRequest(url: url))
        
        guard let browserModel = browserViewModel else { return }
        browserModel.addWebSite(url.absoluteString)
    }
}
