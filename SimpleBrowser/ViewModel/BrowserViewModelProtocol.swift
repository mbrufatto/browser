//
//  BrowserViewModelProtocol.swift
//  SimpleBrowser
//
//  Created by Marcio Habigzang Brufatto on 26/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import Foundation

protocol BrowserViewModelProtocol {
    
    func addWebSite(_ webSite: String)
    func retrieveWebSites() -> [String]
    func retrieveWebSite(_ index: Int) -> String
}
