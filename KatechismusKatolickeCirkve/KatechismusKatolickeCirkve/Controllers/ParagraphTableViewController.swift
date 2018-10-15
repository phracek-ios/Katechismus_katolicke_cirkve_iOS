//
//  ParagraphTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 13/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import BonMot

class ParagraphTableViewController: UITableViewController {
    
    struct ParagraphRowData {
        var html: String
        var recap: Int
    }

    var heightOfWebView: CGFloat = 0
    
    fileprivate var paragraphRowData = [ParagraphRowData]()
    fileprivate var paragraphStructure: ParagraphStructure?

    var boolSouhrn: Bool = false
    var parentID: Int = 0
    var kindOfSource: Int = 0
    var rangeID: Int = 0
    var findWordData = [Int]()
    
    var isStatusBarHidden = false {
        didSet {
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
}        }
    }
    
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
        loadParagraphs()
        self.tableView.alpha = 0
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self as! UIGestureRecognizerDelegate
        self.tableView.alpha = 1
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
        cell.labelParagraph?.attributedText = generateContent(text: data.html)
        cell.labelParagraph?.font = UIFont(name: cell.labelParagraph.font.fontName, size: 18)
        if data.recap == 1 {
            cell.backgroundColor = KKCMainColor
            cell.labelParagraph?.textColor = UIColor.white
        }
        else {
            cell.backgroundColor = UIColor.white
            cell.labelParagraph?.textColor = UIColor.black
        }

        return cell
    }

    private func generateContent(text: String) -> NSAttributedString {
        let strong = StringStyle()
        let emphasized = StringStyle()
        let small = StringStyle()
        let paragraph = StringStyle()
        
        let rules: [XMLStyleRule] = [
            .style("em", emphasized),
            .style("b", strong),
            .style("small", small),
            .style("p", paragraph)
        ]
        let font = R.font.ubuntuMedium(size: 18)
        let content = StringStyle(
            .font(font),
            .color(UIColor.white),
            .lineHeightMultiple(1),
            .xmlRules(rules)
        )
        return text.styled(with: content)
    }
    private func loadParagraphs() {
        guard let paragraphStructure = paragraphStructure else { return }
        
        if kindOfSource == 1 {
            for par in paragraphStructure.paragraph {
                if par.id >= parentID && par.id <= rangeID {
                    paragraphRowData.append(ParagraphRowData(html: get_html_text(par: par),
                                                             recap: par.recap))
                }
            }
        }
        else if kindOfSource == 0 {
            for par in paragraphStructure.paragraph {
                if par.chapter == parentID {
                    paragraphRowData.append(ParagraphRowData(html: get_html_text(par: par),
                                                             recap: par.recap))
                }
            }
        }
        else if kindOfSource == 2 {
            for par in paragraphStructure.paragraph {
                if findWordData.contains(par.id) {
                    paragraphRowData.append(ParagraphRowData(html: get_html_text(par: par),
                                                             recap: par.recap))
                }
            }
        }
    }
    private func get_html_text(par: Paragraph) -> String {
        var references: String = ""
        var caption: String = ""
        var text: String = ""
        if kindOfSource == 0 && parentID != 1 && parentID != 2 {
            if par.id < 10000 {
                references = "§" + String(par.id) + "<br>"
            }
        }
        else if kindOfSource == 1 || kindOfSource == 2 {
            if par.id < 10000 {
                references = "§" + String(par.id) + "<br>"
            }
        }
        text = par.text
        if par.refs != "" {
            text += "<br><br>Odkazy:" + par.refs
        }
        if par.caption != "" {
            caption = par.caption + "<br><br>"
        }
        
        return caption + references + text
    }
}


