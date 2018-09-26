//
//  AboutProjectViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import WebKit

class AboutProjectViewController: UIViewController, UITextViewDelegate{

    fileprivate var catechismStructure: CatechismStructure?
    @IBOutlet weak var aboutPrjWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        catechismStructure = CatechismDataService.shared.catechismStructure
        // Do any additional setup after loading the view.
        guard let catechismStructure = catechismStructure else { return }
        let htmlString = catechismStructure.about_project_1 + "<a href=\"https://www.ikarmel.cz\">Karmelitánské nakladatelství</a>" + catechismStructure.about_project_1a + "<a href=\"http://www.donum.cz\">Donum</a> nebo u <a href=\"https://www.paulinky.cz\">Paulínek</a>.<br><br>" + catechismStructure.about_project_1b + "<a href=\"https://www.cirkev.cz\">České biskupské konference</a>" + catechismStructure.about_project_1c + catechismStructure.about_project_2 + catechismStructure.about_project_3 + "<a href=\"https://www.ikarmel.cz\">Karmelitánské nakladatelství</a>" + catechismStructure.about_project_3a
        aboutPrjWebView.loadHTMLString("<html><body><font size=18" + htmlString + "</body></html>", baseURL: nil)
        
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
