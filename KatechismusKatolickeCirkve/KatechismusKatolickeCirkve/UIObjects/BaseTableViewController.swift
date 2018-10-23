//
//  BaseTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 23/10/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewController: UITableViewController {
    
    fileprivate var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }
    
    @objc func darkModeEnabled(_ notification: Notification) {
        enableDarkMode()
        self.tableView.reloadData()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        disableDarkMode()
        self.tableView.reloadData()
    }
    
    open func enableDarkMode() {
        self.view.backgroundColor = UIColor.black
        self.tableView.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.view.backgroundColor = UIColor.black
    }
    
    open func disableDarkMode() {
        self.view.backgroundColor = UIColor.white
        self.tableView.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.view.backgroundColor = UIColor.white
    }
    
    /*override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.darkMode {
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.textColor = UIColor.lightGray
            cell.backgroundColor = UIColor.black
            
            cell.setSelectedColor(color: UIColor.darkBackground)
        } else {
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.lightGray
            cell.backgroundColor = UIColor.white
            
            cell.setSelectedColor(color: UIColor.lightBackground)
        }
    }
 */
 
}
