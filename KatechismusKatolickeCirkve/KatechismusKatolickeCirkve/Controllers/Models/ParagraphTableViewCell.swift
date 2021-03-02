//
//  ParagraphTableViewCell.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 13/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation

class ParagraphTableViewCell: UITableViewCell {

    static let cellId = "ParagraphTableViewCell"
    
    //MARK: Properties

    lazy var labelParagraph: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var starImage: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.sizeToFit()
        return iv
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    func configureCell(name: NSAttributedString, image_name: String) {
        let userDefaults = UserDefaults.standard
        let darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        print(darkMode)
        if darkMode == true {
            labelParagraph.textColor = KKCTextNightMode
            labelParagraph.backgroundColor = KKCBackgroundNightMode
            self.backgroundColor = KKCBackgroundNightMode
        }
        else {
            labelParagraph.textColor = KKCTextLightMode
            labelParagraph.backgroundColor = KKCBackgroundLightMode
            self.backgroundColor = KKCBackgroundLightMode
        }
        let img = UIImage(named: image_name)
        let img_width: Int = 20
        starImage.image = img
        starImage.contentMode = .scaleAspectFit
        labelParagraph.attributedText = name
        contentView.addSubview(stackView)
        stackView.addSubview(starImage)
        stackView.addSubview(labelParagraph)
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        labelParagraph.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        labelParagraph.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10).isActive = true
        labelParagraph.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -20).isActive = true
        starImage.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        starImage.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        starImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        starImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        starImage.rightAnchor.constraint(equalTo: labelParagraph.leftAnchor, constant: -10).isActive = true
        stackView.addConstraintsWithFormat(format: "V:|-5-[v0(\(img_width))]", views: starImage)
        stackView.addConstraintsWithFormat(format: "V:|-5-[v0]-10-|", views: labelParagraph)
        
        stackView.addConstraintsWithFormat(format: "H:|-5-[v0(\(img_width))]-10-[v1]-20-|", views: starImage, labelParagraph)
        layoutIfNeeded()
    }
    
}
