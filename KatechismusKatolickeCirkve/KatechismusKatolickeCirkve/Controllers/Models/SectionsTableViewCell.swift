//
//  SectionsTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 10/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SectionsTableViewCell: UITableViewCell {

    static let cellId = "SectionsTableViewCell"
    
    //MARK: Properties

    lazy var sectionLabel: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var subsectionLabel: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    func configureCell(data: SectionsRowData) {
        let userDefaults = UserDefaults.standard
        let darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        
        sectionLabel.attributedText = generateContent(text: data.name)
        subsectionLabel.attributedText = generateContent(text: data.sub_sections, size: CGFloat(12))
        self.accessoryType = .none
        self.isUserInteractionEnabled = false
        if data.exist_paragraph == true {
            self.isUserInteractionEnabled = true
            self.accessoryType = .disclosureIndicator
        }
        if data.main_section == true {
            self.backgroundColor = KKCMainColor
            self.sectionLabel.textColor = KKCTextNightMode

        } else {
            if darkMode == true {
                self.backgroundColor = KKCBackgroundNightMode
                self.sectionLabel.backgroundColor = KKCBackgroundNightMode
                self.sectionLabel.textColor = KKCTextNightMode
            }
            else {
                self.backgroundColor = KKCBackgroundLightMode
                self.sectionLabel.backgroundColor = KKCBackgroundLightMode
                self.sectionLabel.textColor = KKCTextLightMode
            }
        }
        contentView.addSubview(stackView)
        stackView.addSubview(sectionLabel)
        stackView.addSubview(subsectionLabel)
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10).isActive = true
        sectionLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 5).isActive = true
        sectionLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 5).isActive = true
        subsectionLabel.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 10).isActive = true
        subsectionLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 5).isActive = true
        subsectionLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -5).isActive = true
        subsectionLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10).isActive = true
        stackView.addConstraintsWithFormat(format: "V:|-5-[v0]-10-[v1]-5-|", views: sectionLabel, subsectionLabel)
        
        stackView.addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: sectionLabel)
        stackView.addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: subsectionLabel)
    }

}
