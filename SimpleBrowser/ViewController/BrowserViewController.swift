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
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        addWebView()
    }
    
    private func initialSetup() {
        webView = WKWebView()
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        let urlString = "https://www.apple.com.br"
        self.urlAddress.text = urlString
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    private func addWebView() {
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.urlAddress.bottomAnchor),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.toolBar.topAnchor)
        ])
    }
}

extension BrowserViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        self.urlAddress.text = webView.url?.absoluteString
    }
}
