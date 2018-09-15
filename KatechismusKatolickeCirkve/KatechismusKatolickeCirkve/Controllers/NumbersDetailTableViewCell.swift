//
//  NumbersDetailTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 05/09/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class NumbersDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var numberDetails: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        numberDetails.layer.cornerRadius = numberDetails.frame.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
