//
//  AboutProjectViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class AboutProjectViewController: UIViewController, UITextViewDelegate{

    fileprivate var catechismStructure: CatechismStructure?
    @IBOutlet weak var aboutPrjTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        catechismStructure = CatechismDataService.shared.catechismStructure
        // Do any additional setup after loading the view.
        guard let catechismStructure = catechismStructure else { return }
        
        aboutPrjTextView.dataDetectorTypes = .link
        aboutPrjTextView.isSelectable = true

        let attributedPrjFirst = NSMutableAttributedString(string: catechismStructure.about_project_1)
        let carmelPublishingMutAttrString = NSMutableAttributedString(string: "Karmelitánské nakladatelství")
        let paulinPublishingMutAttrString = NSMutableAttributedString(string: "Paulínek")
        let donumPublishingMutAttrString = NSMutableAttributedString(string: "Donum")
        let cbkPublishingMutAttrString = NSMutableAttributedString(string: "České biskupstké konference")
        let carmelURL: String = "https://www.ikarmel.cz"
        let paulinURL: String = "https://www.paulinky.cz"
        let donumURL: String = "http://www.donum.cz"
        let cbkURL: String = "https://www.cirkev.cz"
        
        carmelPublishingMutAttrString.addAttribute(.link, value: carmelURL, range: NSRange(location: 0, length: carmelPublishingMutAttrString.length))
        attributedPrjFirst.append(carmelPublishingMutAttrString)
        attributedPrjFirst.append(NSAttributedString(string: catechismStructure.about_project_1a))

        donumPublishingMutAttrString.addAttribute(.link, value: donumURL, range: NSRange(location: 0, length: donumPublishingMutAttrString.length))
        attributedPrjFirst.append(donumPublishingMutAttrString)
        attributedPrjFirst.append(NSAttributedString(string: " nebo u "))

        paulinPublishingMutAttrString.addAttribute(.link, value: paulinURL, range: NSRange(location: 0, length: paulinPublishingMutAttrString.length))
        attributedPrjFirst.append(paulinPublishingMutAttrString)
        attributedPrjFirst.append(NSAttributedString(string: ".\n\n"))
 
        attributedPrjFirst.append(NSAttributedString(string: catechismStructure.about_project_1b))

        cbkPublishingMutAttrString.addAttribute(.link, value: cbkURL, range: NSRange(location: 0, length: cbkPublishingMutAttrString.length))
        attributedPrjFirst.append(cbkPublishingMutAttrString)
        attributedPrjFirst.append(NSAttributedString(string: catechismStructure.about_project_1c))

        attributedPrjFirst.append(NSAttributedString(string: catechismStructure.about_project_2))

        attributedPrjFirst.append(NSAttributedString(string: catechismStructure.about_project_3))
        attributedPrjFirst.append(carmelPublishingMutAttrString)
        attributedPrjFirst.append(NSAttributedString(string: catechismStructure.about_project_3a))
       
        aboutPrjTextView.attributedText = attributedPrjFirst
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }

}
