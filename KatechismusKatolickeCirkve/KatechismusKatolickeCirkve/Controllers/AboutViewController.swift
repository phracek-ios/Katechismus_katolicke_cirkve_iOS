//
//  AboutViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    //MARK: Properties
    fileprivate var catechismStructure: CatechismStructure?
    @IBOutlet weak var aboutMainTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catechismStructure = CatechismDataService.shared.catechismStructure
        // Do any additional setup after loading the view.
        guard let catechismStructure = catechismStructure else { return }
        let fullString = NSMutableAttributedString(string: catechismStructure.about_appl_1)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "delpsys")
        let imageString = NSAttributedString(attachment: imageAttachment)

        fullString.append(imageString)
        fullString.append(NSAttributedString(string: catechismStructure.about_appl_2))
        aboutMainTextView.attributedText = fullString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
