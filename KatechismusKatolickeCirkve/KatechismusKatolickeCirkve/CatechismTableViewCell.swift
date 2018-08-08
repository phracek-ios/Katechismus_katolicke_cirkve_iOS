//
//  CatechismTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class CatechismTableViewCell: UITableViewCell {

    @IBOutlet weak var catechismImage: UIImageView!
    @IBOutlet weak var catechismLabel: UILabel!
    
    //MARK: Properties
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
