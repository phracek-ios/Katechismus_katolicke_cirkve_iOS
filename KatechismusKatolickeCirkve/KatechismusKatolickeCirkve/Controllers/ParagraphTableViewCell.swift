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

    @IBOutlet weak var paragraphWebView: WKWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //paragraphWebView.uiDelegate = self as? WKUIDelegate
        //paragraphWebView.scrollView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
