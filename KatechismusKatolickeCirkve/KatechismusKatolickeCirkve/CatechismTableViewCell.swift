//
//  CatechismTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class CatechismTableViewCell: UITableViewCell {
    
    @IBOutlet weak var catechismLabel: UILabel!
    //MARK: Properties
    override func awakeFromNib() {
        super.awakeFromNib()
        //catechismLabel.layer.cornerRadius = catechismLabel.frame.height / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //catechismLabel.layer.cornerRadius = catechismLabel.frame.height / 4
    }

}
