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
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    var darkMode: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ChaptersTableViewCell.self, forCellReuseIdentifier: ChaptersTableViewCell.cellId)
        chaptersStructure = ChaptersDataService.shared.chaptersStructure
        self.navigationItem.title = "Procházet kapitoly"
        loadChapters()
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        if self.darkMode {
            self.tableView.backgroundColor = KKCBackgroundNightMode
        } else {
            self.tableView.backgroundColor = KKCBackgroundLightMode
        }
        self.tableView.tableFooterView = UIView()
        navigationItem.backBarButtonItem?.title = "Zpět"
        navigationController?.navigationBar.backItem?.backBarButtonItem = UIBarButtonItem(title: "Zpět", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.barStyle = UIBarStyle.black;

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    private func loadChapters() {
        guard let chaptersStructure = chaptersStructure else { return }
        for chap in chaptersStructure.chapters {
            if chap.parent == 0 {
                rowData.append(ChapterRowData(order: chap.id, name: chap.name))
            }
        }
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
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        if self.darkMode {
            cell.backgroundColor = KKCBackgroundNightMode
            cell.textLabel?.backgroundColor = KKCBackgroundNightMode
            cell.textLabel?.textColor = KKCTextNightMode
        } else {
            cell.backgroundColor = KKCBackgroundLightMode
            cell.textLabel?.backgroundColor = KKCBackgroundLightMode
            cell.textLabel?.textColor = KKCTextLightMode
        }
        cell.textLabel?.text = rowData[indexPath.row].name
        cell.detailTextLabel?.text = rowData[indexPath.row].sub_name
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
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
