//
//  SectionsTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 10/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SectionsTableViewController: UITableViewController {
    
    fileprivate var sectionsRowData = [SectionsRowData]()
    fileprivate var chaptersStructure: ChaptersStructure?
    fileprivate var paragraphStructure: ParagraphStructure?

    var parentID: Int = 0
    var darkMode: Bool = false
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chaptersStructure = ChaptersDataService.shared.chaptersStructure
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
        self.tableView.rowHeight = 80
        loadSections()
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        if self.darkMode {
            self.tableView.backgroundColor = KKCBackgroundNightMode
        } else {
            self.tableView.backgroundColor = KKCBackgroundLightMode
        }
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
        tableView.register(SectionsTableViewCell.self, forCellReuseIdentifier: SectionsTableViewCell.cellId)
        tableView.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        self.tableView.alwaysBounceHorizontal = false
        self.tableView.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    private func loadSubSections(section: Int, exist_paragraph: Bool) {
        for chap in (chaptersStructure?.chapters)! {
            if chap.parent == section {
                sectionsRowData.append(SectionsRowData(main_section: false, id: chap.id, name: chap.name, exist_paragraph: chap.exist_paragraph, sub_sections: chap.sub_sections))
            }
        }
    }
    private func loadSections() {
        guard let chaptersStructure = chaptersStructure else { return }
        for chap in chaptersStructure.chapters {
            if chap.parent == parentID {
                sectionsRowData.append(SectionsRowData(main_section: true, id: chap.id, name: chap.name, exist_paragraph: chap.exist_paragraph, sub_sections: chap.sub_sections))
                loadSubSections(section: chap.id, exist_paragraph: chap.exist_paragraph)
            }
        }
    }
}

extension SectionsTableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsRowData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SectionsTableViewCell.cellId, for: indexPath) as! SectionsTableViewCell

        let data = sectionsRowData[indexPath.row]
        cell.configureCell(data: data)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(sectionsRowData[indexPath.row])
        let pcvc = ParagraphTableViewController()
        let parentNumber = sectionsRowData[indexPath.row].id
        if parentNumber != 0 {
            pcvc.parentID = parentNumber
            pcvc.navigationItem.title = sectionsRowData[indexPath.row].name
            navigationController?.pushViewController(pcvc, animated: true)
        }
    }

}
