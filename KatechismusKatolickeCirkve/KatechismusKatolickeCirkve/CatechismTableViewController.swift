//
//  CatechismTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class CatechismTableViewController: UITableViewController {

    enum RowType {
        case browse_chapter
        case search_for_numbers
        case search_for
        case searching
        case index
        case settings
        case project
        case about
    }
    
    struct RowData {
        let type: RowType
        let menu: CatechismMenu?
    }
    //MARK: Properties
    fileprivate var rowData = [RowData]()
    fileprivate var darkMode: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCatechism()
        let userDefaults = UserDefaults.standard
        darkMode = userDefaults.bool(forKey: "NightSwitch")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CatechismTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CatechismTableViewCell else {
            fatalError("The dequeue cell is not an entrance of CatechismTableViewCell")
        }

        let data = rowData[indexPath.row]
        cell.catechismLabel.text = data.menu?.name

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "ShowChapters":
            guard let chaptersTableViewController = segue.destination as? ChaptersTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = rowData[indexPath.row]
        
        switch data.type {
        case .browse_chapter:
            //performSegue(withIdentifier: "ShowChapters", sender: indexPath)
            let mainViewController = UIStoryboard(name: "Main", bundle: nil)
            if mainViewController != nil {
                let chaptersViewController = mainViewController.instantiateViewController(withIdentifier: "Chapters")
                if  chaptersViewController != nil {
                    navigationController?.pushViewController(chaptersViewController, animated: true)
                }
            }
            
        case .search_for_numbers:
            print("Not implemented yet")
        case .search_for:
            if let searchForViewController = UIStoryboard(name: "SearchFor", bundle: nil).instantiateInitialViewController() {
                navigationController?.pushViewController(searchForViewController, animated: true)
            }
        case .searching:
            print("Not implemented yet")
        case .index:
            print("Not Implemented yet")
        case .project:
            if let aboutProjectViewController = UIStoryboard(name: "AboutProject", bundle: nil).instantiateInitialViewController() {
                navigationController?.pushViewController(aboutProjectViewController, animated: true)
            }
        case .settings:
            if let settingsViewController = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() {
                navigationController?.pushViewController(settingsViewController, animated: true)
            }
        case .about:
            if let aboutViewController = UIStoryboard(name: "About", bundle: nil).instantiateInitialViewController() {
                navigationController?.pushViewController(aboutViewController, animated: true)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func loadCatechism () {
        guard let browse_chapter = CatechismMenu(name: "Procházet kapitoly", photo: nil, order: 0) else {
            fatalError("Unable to instanciate Procházet kapitoly")
        }
        guard let search_for_numbers = CatechismMenu(name: "Hledat podle čísel", photo: nil, order: 1) else {
            fatalError("Unable to instanciate Hledat podle čísel")
        }
        guard let search_for = CatechismMenu(name: "Vyhledávání", photo: nil, order: 2) else {
            fatalError("Unable to instanciate Vyhledávání")
        }
        guard let index = CatechismMenu(name: "Rejstřík", photo: nil, order: 3) else {
            fatalError("Unable to instanciate Rejstřík")
        }
        guard let searching = CatechismMenu(name: "Vyhledávání", photo: nil, order: 4) else {
            fatalError("Unable to instanciate Vyhledavani")
        }
        guard let about_project = CatechismMenu(name: "O projektu", photo: nil, order: 5) else {
            fatalError("Unable to instanciate O projektu")
        }
        guard let settings = CatechismMenu(name: "Nastavení", photo: nil, order: 6) else {
            fatalError("Unable to instanciate Nastaveni")
        }
        guard let about = CatechismMenu(name: "O aplikaci", photo: nil, order: 7) else {
            fatalError("Unable to instanciate O aplikaci")
        }
        
        rowData = [RowData(type: .browse_chapter, menu: browse_chapter)]
        rowData.append(RowData(type: .search_for_numbers, menu: search_for_numbers))
        rowData.append(RowData(type: .search_for, menu: search_for))
        rowData.append(RowData(type: .index, menu: index))
        rowData.append(RowData(type: .searching, menu: searching))
        rowData.append(RowData(type: .project, menu: about_project))
        rowData.append(RowData(type: .settings, menu: settings))
        rowData.append(RowData(type: .about, menu: about))
    }
}
