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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
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
        var caption: String = ""
        if data.caption != "" {
            caption = data.caption + "<br>"
        }
        let htmlText = "§\(data.id)<p>" + caption + data.text + "</p>"
        cell.paragraphLabel.textColor = UIColor.black
        cell.paragraphLabel.attributedText = htmlText.htmlToAttributedString
        return cell
    }


    private func loadParagraphs() {
        guard let paragraphStructure = paragraphStructure else { return }
        for par in paragraphStructure.paragraph {
            if par.chapter == parentID {
                paragraphRowData.append(ParagraphRowData(chapter: par.chapter, caption: par.caption, refs: par.refs, id: par.id, text: par.text))
            }
        }
        print(paragraphRowData)
        print(paragraphRowData.count)
    }

}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
