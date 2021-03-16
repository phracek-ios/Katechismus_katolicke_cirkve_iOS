//
//  NumbersDetailTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 05/09/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class NumbersDetailTableViewCell: UITableViewCell {

    //MARK: Properties
    
    static let cellId = "NumbersTableViewCell"

    lazy var numberDetails: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    

    func configureCell(number: String) {
        let userDefaults = UserDefaults.standard
        let darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        if darkMode {
            numberDetails.textColor = KKCTextNightMode
            numberDetails.backgroundColor = KKCBackgroundNightMode
        }
        else {
            numberDetails.textColor = KKCTextLightMode
            numberDetails.backgroundColor = KKCBackgroundLightMode
        }
        self.addSubview(numberDetails)
        numberDetails.text = number
        numberDetails.textAlignment = .left
        addConstraintsWithFormat(format: "V:|[v0]|", views: numberDetails)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: numberDetails)
    }

}
