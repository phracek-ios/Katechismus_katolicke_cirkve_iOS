//
//  AboutViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class AboutViewController: UIViewController, UITextViewDelegate {

    //MARK: Properties
    fileprivate var catechismStructure: CatechismStructure?
    @IBOutlet weak var aboutMainWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        catechismStructure = CatechismDataService.shared.catechismStructure
        // Do any additional setup after loading the view.
        guard let catechismStructure = catechismStructure else { return }
        
        let htmlStringPart1 = catechismStructure.about_appl_1 + "\n"
        var htmlImage: String = ""
        if let image = UIImage(named: "delpsys"),
            let data = UIImagePNGRepresentation(image) {
                let base64 = data.base64EncodedString(options: [])
                let url = "data:application/png;base64," + base64
            htmlImage = "<img style=\"width: 100%\" src='\(url)'>"
        }
        
        let htmlStringPart2 = catechismStructure.about_appl_2 +
            "<a href=\"phracek@gmail.com\">phracek@gmail.com</a>" +
            catechismStructure.about_appl_2a + "<a href=\"https://github.com/phracek/Katechismus_katolicke_cirkve_iOS/issues\">zde.</a>"
        aboutMainWebView.loadHTMLString("<html><body><font size=18" + htmlStringPart1 + "<br><br>" + htmlImage + htmlStringPart2 + "</body></html>", baseURL: nil)
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

