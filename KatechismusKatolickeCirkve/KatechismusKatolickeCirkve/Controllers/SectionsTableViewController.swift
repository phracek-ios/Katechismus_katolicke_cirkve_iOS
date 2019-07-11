//
//  SectionsTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 10/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SectionsTableViewController: BaseTableViewController {

    struct SectionsRowData {
        var main_section: Bool
        var id: Int
        var name: String
        var exist_paragraph: Bool
    }
    
    fileprivate var sectionsRowData = [SectionsRowData]()
    fileprivate var chaptersStructure: ChaptersStructure?
    fileprivate var paragraphStructure: ParagraphStructure?

    var parentID: Int = 0
    var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chaptersStructure = ChaptersDataService.shared.chaptersStructure
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
       self.tableView.rowHeight = 80
        loadSections()
        self.tableView.tableFooterView = UIView()
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        if self.darkMode {
            self.tableView.backgroundColor = KKCBackgroundNightMode
        } else {
            self.tableView.backgroundColor = KKCBackgroundLightMode
        }
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsRowData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SectionsTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SectionsTableViewCell else { return UITableViewCell()
        }
        cell.sectionLabel?.text = sectionsRowData[indexPath.row].name
        cell.accessoryType = .none
        cell.isUserInteractionEnabled = false
        if sectionsRowData[indexPath.row].exist_paragraph == true {
            cell.isUserInteractionEnabled = true
            cell.accessoryType = .disclosureIndicator
        }
        if sectionsRowData[indexPath.row].main_section == true {
            cell.backgroundColor = KKCMainColor
            cell.sectionLabel.backgroundColor = KKCMainColor
            cell.sectionLabel?.textColor = KKCTextNightMode

        } else {
            if self.darkMode == true {
                cell.backgroundColor = KKCBackgroundNightMode
                cell.sectionLabel.backgroundColor = KKCBackgroundNightMode
                cell.sectionLabel.textColor = KKCTextNightMode
            }
            else {
                cell.backgroundColor = KKCBackgroundLightMode
                cell.sectionLabel.backgroundColor = KKCBackgroundLightMode
                cell.sectionLabel.textColor = KKCTextLightMode
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "ShowParagraph":
            guard let paragraphTableViewController = segue.destination as? ParagraphTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let indexPath = sender as? IndexPath else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let parentNumber = sectionsRowData[indexPath.row].id
            if parentNumber != 0 {
                paragraphTableViewController.parentID = parentNumber
                paragraphTableViewController.navigationItem.title = sectionsRowData[indexPath.row].name
            }
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowParagraph", sender: indexPath)
    }

    private func loadSubSections(section: Int, exist_paragraph: Bool) {
        for chap in (chaptersStructure?.chapters)! {
            if chap.parent == section {
                sectionsRowData.append(SectionsRowData(main_section: false, id: chap.id, name: chap.name, exist_paragraph: chap.exist_paragraph))
            }
        }
    }
    private func loadSections() {
        guard let chaptersStructure = chaptersStructure else { return }
        for chap in chaptersStructure.chapters {
            if chap.parent == parentID {
                sectionsRowData.append(SectionsRowData(main_section: true, id: chap.id, name: chap.name, exist_paragraph: chap.exist_paragraph))
                loadSubSections(section: chap.id, exist_paragraph: chap.exist_paragraph)
            }
        }
    }
    private func checkParagraph(section: Int) -> Bool {
        guard let paragraphStructure = paragraphStructure else { return false }
        
        for par in paragraphStructure.paragraph {
            if par.chapter == section {
                return true
            }
        }
        return false
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
