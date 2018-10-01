//
//  ChaptersTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 09/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class ChaptersTableViewCell: UITableViewCell {

    @IBOutlet weak var chapterLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        chapterLabel.layer.cornerRadius = chapterLabel.frame.height / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
