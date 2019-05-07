//
//  CatechismTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class CatechismTableViewController: BaseTableViewController {

    enum RowType {
        case browse_chapter
        case search_for_numbers
        case find_word
        case find_number
        case index
        case favorites
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
    var favorites = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCatechism()
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        if self.darkMode {
            self.tableView.backgroundColor = KKCBackgroundNightMode
        } else {
            self.tableView.backgroundColor = KKCBackgroundLightMode
        }
        self.tableView.tableFooterView = UIView()
        navigationController?.navigationBar.barTintColor = KKCMainColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: KKCMainTextColor]
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        self.favorites = userDefaults.array(forKey: "Favorites") as? [Int] ?? [Int]()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
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
        if self.darkMode == true {
            cell.backgroundColor = KKCBackgroundNightMode
            cell.catechismLabel.textColor = KKCTextNightMode
        }
        else {
            cell.backgroundColor = KKCBackgroundLightMode
            cell.catechismLabel.textColor = KKCTextLightMode
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = rowData[indexPath.row]
        
        switch data.type {
        case .browse_chapter:
            let mainViewController = UIStoryboard(name: "Main", bundle: nil)
            let chaptersViewController = mainViewController.instantiateViewController(withIdentifier: "Chapters")
            navigationController?.pushViewController(chaptersViewController, animated: true)
            
        case .search_for_numbers:
            let mainViewController = UIStoryboard(name: "Main", bundle: nil)
            let numbersViewController = mainViewController.instantiateViewController(withIdentifier: "Numbers")
            navigationController?.pushViewController(numbersViewController, animated: true)
        case .find_word:
            let mainViewController = UIStoryboard(name: "Main", bundle: nil)
            let findWordViewController = mainViewController.instantiateViewController(withIdentifier: "FindWord")
            navigationController?.pushViewController(findWordViewController, animated: true)
        case .find_number:
            let mainViewController = UIStoryboard(name: "Main", bundle: nil)
            let findWordViewController = mainViewController.instantiateViewController(withIdentifier: "FindNumber")
            navigationController?.pushViewController(findWordViewController, animated: true)
        case .index:
            let mainViewController = UIStoryboard(name: "Main", bundle: nil)
            let indexViewController = mainViewController.instantiateViewController(withIdentifier: "Index")
            navigationController?.pushViewController(indexViewController, animated: true)
        case .project:
            if let aboutProjectViewController = UIStoryboard(name: "AboutProject", bundle: nil).instantiateInitialViewController() {
                navigationController?.pushViewController(aboutProjectViewController, animated: true)
            }
        case .favorites:
            if self.favorites.count != 0 {
                let mainViewController = UIStoryboard(name: "Main", bundle: nil)
                let favoritesViewController = mainViewController.instantiateViewController(withIdentifier: "ShowParagraphs") as? ParagraphTableViewController
                favoritesViewController?.kindOfSource = 4
                navigationController?.pushViewController(favoritesViewController!, animated: true)
            }
            else {
                let alert = UIAlertController(title: "Dosud nebyly označeny žádné paragrafy jako oblíbené.", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Zavřít", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        case .settings:
            if let settingsTableViewController = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() {
                navigationController?.pushViewController(settingsTableViewController, animated: true)
            }
        case .about:
            if let aboutViewController = UIStoryboard(name: "About", bundle: nil).instantiateInitialViewController() {
                navigationController?.pushViewController(aboutViewController, animated: true)
            }
        }
    }

    private func loadCatechism () {
        guard let browse_chapter = CatechismMenu(name: "Procházet kapitoly", photo: nil, order: 0) else {
            fatalError("Unable to instanciate Procházet kapitoly")
        }
        guard let search_for_numbers = CatechismMenu(name: "Číselný seznam", photo: nil, order: 1) else {
            fatalError("Unable to instanciate Hledat podle čísel")
        }
        guard let find_word = CatechismMenu(name: "Vyhledávání", photo: nil, order: 2) else {
            fatalError("Unable to instanciate Vyhledávání")
        }
        guard let find_number = CatechismMenu(name: "Vyhledat paragraf", photo: nil, order: 3) else {
            fatalError("Unable to instanciate Hledat podle čísel")
        }
        guard let index = CatechismMenu(name: "Rejstřík", photo: nil, order: 3) else {
            fatalError("Unable to instanciate Rejstřík")
        }
        guard let favorites = CatechismMenu(name: "Oblíbené", photo: nil, order: 4) else {
            fatalError("Unable to instanciate Oblíbené")
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
        rowData.append(RowData(type: .find_word, menu: find_word))
        rowData.append(RowData(type: .find_number, menu: find_number))
        rowData.append(RowData(type: .index, menu: index))
        rowData.append(RowData(type: .favorites, menu: favorites))
        rowData.append(RowData(type: .project, menu: about_project))

        rowData.append(RowData(type: .settings, menu: settings))
        rowData.append(RowData(type: .about, menu: about))
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
