//
//  ParagraphTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 13/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import BonMot
import PopMenu
import FirebaseAnalytics


class ParagraphTableViewController: UITableViewController, PopMenuViewControllerDelegate {
    
    struct RowData {
        var html: NSAttributedString
        var recap: Int
        var paragraphs: String
        var id: Int
        var fav: Bool
    }

    var heightOfWebView: CGFloat = 0
    var indexes: String = ""
    fileprivate var rowData = [RowData]()
    fileprivate var paragraphStructure: ParagraphStructure?
    let cellSpacingHeight: CGFloat = 20
    
    var boolSouhrn: Bool = false
    var parentID: Int = 0
    var kindOfSource: Int = 0
    var rangeID: Int = 0
    var findData = [Int]()
    var findString: String = ""
    var darkMode: Bool = false
    var favorites = [Int]()
    var isStatusBarHidden = false {
        didSet {
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }

    var userDefaults = UserDefaults.standard
    var refsInt = [Int]()
    var font_name: String = "Helvetica"
    var font_size: CGFloat = 16
    
    var className: String {
        return String(describing: self)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden || UIDevice.current.orientation.isLandscape && UIDevice.current.userInterfaceIdiom == .phone
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters:[AnalyticsParameterScreenName: "Catechishm collection view viewDidLoad",
                                       AnalyticsParameterScreenClass: className])
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
        self.tableView.estimatedRowHeight = 100
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        self.favorites = userDefaults.array(forKey: "Favorites") as? [Int] ?? [Int]()
        if let saveFontName = userDefaults.string(forKey: "FontName") {
            self.font_name = saveFontName
        } else {
            userDefaults.set("Helvetica", forKey: "FontName")
        }
        if let saveFontSize = userDefaults.string(forKey: "FontSize") {
            guard let n = NumberFormatter().number(from: saveFontSize) else { return }
            self.font_size = CGFloat(truncating: n)
        } else {
            userDefaults.set(16, forKey: "FontSize")
            self.font_size = 16
        }

        loadParagraphs()
        setupSettingsTable()
        self.tableView.tableFooterView = UIView()

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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.darkMode {
            self.tableView!.backgroundColor = KKCBackgroundNightMode
        } else {
            self.tableView!.backgroundColor = KKCBackgroundLightMode
        }

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
 
    
    func setupSettingsTable() {
        tableView.register(ParagraphTableViewCell.self, forCellReuseIdentifier: ParagraphTableViewCell.cellId)
        tableView.contentInset = UIEdgeInsets(top:12, left: 12, bottom: 12, right: 12)
        
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "ShowParagraphRefs":
            guard let refsTableViewController = segue.destination as? ParagraphRefsTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let indexPath = sender as? IndexPath else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let data = rowData[indexPath.row]
            if data.paragraphs != "" {
                refsTableViewController.refs = data.paragraphs
                refsTableViewController.navigationItem.title = "Odkazované paragrafy"
            }
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

    private func loadParagraphs() {
        guard let paragraphStructure = paragraphStructure else { return }
        
        for par in paragraphStructure.paragraph {
            if kindOfSource == 1 {
                if par.id >= parentID && par.id <= rangeID {
                    let html = get_html_text(par: par, kindOfSource: kindOfSource, parentID: parentID)
                    rowData.append(RowData(html: generateContent(text: html, font_name: self.font_name, size: self.font_size),
                                                             recap: par.recap,
                                                             paragraphs: par.refs,
                                                             id: par.id,
                                                             fav: get_favorites(id: par.id)))
                }
            }
            else if kindOfSource == 0 {
                if par.chapter == parentID {
                    let html = get_html_text(par: par, kindOfSource: kindOfSource, parentID: parentID)
                    rowData.append(RowData(html: generateContent(text: html, font_name: self.font_name, size: self.font_size),
                                                             recap: par.recap,
                                                             paragraphs: par.refs,
                                                             id: par.id,
                                                             fav: get_favorites(id: par.id)))
                }
            }
            else if kindOfSource == 2 {
                if findData.contains(par.id) {
                    var new_par = par
                    new_par.text = new_par.text.replacingOccurrences(of: self.findString, with: "<red>\(self.findString)</red>")
                    let html = get_html_text(par: new_par, kindOfSource: kindOfSource, parentID: parentID)
                    rowData.append(RowData(html: generateContent(text: html, font_name: self.font_name, size: self.font_size),
                                                             recap: new_par.recap,
                                                             paragraphs: par.refs,
                                                             id: par.id,
                                                             fav: get_favorites(id: par.id)))
                }
            }
                
            else if kindOfSource == 3 {
                if findData.contains(par.id) {
                    let html = get_html_text(par: par, kindOfSource: kindOfSource, parentID: parentID)
                    rowData.append(RowData(html: generateContent(text: html, font_name: self.font_name, size: self.font_size),
                                                             recap: par.recap,
                                                             paragraphs: par.refs,
                                                             id: par.id,
                                                             fav: get_favorites(id: par.id)))
                }
            }
            else if kindOfSource == 4 {
                if favorites.contains(par.id) {
                    let html = get_html_text(par: par, kindOfSource: kindOfSource, parentID: parentID)
                    rowData.append(RowData(html: generateContent(text: html, font_name: self.font_name, size: self.font_size),
                                                             recap: par.recap,
                                                             paragraphs: par.refs,
                                                             id: par.id,
                                                             fav: get_favorites(id: par.id)))
                }
            }
            else if kindOfSource == 5 {
                let refArr = indexes.components(separatedBy: ",")
                self.refsInt = refArr.map { Int($0)! }
                if refsInt.contains(par.id) {
                    let html = get_html_text(par: par, kindOfSource: kindOfSource, parentID: parentID)
                    rowData.append(RowData(html: generateContent(text: html, font_name: self.font_name, size: self.font_size),
                                                             recap: par.recap,
                                                             paragraphs: par.refs,
                                                             id: par.id,
                                                             fav: get_favorites(id: par.id)))
                }
            }
        }
    }
    
    private func get_favorites(id: Int) -> Bool {
        if self.favorites.contains(where: { $0 == id }) {
            return true
        }
        else
        {
            return false
        }
    }

    @objc private func darkModeEnabled(_ notification: Notification) {
        self.darkMode = true
        self.tableView?.backgroundColor = KKCBackgroundNightMode
        self.tableView!.reloadData()
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        self.darkMode = false
        self.tableView?.backgroundColor = KKCBackgroundLightMode
        self.tableView!.reloadData()
    }
}

extension ParagraphTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ParagraphTableViewCell.cellId, for: indexPath) as! ParagraphTableViewCell

