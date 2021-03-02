//
//  NumbersTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 09/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class NumbersTableViewController: UITableViewController {

    fileprivate var diff = 500
    fileprivate var beginNumber = 1
    fileprivate var endNumber = 2865

    struct NumbersRowData {
        var number : Int
        var text: String
    }
    
    fileprivate var numbersRowData = [NumbersRowData]()
    var darkMode: Bool = false
    let maxParagraph: Int = 2865
    let lastSection: Int = 2501
    let keys = SettingsBundleHelper.SettingsBundleKeys.self

    override func viewDidLoad() {
        super.viewDidLoad()
        initNumbers()
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        if self.darkMode == true {
            self.tableView.backgroundColor = KKCBackgroundNightMode
        } else {
            self.tableView.backgroundColor = KKCBackgroundLightMode
        }
        
        tableView.register(NumbersTableViewCell.self, forCellReuseIdentifier: NumbersTableViewCell.cellId)
        tableView.contentInset = UIEdgeInsets(top:8, left: 8, bottom: 8, right: 8)
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 60
        self.navigationItem.title = "Vyhledávat podle čísel"
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private func addRow() {
        if beginNumber == lastSection {
            endNumber = maxParagraph
        }
        else {
            endNumber = beginNumber + diff - 1
        }
        let text_for_disp: String = ("\(beginNumber)-\(endNumber)")
        numbersRowData.append(NumbersRowData(number: beginNumber, text: text_for_disp))

    }
    private func initNumbers() {
        let count = endNumber / diff + 1
        for _ in 1...count {
            addRow()
            beginNumber += diff
        }
    }
    @objc private func darkModeEnabled(_ notification: Notification) {
        self.darkMode = true
        self.tableView.backgroundColor = KKCBackgroundNightMode
        self.tableView.reloadData()
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        self.darkMode = false
        self.tableView.backgroundColor = KKCBackgroundLightMode
        self.tableView.reloadData()
    }
}

extension NumbersTableViewController {
  
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbersRowData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NumbersTableViewCell.cellId, for: indexPath) as! NumbersTableViewCell
        let data = numbersRowData[indexPath.row]
        print(data)
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        if self.darkMode == true {
            cell.backgroundColor = KKCBackgroundNightMode
        } else {
            cell.backgroundColor = KKCBackgroundLightMode
        }
        cell.configureCell(number: numbersRowData[indexPath.row].text)
        cell.accessoryType = .disclosureIndicator
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let numbersDetailTableViewController = NumbersDetailTableViewController()
        let parentNumber = numbersRowData[indexPath.row].number
        numbersDetailTableViewController.beginNumber = parentNumber
        var endNumber: Int = 0
        if parentNumber == lastSection {
            endNumber = maxParagraph
        }
        else {
            endNumber = parentNumber + diff - 1
        }
        numbersDetailTableViewController.endNumber = endNumber
        navigationController?.pushViewController(numbersDetailTableViewController, animated: true)
    }
}
