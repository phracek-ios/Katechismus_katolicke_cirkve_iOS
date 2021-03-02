//
//  ParagraphRefsTableViewController.swift
//  
//
//  Created by Petr "Stone" Hracek on 06.11.18.
//

import UIKit

class ParagraphRefsTableViewController: UITableViewController {

    struct RefsRowData {
        var html: NSAttributedString
        var id: Int
        var recap: Int
    }
    var refs: String = ""

    var heightOfWebView: CGFloat = 0
    var darkMode: Bool = false
    fileprivate var refsRowData = [RefsRowData]()
    fileprivate var paragraphStructure: ParagraphStructure?
    var userDefaults = UserDefaults.standard
    var refsInt = [Int]()
    var font_name: String = "Helvetica"
    var font_size: CGFloat = 16
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        let refArr = refs.components(separatedBy: ",")
        self.refsInt = refArr.map { Int($0)! }
        self.font_name = userDefaults.string(forKey: keys.fontName)!
        let fontSize = userDefaults.string(forKey: keys.fontSize)!
        guard let n = NumberFormatter().number(from: fontSize) else { return }
        self.font_size = CGFloat(truncating: n)
        
        if self.font_name == "" {
            self.font_name = "Helvetica"
        }
        if self.font_size == 0 {
            self.font_size = 16
        }
        loadRefs()
        self.tableView.tableFooterView = UIView()
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


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return refsRowData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ParagraphRefsTableViewCell.cellId, for: indexPath) as! ParagraphRefsTableViewCell

        let data = refsRowData[indexPath.row]
        cell.configureCell(html: data.html, image_name: "star_off", recap: data.recap)
        return cell
    }


    func loadRefs() {
        guard let paragraphStructure = paragraphStructure else { return }
        
        for par in paragraphStructure.paragraph {
            if refsInt.contains(par.id) {
                let html = get_html_text(par: par, kindOfSource: 0, parentID: 0)
                refsRowData.append(RefsRowData(html: generateContent(text: html, font_name: self.font_name, size: self.font_size),
                                               id: par.id, recap: par.recap))
            }
        }
    }
}
