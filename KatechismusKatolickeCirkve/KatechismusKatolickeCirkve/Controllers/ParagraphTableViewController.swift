//
//  ParagraphTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 13/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import WebKit

class ParagraphTableViewController: UITableViewController, UIWebViewDelegate {
    
    struct ParagraphRowData {
        var html: String
    }

    var heightOfWebView: CGFloat = 0
    
    fileprivate var paragraphRowData = [ParagraphRowData]()
    fileprivate var paragraphStructure: ParagraphStructure?

    var parentID: Int = 0
    var kindOfSource: Int = 0
    var rangeID: Int = 0
    var boolSouhrn: Bool = false
    var findWordData = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        loadParagraphs()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.alpha = 0
 
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
        
        cell.paragraphWebView.tag = indexPath.row
        cell.paragraphWebView.loadHTMLString("<font size=20>" + data.html, baseURL: nil)

        return cell
    }

    private func webViewDidFinishLoad(_ webView: WKWebView) {
        var frame: CGRect = webView.frame
        frame.size.height = 1
        webView.frame = frame
        let fittingSize = webView.sizeThatFits(CGSize.zero)
        frame.size = fittingSize
        webView.frame = frame
        heightOfWebView = fittingSize.height
        tableView.beginUpdates()
        tableView.endUpdates()
        print("Calling webViewDidFinishLoad. Cell size value: \(heightOfWebView)")
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfWebView
    }
    
    
    private func loadParagraphs() {
        guard let paragraphStructure = paragraphStructure else { return }
        
        if kindOfSource == 1 {
            for par in paragraphStructure.paragraph {
                if par.id >= parentID && par.id <= rangeID {
                    paragraphRowData.append(ParagraphRowData(html: get_html_text(par: par)))
                }
            }
        }
        else if kindOfSource == 0 {
            for par in paragraphStructure.paragraph {
                if par.chapter == parentID {
                    paragraphRowData.append(ParagraphRowData(html: get_html_text(par: par)))
                }
            }
        }
        else if kindOfSource == 2 {
            for par in paragraphStructure.paragraph {
                if findWordData.contains(par.id) {
                    paragraphRowData.append(ParagraphRowData(html: get_html_text(par: par)))
                    
                }
            }
        }
    }
    private func get_html_text(par: Paragraph) -> String {
        var references: String = "<br>"
        if parentID != 1 && parentID != 2 {
            references = "<br><br>§" + String(par.id) + " "
        }
        if par.refs != "" {
            references = references + " Odkazy:" + par.refs
        }
        if boolSouhrn {
            
        }
        else {
            
        }
        if par.caption.range(of: "Souhrn") != nil {
            boolSouhrn = true
            return "<br><div style=\"background-color:green;\">" + par.caption + references + par.text + "</div>"
        }
        else {
            return "<br>" + par.caption + references + par.text
        }
    }
}


