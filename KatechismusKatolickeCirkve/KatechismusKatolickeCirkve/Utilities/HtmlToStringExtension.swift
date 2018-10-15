//
//  HtmlToStringExtension.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 18/09/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation
import BonMot

extension String {
    var htmlToAttributedString: NSAttributedString? {
        //guard let data = data(using: .utf8) else { return NSAttributedString() }
        guard let data = data(using: String.Encoding.unicode) else { return NSAttributedString() }
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

