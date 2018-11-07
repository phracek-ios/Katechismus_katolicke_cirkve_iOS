//
//  ParagraphTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 13/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation

class ParagraphTableViewCell: UITableViewCell {

    @IBOutlet weak var labelParagraph: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}

// MARK: - Private
private extension ParagraphTableViewCell {
    
    func setupUI() {
        selectionStyle = .none
        labelParagraph.numberOfLines = 0
    }
}

