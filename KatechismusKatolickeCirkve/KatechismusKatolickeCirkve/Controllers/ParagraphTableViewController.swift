//
//  ParagraphTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 13/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import WebKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        loadParagraphs()
        self.tableView.alpha = 0
        //self.tableView.reloadData()
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        
        if data.recap == 1 {
            cell.backgroundColor = UIColor.darkGray
        }
        cell.labelParagraph?.numberOfLines = 0
        cell.labelParagraph?.attributedText = data.html.htmlToAttributedString
        cell.labelParagraph?.font = UIFont(name: cell.labelParagraph.font.fontName, size: 18)

        return cell
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
        if parentID != 1 && parentID != 2 {
            references = "§" + String(par.id) + "<br>"
        }
        text = par.text
        if par.refs != "" {
            text += "<br>Odkazy:" + par.refs
        }
        if par.caption != "" {
            caption = par.caption + "<br>"
        }
        
        return caption + references + text
    }
}


