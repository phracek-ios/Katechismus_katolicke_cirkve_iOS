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
    }
    fileprivate var rowData = [ChapterRowData]()
    fileprivate var chaptersStructure: ChaptersStructure?
    var darkMode: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        chaptersStructure = ChaptersDataService.shared.chaptersStructure
        self.navigationItem.title = "Procházet kapitoly"
        loadChapters()
        self.tableView.tableFooterView = UIView()
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
        if self.darkMode == true {
            enabledDark()
        }
        else {
            disabledDark()
        }

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
        return rowData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ChaptersTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChaptersTableViewCell else {
            fatalError("The dequeue cell is not an entrance of ChaptersTableViewCell")
        }
        cell.chapterLabel?.text = rowData[indexPath.row].name
        if self.darkMode == true {
            cell.backgroundColor = KKCBackgroundNightMode
            cell.chapterLabel.textColor = KKCTextNightMode
        }
        else {
            cell.backgroundColor = KKCBackgroundLightMode
            cell.chapterLabel.textColor = KKCTextLightMode
        }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "ShowSections":
            guard let sectionsTableViewController = segue.destination as? SectionsTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let indexPath = sender as? IndexPath else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let parentNumber = rowData[indexPath.row].order
            if parentNumber != 0 {
                sectionsTableViewController.parentID = parentNumber
                sectionsTableViewController.navigationItem.title = rowData[indexPath.row].name
            }
        
        case "ShowParagraph":
            guard let paragraphTableViewController = segue.destination as? ParagraphTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let indexPath = sender as? IndexPath else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let parentNumber = rowData[indexPath.row].order
            paragraphTableViewController.parentID = parentNumber

        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if rowData[indexPath.row].order != 1 && rowData[indexPath.row].order != 2 && rowData[indexPath.row].order != 3 {
            performSegue(withIdentifier: "ShowSections", sender: indexPath)
        } else {
            performSegue(withIdentifier: "ShowParagraph", sender: indexPath)
        }
    }

    private func loadChapters() {
        guard let chaptersStructure = chaptersStructure else { return }
        for chap in chaptersStructure.chapters {
            if chap.parent == 0 {
                rowData.append(ChapterRowData(order: chap.id, name: chap.name))
            }
        }
    }
    func enabledDark() {
        self.tableView.backgroundColor = KKCBackgroundNightMode
    }
    
    func disabledDark() {
        self.tableView.backgroundColor = KKCBackgroundLightMode
    }

}
