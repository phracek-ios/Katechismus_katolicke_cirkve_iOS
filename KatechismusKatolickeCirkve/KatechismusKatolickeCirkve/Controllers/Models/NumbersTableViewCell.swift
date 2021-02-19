//
//  NumbersTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 09/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class NumbersTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //numberLabel.layer.cornerRadius = numberLabel.frame.height / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
