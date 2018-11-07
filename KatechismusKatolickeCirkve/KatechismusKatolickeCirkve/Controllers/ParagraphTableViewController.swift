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

class ParagraphTableViewController: BaseTableViewController, PopMenuViewControllerDelegate {
    
    struct ParagraphRowData {
        var html: NSAttributedString
        var recap: Int
        var paragraphs: String
        var id: Int
        var fav: Bool
    }

    var heightOfWebView: CGFloat = 0
    
    fileprivate var paragraphRowData = [ParagraphRowData]()
    fileprivate var paragraphStructure: ParagraphStructure?

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
}        }
    }
    let star_on_img = UIImage(named: "star_on")
    let star_off_img = UIImage(named: "star_off")
    var userDefaults = UserDefaults.standard

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden || UIDevice.current.orientation.isLandscape && UIDevice.current.userInterfaceIdiom == .phone
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        self.favorites = userDefaults.array(forKey: "Favorites") as? [Int] ?? [Int]()
        loadParagraphs()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()
        print("viewDidAppear")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paragraphRowData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ParagraphTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ParagraphTableViewCell else {
            fatalError("The dequeue cell is not an entrance of ParagraphTableViewCell")
        }
        let data = paragraphRowData[indexPath.row]
        
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
        if data.fav == false {
            cell.starImage.image = star_off_img
        }
        else {
            cell.starImage.image = star_on_img
        }
        print("cellForRowAt")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        print(indexPath.row)
        let action1 = PopMenuDefaultAction(title: "Přidat do / Odebrat z oblíbených", didSelect: {action in
            let row_id = self.paragraphRowData[indexPath.row].id
            print(row_id)
            if self.get_favorites(id: row_id) == false {
                print("Add to favorites")
                self.paragraphRowData[indexPath.row].fav = true
                self.favorites.append(row_id)
            }
            else
            {
                print("remove")
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
            print("PARAGRAFY")
        })
        let manager = PopMenuManager.default
        manager.addAction(action1)
        manager.addAction(action2)
        manager.present(on: self)
    }

    private func generateContent(text: String) -> NSAttributedString {
        
        let baseStyle = StringStyle(
            .font(UIFont.systemFont(ofSize: 16)),
            .lineHeightMultiple(1)
        )
        let strong = baseStyle.byAdding(
            .font(UIFont.boldSystemFont(ofSize: 16))
        )
        
        let emphasized = baseStyle.byAdding(
            .font(UIFont.italicSystemFont(ofSize: 16))
        )
        
        let small = baseStyle.byAdding(
            .font(UIFont.systemFont(ofSize: 12))
        )
        
        let paragraph = baseStyle.byAdding(
            .paragraphSpacingBefore(20)
        )
        
        let redStyle = StringStyle(
            .color(.red)
        )

        let rules: [XMLStyleRule] = [
            .style("em", emphasized),
            .style("b", strong),
            .style("small", small),
            .style("p", paragraph),
            .style("br", paragraph),
            .style("red", redStyle)
        ]
        
        let content = baseStyle.byAdding(
            .color(UIColor.darkGray),
            .xmlRules(rules)
        )
        var generated_text = text
        generated_text = generated_text.replacingOccurrences(of: "<p>\n", with: "<p>")
        generated_text = generated_text.replacingOccurrences(of: "<smaal>", with: "<small>")
        generated_text = generated_text.replacingOccurrences(of: "\n</p>", with: "</p>")
        generated_text = generated_text.replacingOccurrences(of: "[\\t\\n\\r][\\t\\n\\r]+", with: "\n", options: .regularExpression)
        generated_text = generated_text.replacingOccurrences(of: "<p>", with: "")
        generated_text = generated_text.replacingOccurrences(of: "</p>", with: "\n\n")
        generated_text = generated_text.replacingOccurrences(of: "<br>", with: "\n")
        generated_text = generated_text.trimmingCharacters(in: .whitespacesAndNewlines)
        return generated_text.styled(with: content)
    }
    
    private func loadParagraphs() {
        guard let paragraphStructure = paragraphStructure else { return }
        
        if kindOfSource == 1 {
            for par in paragraphStructure.paragraph {
                if par.id >= parentID && par.id <= rangeID {
                    paragraphRowData.append(ParagraphRowData(html: get_html_text(par: par),
                                                             recap: par.recap,
                                                             paragraphs: par.refs,
                                                             id: par.id,
                                                             fav: get_favorites(id: par.id)))
                }
            }
        }
        else if kindOfSource == 0 {
            for par in paragraphStructure.paragraph {
                if par.chapter == parentID {
                    paragraphRowData.append(ParagraphRowData(html: get_html_text(par: par),
                                                             recap: par.recap,
                                                             paragraphs: par.refs,
                                                             id: par.id,
                                                             fav: get_favorites(id: par.id)))
                }
            }
        }
        else if kindOfSource == 2 {
            for par in paragraphStructure.paragraph {
                if findData.contains(par.id) {
                    var new_par = par
                    new_par.text = new_par.text.replacingOccurrences(of: self.findString, with: "<red>\(self.findString)</red>")
                    paragraphRowData.append(ParagraphRowData(html: get_html_text(par: new_par),
                                                             recap: new_par.recap,
                                                             paragraphs: par.refs,
                                                             id: par.id,
                                                             fav: get_favorites(id: par.id)))
                }
            }
        }
        else if kindOfSource == 3 {
            for par in paragraphStructure.paragraph {
                if findData.contains(par.id) {
                    paragraphRowData.append(ParagraphRowData(html: get_html_text(par: par),
                                                             recap: par.recap,
                                                             paragraphs: par.refs,
                                                             id: par.id,
                                                             fav: get_favorites(id: par.id)))
                }
            }
        }
        else if kindOfSource == 4 {
            for par in paragraphStructure.paragraph {
                if favorites.contains(par.id) {
                    paragraphRowData.append(ParagraphRowData(html: get_html_text(par: par),
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
    private func get_html_text(par: Paragraph) -> NSAttributedString {
        var references: String = ""
        var caption: String = ""
        var text_refs: String = ""
        if kindOfSource == 0 && parentID != 1 && parentID != 2 {
            if par.id < 10000 {
                references = "§" + String(par.id) + "\n"
            }
        }
        else if kindOfSource == 1 || kindOfSource == 2 || kindOfSource == 3 || kindOfSource == 4 {
            if par.id < 10000 {
                references = "§" + String(par.id) + "\n"
            }
        }
        if par.refs != "" {
            text_refs = "\n\nOdkazy:" + par.refs
        }
        if par.caption != "" {
            caption = par.caption + "<br><br>"
        }
        let main_text = "\(caption)\(references)\(par.text)\(text_refs)"
        return generateContent(text: main_text)
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
