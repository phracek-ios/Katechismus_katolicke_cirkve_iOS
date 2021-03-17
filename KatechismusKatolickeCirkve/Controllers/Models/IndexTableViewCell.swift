//
//  IndexTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 08/03/2019.
//  Copyright © 2019 Petr Hracek. All rights reserved.
//

import UIKit

class IndexTableViewCell: UITableViewCell {

    static let cellId = "IndexTableViewCell"
    
    //MARK: Properties

    lazy var indexLabel: UILabel = {
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
    
    
    func configureCell(name: NSAttributedString, refs: String){
        print("configureCell")
        let userDefaults = UserDefaults.standard
        let darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        if darkMode == true {
            indexLabel.textColor = KKCTextNightMode
            indexLabel.backgroundColor = KKCBackgroundNightMode
        }
        else {
            indexLabel.textColor = KKCTextLightMode
            indexLabel.backgroundColor = KKCBackgroundLightMode
        }
        indexLabel.attributedText = name
        if refs == "" {
            self.accessoryType = .none
            self.isUserInteractionEnabled = false
        }
        else {
            self.isUserInteractionEnabled = true
            self.accessoryType = .disclosureIndicator
        }
        contentView.addSubview(stackView)
        stackView.addSubview(indexLabel)
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        indexLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 10).isActive = true
        indexLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10).isActive = true
        indexLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -20).isActive = true
        indexLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 20).isActive = true
        layoutIfNeeded()
    }
    
}
