//
//  ParagraphRefsTableViewController.swift
//  
//
//  Created by Petr "Stone" Hracek on 06.11.18.
//

import UIKit

class ParagraphRefsTableViewController: BaseTableViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        let refArr = refs.components(separatedBy: ",")
        print(refArr)
        self.refsInt = refArr.map { Int($0)! }
        print(refsInt)
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
        let cellIdentifier = "ParagraphRefsTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ParagraphRefsTableViewCell else {
            fatalError("The dequeue cell is not an entrance of ParagraphTableViewCell")
        }
        let data = refsRowData[indexPath.row]
        
        cell.labelParagraph?.numberOfLines = 0
        cell.labelParagraph?.attributedText = data.html
        cell.labelParagraph.textColor = KKCTextNightMode
        if data.recap == 1 {
            cell.backgroundColor = KKCMainColor
        }
        else {
            if self.darkMode == true {
                cell.backgroundColor = KKCBackgroundNightMode
            }
            else {
                cell.backgroundColor = KKCBackgroundLightMode
                cell.labelParagraph.textColor = KKCTextLightMode
            }
        }
        return cell
    }


    func loadRefs() {
        guard let paragraphStructure = paragraphStructure else { return }
        
        for par in paragraphStructure.paragraph {
            if refsInt.contains(par.id) {
                refsRowData.append(RefsRowData(html: get_html_text(par: par, kindOfSource: 0, parentID: 0),
                                               id: par.id, recap: par.recap))
            }
        }
    }
}