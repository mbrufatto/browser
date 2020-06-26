//
//  BrowserViewModel.swift
//  SimpleBrowser
//
//  Created by Marcio Habigzang Brufatto on 26/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import Foundation

class BrowserViewModel: BrowserViewModelProtocol {
    
    private var webSites: [String] = []
    
    func addWebSite(_ webSite: String) {
        if !webSites.contains(webSite) {
            webSites.append(webSite)
        }
    }
    
    func retrieveWebSites() -> [String] {
        return webSites
    }
    
    func retrieveWebSite(_ index: Int) -> String {
        return webSites[index]
    }
}
