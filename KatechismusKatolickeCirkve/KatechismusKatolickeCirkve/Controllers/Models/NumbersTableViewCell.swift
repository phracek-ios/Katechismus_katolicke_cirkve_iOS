//
//  NumbersTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 09/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class NumbersTableViewCell: UITableViewCell {

    //MARK: Properties
    
    static let cellId = "NumbersTableViewCell"

    lazy var numberLabel: UILabel = {
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
            numberLabel.textColor = KKCTextNightMode
            numberLabel.backgroundColor = KKCBackgroundNightMode
        }
        else {
            numberLabel.textColor = KKCTextLightMode
            numberLabel.backgroundColor = KKCBackgroundLightMode
        }
        self.addSubview(numberLabel)
        numberLabel.text = number
        numberLabel.textAlignment = .left
        addConstraintsWithFormat(format: "V:|[v0]|", views: numberLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: numberLabel)
    }

}
