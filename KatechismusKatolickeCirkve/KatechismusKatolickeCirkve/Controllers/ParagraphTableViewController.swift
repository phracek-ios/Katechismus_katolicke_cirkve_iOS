//
//  ParagraphTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 13/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class ParagraphTableViewController: UITableViewController {
    
    struct ParagraphRowData {
        var chapter: Int
        var caption: String
        var refs: String
        var id: Int
        var text: String
    }
    
    fileprivate var paragraphRowData = [ParagraphRowData]()
    fileprivate var paragraphStructure: ParagraphStructure?

    var parentID: Int = 0
    var kindOfSource: Int = 0
    var rangeID: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        loadParagraphs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
        var caption: String = "§\(data.id)<br><p>"
        if data.caption != "" {
            caption = data.caption + "<br>\(caption)"
        }
        let htmlText = caption + data.text + "</p>"
        cell.paragraphLabel?.textColor = UIColor.black
        cell.paragraphLabel?.attributedText = htmlText.htmlToAttributedString
        cell.paragraphLabel?.font = cell.paragraphLabel?.font.withSize(20)
        cell.selectionStyle = .none
        return cell
    }

    private func loadParagraphs() {
        guard let paragraphStructure = paragraphStructure else { return }
        if kindOfSource == 1 {
            for par in paragraphStructure.paragraph {
                if par.id >= parentID && par.id <= rangeID {
                    paragraphRowData.append(ParagraphRowData(chapter: par.chapter, caption: par.caption, refs: par.refs, id: par.id, text: par.text))
                }
            }
        }
        else if kindOfSource == 0 {
            for par in paragraphStructure.paragraph {
                if par.chapter == parentID {
                    paragraphRowData.append(ParagraphRowData(chapter: par.chapter, caption: par.caption, refs: par.refs, id: par.id, text: par.text))
                }
            }
        }
    }
}


