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
        aboutPrjTextView.isEditable = false
        aboutPrjTextView.isSelectable = false
        let carmelPublishing: String = "<a href=\"www.ikarmel.cz\">Karmelitánské nakladatelství</a>"
        let donumPublishing: String = "<a href=\"www.donum.cz\">Donum</a>"
        let paulinPublishing: String = "<a href=\"www.paulinky.cz\">Paulínek</a>"
        let cbkPublishing: String = "<a href=\"www.cbk.cz\">České biskupstké konference</a>"
        let attributedPrjFirst = NSMutableAttributedString(string: catechismStructure.about_project_1)
        let carmelNSMutableAttributeString = NSMutableAttributedString(string: "Karmelitánské nakladatelství")
        carmelNSMutableAttributeString.addAttribute(.link, value: "https://www.ikarmel.cz", range: NSRange(location: 9, length: carmelNSMutableAttributeString.length))
        attributedPrjFirst.append(carmelNSMutableAttributeString)
        attributedPrjFirst.append(NSAttributedString(string: catechismStructure.about_project_1a))
        attributedPrjFirst.append(donumPublishing.htmlToAttributedString!)
        attributedPrjFirst.append(NSAttributedString(string: " nebo u "))
        attributedPrjFirst.append(paulinPublishing.htmlToAttributedString!)
        attributedPrjFirst.append(NSAttributedString(string: ".\n\n"))
 
        attributedPrjFirst.append(NSAttributedString(string: catechismStructure.about_project_1b))
        attributedPrjFirst.append(cbkPublishing.htmlToAttributedString!)
        attributedPrjFirst.append(NSAttributedString(string: catechismStructure.about_project_1c))

        attributedPrjFirst.append(NSAttributedString(string: catechismStructure.about_project_2))

        attributedPrjFirst.append(NSAttributedString(string: catechismStructure.about_project_3))
        attributedPrjFirst.append(carmelPublishing.htmlToAttributedString!)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
