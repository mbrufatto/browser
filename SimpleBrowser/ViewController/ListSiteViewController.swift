//
//  ListSiteViewController.swift
//  SimpleBrowser
//
//  Created by Marcio Habigzang Brufatto on 26/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import UIKit

protocol ListSiteViewControllerDelegate {
    func didSelecetWebSite(website: String)
}

class ListSiteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var browserViewModel: BrowserViewModelProtocol?
    
    var delegate: ListSiteViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ListSiteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if browserViewModel!.retrieveWebSites().count > 0{
            return browserViewModel!.retrieveWebSites().count
        }
        
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        noDataLabel.text = "There is no website in your history"
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.center
        self.tableView.backgroundView = noDataLabel
        self.tableView.separatorStyle = .none
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = browserViewModel?.retrieveWebSite(indexPath.row)
        
        return cell
    }
}

extension ListSiteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        delegate?.didSelecetWebSite(website: (browserViewModel?.retrieveWebSite(indexPath.row))!)
    }
}

