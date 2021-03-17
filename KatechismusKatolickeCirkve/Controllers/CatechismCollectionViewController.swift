//
//  CatechismTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import os.log
import FirebaseAnalytics

class CatechismCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

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
    
    
    var className: String {
        return String(describing: self)
    }
    
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    //MARK: Properties
    fileprivate var rowData = [RowData]()
    fileprivate var darkMode: Bool = false
    var favorites = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters:[AnalyticsParameterScreenName: "Paragraph collection view viewDidLoad",
                                       AnalyticsParameterScreenClass: className])
        loadCatechism()
        setupCollectionView()
        navigationItem.backBarButtonItem?.title = "Zpět"
        navigationController?.navigationBar.backItem?.backBarButtonItem = UIBarButtonItem(title: "Zpět", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.barTintColor = KKCMainColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: KKCMainTextColor]
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters:[AnalyticsParameterScreenName: "Catechishm collection view viewWillAppear",
                                       AnalyticsParameterScreenClass: className])
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        if self.darkMode == true {
            self.collectionView!.backgroundColor = KKCBackgroundNightMode
        } else {
            self.collectionView!.backgroundColor = KKCBackgroundLightMode
        }
        self.collectionView?.reloadData()
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
        self.favorites = userDefaults.array(forKey: keys.Favourites) as? [Int] ?? [Int]()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard previousTraitCollection != nil else { return }
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            flowLayout.minimumInteritemSpacing = 15

        }
        collectionView?.register(CatechismCollectionViewCell.self, forCellWithReuseIdentifier: CatechismCollectionViewCell.cellId)

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
}

extension CatechismCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = rowData[indexPath.row]
        
        switch data.type {
        case .browse_chapter:
            let chaptersViewController = ChaptersTableViewController()
            navigationController?.pushViewController(chaptersViewController, animated: true)
        case .search_for_numbers:
            let numbersViewController = NumbersTableViewController()
            navigationController?.pushViewController(numbersViewController, animated: true)
        case .find_word:
            let findWordViewController = FindViewController()
            findWordViewController.word_number_find = false
            navigationController?.pushViewController(findWordViewController, animated: true)
        case .find_number:
            let findWordViewController = FindViewController()
            findWordViewController.word_number_find = true
            navigationController?.pushViewController(findWordViewController, animated: true)
        case .index:
            let indexViewController = IndexTableViewController()
            navigationController?.pushViewController(indexViewController, animated: true)
        case .project:
            let aboutViewController = AboutViewController()
            aboutViewController.about_project = true
            navigationController?.pushViewController(aboutViewController, animated: true)
        case .favorites:
            if self.favorites.count != 0 {
                let favoritesViewController = ParagraphTableViewController()
                favoritesViewController.kindOfSource = 4
                navigationController?.pushViewController(favoritesViewController, animated: true)
            }
            else {
                let alert = UIAlertController(title: "Dosud nebyly označeny žádné paragrafy jako oblíbené.", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Zavřít", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        case .settings:
            let settingsTableViewController = SettingsTableViewController()
            navigationController?.pushViewController(settingsTableViewController, animated: true)
        case .about:
            let aboutViewController = AboutViewController()
            aboutViewController.about_project = false
            navigationController?.pushViewController(aboutViewController, animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowData.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatechismCollectionViewCell.cellId, for: indexPath) as! CatechismCollectionViewCell

        let data = rowData[indexPath.row]
        cell.configureCell(name: data.menu!.name)
        cell.layer.borderColor = KKCMainColor.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 30, height: 60)
    }
}
