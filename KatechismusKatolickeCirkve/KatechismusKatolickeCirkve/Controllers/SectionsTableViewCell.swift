//
//  SectionsTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 10/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SectionsTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
