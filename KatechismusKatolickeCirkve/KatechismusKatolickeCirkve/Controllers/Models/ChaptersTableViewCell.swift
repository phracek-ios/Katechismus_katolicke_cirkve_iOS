//
//  ChaptersTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 09/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class ChaptersTableViewCell: UITableViewCell {

    static let cellId = "ChaptersTableViewCell"

    //MARK: Properties

    var name: String?

    lazy var chaptersLabel: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    

    func configureCell(name: String,  description: String) {
        let userDefaults = UserDefaults.standard
        let darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        if darkMode {
            chaptersLabel.textColor = KKCTextNightMode
            chaptersLabel.backgroundColor = KKCBackgroundNightMode
        }
        else {
            chaptersLabel.textColor = KKCTextLightMode
            chaptersLabel.backgroundColor = KKCBackgroundLightMode
        }
        self.addSubview(chaptersLabel)
        chaptersLabel.text = name
        chaptersLabel.textAlignment = .left
        addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: chaptersLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: chaptersLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
