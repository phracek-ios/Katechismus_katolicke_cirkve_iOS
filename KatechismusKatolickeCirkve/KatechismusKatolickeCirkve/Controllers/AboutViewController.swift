//
//  AboutViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation


class AboutViewController: UIViewController {

    //MARK: Properties
    fileprivate var catechismStructure: CatechismStructure?
    @IBOutlet weak var aboutMainTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catechismStructure = CatechismDataService.shared.catechismStructure
        // Do any additional setup after loading the view.
        guard let catechismStructure = catechismStructure else { return }
        aboutMainTextView.dataDetectorTypes = .link
        aboutMainTextView.isEditable = false
        aboutMainTextView.isSelectable = false
        let delpsysHtml: String = "<a href=\"www.deplsys.cz\">DelpSys</a>"
        let attributedNewLine = NSMutableAttributedString(string: "\n")
        let attributedAboutFirst = NSMutableAttributedString(string: catechismStructure.about_appl_1)
        attributedAboutFirst.append(delpsysHtml.htmlToAttributedString!)
        attributedAboutFirst.append(attributedNewLine)
        let delpsys = UIImage(named: "delpsys")
        let imageAttachment = NSTextAttachment()
        let newImageWidth = (aboutMainTextView.bounds.size.width - 10)
        let scale = newImageWidth / (delpsys?.size.width)!
        let newImageHeight = (delpsys?.size.height)! * scale
        imageAttachment.bounds = CGRect.init(x: 0, y: 0, width: newImageWidth, height: newImageHeight)

        imageAttachment.image = delpsys
        let imageString = NSAttributedString(attachment: imageAttachment)

        let attrStringWithImage = NSAttributedString(attachment: imageAttachment)
        attributedAboutFirst.append(attrStringWithImage)
        attributedAboutFirst.append(NSAttributedString(string: catechismStructure.about_appl_2))
        let email: String = "<a href=\"phracek@gmail.com\">phracek@gmail.com</a>"
        attributedAboutFirst.append(email.htmlToAttributedString!)
        attributedAboutFirst.append(NSAttributedString(string: catechismStructure.about_appl_2a))
        let issues: String = "<a href=\"https://github.com/phracek/Katechismus_katolicke_cirkve_iOS/issues\">zde.</a>"
        attributedAboutFirst.append(issues.htmlToAttributedString!)
        aboutMainTextView.attributedText = attributedAboutFirst
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

