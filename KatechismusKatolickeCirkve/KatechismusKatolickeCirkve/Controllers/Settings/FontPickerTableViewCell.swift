//
//  FontPickerTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 04.03.2021.
//  Copyright © 2021 Petr Hracek. All rights reserved.
//


import UIKit

class FontPickerTableViewCell: UITableViewCell {

    static let cellId = "FontPickerTableViewCell"
    
    //MARK: Properties
    var font_name: String = ""
    var font_size: String = ""
    lazy var captionLabel: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var fontLabel: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.textAlignment = .right
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    
    func configureCell(){
        print("configureCell")
        let userDefaults = UserDefaults.standard
        let darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        print("FontPicker \(darkMode)")
        if darkMode {
            captionLabel.textColor = KKCTextNightMode
            captionLabel.backgroundColor = KKCBackgroundNightMode
            fontLabel.textColor = KKCTextNightMode
            fontLabel.backgroundColor = KKCBackgroundNightMode
        }
        else {
            captionLabel.textColor = KKCTextLightMode
            captionLabel.backgroundColor = KKCBackgroundLightMode
            fontLabel.textColor = KKCTextLightMode
            fontLabel.backgroundColor = KKCBackgroundLightMode
        }
        captionLabel.text = "Písmo"
        self.accessoryType = .disclosureIndicator
        fontLabel.text = "\(font_name), \(font_size)px"
        contentView.addSubview(stackView)
        stackView.addSubview(fontLabel)
        stackView.addSubview(captionLabel)
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        captionLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 10).isActive = true
        captionLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10).isActive = true
        //captionLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: fontLabel.leftAnchor, constant: -20).isActive = true
        captionLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 10).isActive = true
        fontLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 10).isActive = true
        fontLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -10).isActive = true
        fontLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10).isActive = true
        layoutIfNeeded()
    }
    
}
