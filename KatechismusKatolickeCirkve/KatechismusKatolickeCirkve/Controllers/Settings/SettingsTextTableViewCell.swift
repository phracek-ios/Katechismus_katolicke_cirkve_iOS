//
//  SettingsTextTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 14.03.2021.
//  Copyright © 2021 Petr Hracek. All rights reserved.
//

import UIKit

class SettingsTextTableViewCell: UITableViewCell {

    static let cellId = "settingsTextItem"
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    var title : UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18)
        l.backgroundColor = .clear
        return l
    }()
    
    
    var detail : UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.backgroundColor = .clear
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        return l
    }()
    
    var settingsItem : SettingsItem?
    
    func configureCell(settingsItem: SettingsItem, cellWidth: CGFloat) {
        self.settingsItem = settingsItem
        let userDefaults = UserDefaults.standard
        let darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        addSubview(title)
        if settingsItem.detail.isEmpty != true {
            addSubview(detail)
        }
        if darkMode == true {
            title.backgroundColor = KKCBackgroundNightMode
            title.textColor = KKCTextNightMode
        }
        else {
            title.backgroundColor = KKCBackgroundLightMode
            title.textColor = KKCTextLightMode
        }
        title.text = settingsItem.title
        detail.text = settingsItem.detail
        selectionStyle = .none
        
        addConstraintsWithFormat(format: "H:|-12-[v0]", views: title)
        if settingsItem.detail.isEmpty != true {
            addConstraintsWithFormat(format: "H:|-12-[v0]", views: detail)
            addConstraintsWithFormat(format: "V:[v0]-5-[v1]-15-|", views: title, detail)
        }
        else
        {
            addConstraintsWithFormat(format: "V:|-10-[v0]", views: title)
        }
    }

}
