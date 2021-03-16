//
//  CatechismCollectionViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class CatechismCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "CatechismCollectionViewCell"

    //MARK: Properties

    var name: String?

    lazy var catechismLabel: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    func configureCell(name: String) {
        let userDefaults = UserDefaults.standard
        let darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        print("Catechism \(darkMode) and \(name)")
        if darkMode == true {
            catechismLabel.textColor = KKCTextNightMode
            catechismLabel.backgroundColor = KKCBackgroundNightMode
        }
        else {
            catechismLabel.textColor = KKCTextLightMode
            catechismLabel.backgroundColor = KKCBackgroundLightMode
        }
        self.addSubview(catechismLabel)
        catechismLabel.text = name
        catechismLabel.textAlignment = .left
        addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: catechismLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: catechismLabel)
        //catechismLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -50).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
