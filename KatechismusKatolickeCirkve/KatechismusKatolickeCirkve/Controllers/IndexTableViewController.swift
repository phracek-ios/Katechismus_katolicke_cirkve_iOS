//
//  IndexTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class IndexTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    fileprivate var full_index = [String: [IndexRowData]]()
    fileprivate var indexStructure: IndexStructure?
    var darkMode: Bool = false
    let indexSectionAlphabet = ["A", "B", "C", "Č", "D", "E", "F", "G", "H", "CH", "I", "J", "K", "L", "M", "N", "O", "P", "R", "Ř", "S", "Š", "T", "U", "V", "Z", "Ž"]
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        indexStructure = IndexDataService.shared.indexStructure
        self.navigationItem.title = "Rejstřík"
        for alpha in indexSectionAlphabet {
            self.full_index[alpha] = [IndexRowData]()
        }
        
        loadIndex()
        setupSettingsTable()
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        self.tableView.tableFooterView = UIView()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 0.5 // 0.5 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        self.tableView.estimatedRowHeight = 60
        if self.darkMode {
            self.tableView.backgroundColor = KKCBackgroundNightMode
        } else {
            self.tableView.backgroundColor = KKCBackgroundLightMode
        }
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadIndex() {
        guard let indexStructure = indexStructure else { return }
        for ind in indexStructure.index {
            if ind.see.isEmpty {
                self.full_index[ind.key]?.append(IndexRowData(refs: ind.refs, name: generateContent(text: ind.name), see: ind.see))
            }
            else {
                let text = ind.name + " ... <em>viz též</em> " + ind.see
                self.full_index[ind.key]?.append(IndexRowData(refs: ind.refs, name: generateContent(text: text), see: ind.see))
            }
        }
    }
        
    func setupSettingsTable() {
        tableView.register(IndexTableViewCell.self, forCellReuseIdentifier: IndexTableViewCell.cellId)
        //tableView.contentInset = UIEdgeInsets(top:12, left: 12, bottom: 12, right: 12)
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
    
    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        
        if indexPath == nil {
            print("Long press on table view, not row.")
        }
        else if (longPressGesture.state == UIGestureRecognizerState.began) {
            let sectionTitle = self.indexSectionAlphabet[indexPath!.section]
            let see = self.full_index[sectionTitle]?[indexPath!.row].see
            if (see?.isEmpty)! {
                let noRefsAlert = UIAlertController(title: "Klíčové slovo neobsahuje žádné odkazy", message: nil, preferredStyle: .alert)
                noRefsAlert.addAction(UIAlertAction(title: "Zavřít", style: .default, handler: nil))
                self.present(noRefsAlert, animated: true, completion: nil)
            }
            else {
                let sees = see?.components(separatedBy: ";")
                let alert = UIAlertController(title: "", message: "Viz též", preferredStyle: .actionSheet)
                for s in sees! {
                    alert.addAction(UIAlertAction(title: s, style: .default, handler: { (action) -> Void in
                        print(s)
                    }))
                }
                alert.addAction(UIAlertAction(title: "Zavřít", style: .destructive, handler: { (_) in
                    print("Close")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
}

extension IndexTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.indexSectionAlphabet.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let alphabet_section = self.indexSectionAlphabet[section]
        let sectionIndexes = self.full_index[alphabet_section]
        return sectionIndexes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IndexTableViewCell.cellId, for: indexPath) as! IndexTableViewCell
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        cell.isUserInteractionEnabled = false
        let sectionTitle = self.indexSectionAlphabet[indexPath.section]
        let row = self.full_index[sectionTitle]?[indexPath.row]
        let name = (row?.name)!
        let refs = row?.refs
        cell.configureCell(name: name, refs: refs!)
        if self.darkMode == true {
            cell.backgroundColor = KKCBackgroundNightMode
        } else {
            cell.backgroundColor = KKCBackgroundLightMode
        }

        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pcvc = ParagraphTableViewController()

        let sectionTitle = self.indexSectionAlphabet[indexPath.section]
        let refs = self.full_index[sectionTitle]?[indexPath.row].refs
        pcvc.kindOfSource = 5
        pcvc.indexes = refs ?? ""
        navigationController?.pushViewController(pcvc, animated: true)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.indexSectionAlphabet
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.indexSectionAlphabet[section]
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        let userDefaults = UserDefaults.standard
        let darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        let label = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width, height: 25))
        label.text = self.indexSectionAlphabet[section]
        if darkMode == true {
            returnedView.backgroundColor = KKCMainColor
            label.backgroundColor = KKCMainColor
            label.textColor = KKCTextNightMode
        } else {
            returnedView.backgroundColor = KKCMainColor
            label.backgroundColor = KKCMainColor
            label.textColor = KKCTextLightMode
        }
        returnedView.addSubview(label)
        return returnedView
    }
}