        let data = rowData[indexPath.row]
        if data.fav == false {
            cell.configureCell(name: data.html, image_name: "star_off")
        }
        else {
            cell.configureCell(name: data.html, image_name: "star_on")
        }
        cell.isUserInteractionEnabled = false
//        cell.layer.borderColor = KKCMainColor.cgColor
//        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 8
//        cell.clipsToBounds = true

   
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let row_id = self.rowData[indexPath.row].id
        let valid_favorites = self.get_favorites(id: row_id)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Přidat do / Odebrat z oblíbených", style: .default, handler: { (action) in
            if valid_favorites == false {
                self.rowData[indexPath.row].fav = true
                self.favorites.append(row_id)
            }
            else
            {
                self.rowData[indexPath.row].fav = false
                if let index = self.favorites.firstIndex(of: row_id) {
                    self.favorites.remove(at: index)
                }
            }
            self.userDefaults.set(self.favorites, forKey: "Favorites")
            self.tableView!.reloadData()
            }))
        alert.addAction(UIAlertAction(title: "Zobrazit odkazované paragrafy", style: .default, handler: { (action) in
            let refs = self.rowData[indexPath.row].paragraphs
            if refs != "" {
                self.performSegue(withIdentifier: "ShowParagraphRefs", sender: indexPath)
            }
            else {
                let noRefsAlert = UIAlertController(title: "Neobsahuje žádné odkazy", message: nil, preferredStyle: .alert)
                noRefsAlert.addAction(UIAlertAction(title: "Zavřít", style: .default, handler: nil))
                self.present(noRefsAlert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Zavřít", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
 
        /*let action1 = PopMenuDefaultAction(title: "Přidat do / Odebrat z oblíbených", didSelect: {action in
            print(action)
            if valid_favorites == false {
                print("Add to favorites")
                print(row_id)
                self.paragraphRowData[indexPath.row].fav = true
                self.favorites.append(row_id)
            }
            else
            {
                print("Remove from favorites")
                print(row_id)
                self.paragraphRowData[indexPath.row].fav = false
                if let index = self.favorites.firstIndex(of: row_id) {
                    self.favorites.remove(at: index)
                }
            }
            print(self.favorites)
            self.userDefaults.set(self.favorites, forKey: "Favorites")
            self.tableView.beginUpdates()
            self.tableView.reloadData()
            self.tableView.endUpdates()
        })
        let action2 = PopMenuDefaultAction(title: "Zobrazit odkazované paragrafy", didSelect: {action in
            self.performSegue(withIdentifier: "ShowParagraphRefs", sender: indexPath)
        })
        let manager = PopMenuManager.default
        manager.addAction(action1)
        manager.addAction(action2)
        manager.present(on: self)
        //manager.popMenuShouldDismissOnSelection = true
*/
    }

}
