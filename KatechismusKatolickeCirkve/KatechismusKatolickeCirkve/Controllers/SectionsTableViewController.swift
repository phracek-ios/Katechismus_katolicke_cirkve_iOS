//
//  SectionsTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 10/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SectionsTableViewController: UITableViewController {

    struct SectionsRowData {
        var main_section: Bool
        var id: Int
        var name: String
    }
    
    fileprivate var sectionsRowData = [SectionsRowData]()
    fileprivate var chaptersStructure: ChaptersStructure?

    var parentID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chaptersStructure = ChaptersDataService.shared.chaptersStructure
        loadSections()
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
        if sectionsRowData[indexPath.row].main_section == true {
            cell.backgroundColor = UIColor.blue
            cell.sectionLabel?.textColor = UIColor.white
        }
        cell.sectionLabel?.text = sectionsRowData[indexPath.row].name
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
            }
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowParagraph", sender: indexPath)
    }

    private func loadSubSections(section: Int) {
        for chap in (chaptersStructure?.chapters)! {
            if chap.parent == section {
                sectionsRowData.append(SectionsRowData(main_section: false, id: chap.id, name: chap.name))
            }
        }
    }
    private func loadSections() {
        guard let chaptersStructure = chaptersStructure else { return }
        for chap in chaptersStructure.chapters {
            if chap.parent == parentID {
                sectionsRowData.append(SectionsRowData(main_section: true, id: chap.id, name: chap.name))
                loadSubSections(section: chap.id)
            }
        }
    }

}
