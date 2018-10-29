//
//  BaseTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Jiri Ostatnicky on 29/10/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNoTitleBackButton()
    }
    
    func setupNoTitleBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
