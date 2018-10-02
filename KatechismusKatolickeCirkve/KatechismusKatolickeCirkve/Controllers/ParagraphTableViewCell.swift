//
//  ParagraphTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 13/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class ParagraphTableViewCell: UITableViewCell {

    weak var viewController: UITableViewController? = nil
    @IBOutlet weak var paragraphWebView: WKWebView!
    @IBOutlet weak var paragraphHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        paragraphWebView.scrollView.isScrollEnabled = false
        paragraphWebView.uiDelegate = self as! WKUIDelegate
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension ParagraphTableViewCell: WKUIDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        paragraphHeightConstraint.constant = webView.scrollView.contentSize.height
        viewController?.tableView.beginUpdates()
        viewController?.tableView.endUpdates()
    }
}
