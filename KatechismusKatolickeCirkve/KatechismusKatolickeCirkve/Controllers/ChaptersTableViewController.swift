//
//  ChaptersTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 08/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class ChaptersTableViewController: UITableViewController {

    struct ChapterRowData {
        var order = Int()
        var name = String()
        var sub_name = String()
    }

    fileprivate var rowData = [ChapterRowData]()
    fileprivate var chaptersStructure: ChaptersStructure?
    var darkMode: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ChaptersTableViewCell.self, forCellReuseIdentifier: ChaptersTableViewCell.cellId)
        chaptersStructure = ChaptersDataService.shared.chaptersStructure
        self.navigationItem.title = "Procházet kapitoly"
        loadChapters()
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        self.tableView.tableFooterView = UIView()
        if self.darkMode {
            self.tableView.backgroundColor = KKCBackgroundNightMode
        } else {
            self.tableView.backgroundColor = KKCBackgroundLightMode
        }
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadChapters() {
        guard let chaptersStructure = chaptersStructure else { return }
        for chap in chaptersStructure.chapters {
            if chap.parent == 0 {
                rowData.append(ChapterRowData(order: chap.id, name: chap.name))
            }
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

extension ChaptersTableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: ChaptersTableViewCell.cellId, for: indexPath) as! ChaptersTableViewCell
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        //cell.configureCell(name: rowData[indexPath.row].name, description: "")
        cell.textLabel?.text = rowData[indexPath.row].name
        cell.detailTextLabel?.text = rowData[indexPath.row].sub_name
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if rowData[indexPath.row].order != 1 && rowData[indexPath.row].order != 2 && rowData[indexPath.row].order != 3 {
            let sectionsTableViewController = SectionsTableViewController()
            let parentNumber = rowData[indexPath.row].order
            if parentNumber != 0 {
                sectionsTableViewController.parentID = parentNumber
                sectionsTableViewController.navigationItem.title = rowData[indexPath.row].name
            }
            navigationController?.pushViewController(sectionsTableViewController, animated: true)
        } else {
            print(rowData[indexPath.row])
            let pcvc = ParagraphTableViewController()
            let parentNumber = rowData[indexPath.row].order
            pcvc.parentID = parentNumber
            navigationController?.pushViewController(pcvc, animated: true)
        }
    }

}
