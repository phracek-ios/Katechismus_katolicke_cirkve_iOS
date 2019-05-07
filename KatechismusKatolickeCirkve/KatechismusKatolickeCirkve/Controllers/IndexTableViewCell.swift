//
//  IndexTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 08/03/2019.
//  Copyright © 2019 Petr Hracek. All rights reserved.
//

import UIKit

class IndexTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
