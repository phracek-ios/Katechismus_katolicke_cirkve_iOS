//
//  ParagraphViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 10/09/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import WebKit

class ParagraphViewController: UIViewController, WKNavigationDelegate {

    var kindOfSource: Int = 0
    var parentID: Int = 0
    var rangeID: Int = 0
    var htmlContent: String = ""
    var boolSouhrn: Bool = false
    var currentID: Int = 0
    
    var findWordData = [Int]()
    
    fileprivate var paragraphStructure: ParagraphStructure?
    
    @IBOutlet weak var paragraphWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
        loadParagraphs()
        self.paragraphWebView.alpha = 0
        self.paragraphWebView.scrollView.indicatorStyle = UIScrollViewIndicatorStyle.black

        paragraphWebView.loadHTMLString("<html><body><font size=20" + self.htmlContent + "</body></html>", baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.paragraphWebView.alpha = 1

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.paragraphWebView.alpha = 1
    }
    private func loadParagraphs() {
        guard let paragraphStructure = paragraphStructure else { return }
        
        if kindOfSource == 1 {
            for par in paragraphStructure.paragraph {
                if par.id >= parentID && par.id <= rangeID {
                    self.htmlContent += get_html_text(par: par)
                }
            }
        }
        else if kindOfSource == 0 {
            for par in paragraphStructure.paragraph {
                if par.chapter == parentID {
                    self.htmlContent += get_html_text(par: par)
                }
            }
        }
        else if kindOfSource == 2 {
            for par in paragraphStructure.paragraph {
                if findWordData.contains(par.id) {
                    self.htmlContent += get_html_text(par: par)
                    
                }
            }
        }
    }
    private func get_html_text(par: Paragraph) -> String {
        var start: String = ""
        var refs: String = ""
        var header: String = ""
        if parentID != 1 && parentID != 2 {
            start = "§" + String(par.id) + "<br>"
        }
        if par.caption != "" {
            header = par.caption + "<br><br>" + start
        }
        else {
            header = start
        }
        if par.refs != "" {
            refs = "<br><br>Odkazy na katechismus:<br>" + par.refs + "<br>"
        }
        else {
            refs = "<br>"
        }
        if par.caption.range(of: "Souhrn") != nil {
            return "<br><div style=\"background-color:green;\">" + header + par.text + refs + "</div>"
        }
        else {
            return "<br>" + header + par.text + refs
        }
    }
}
