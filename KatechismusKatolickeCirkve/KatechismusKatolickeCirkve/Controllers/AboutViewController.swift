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

class AboutViewController: BaseViewController, UITextViewDelegate {

    //MARK: Properties
    fileprivate var catechismStructure: CatechismStructure?
    @IBOutlet weak var aboutMainWebView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var darkMode: Bool = false
    var text_dark: String = ""
    var text_light: String = ""
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
        "<a href=\"phracek@gmail.com\">phracek@gmail.com</a>"// +
        //    catechismStructure.about_appl_2a + "<a href=\"https://github.com/phracek/Katechismus_katolicke_cirkve_iOS/issues\">zde.</a>"
        let text = htmlStringPart1 + "<br><br>" + htmlImage + htmlStringPart2
        self.text_dark = "<div style=\"color:#ffffff\"><font size=20>" + text + "</font></div></body></html>"
        self.text_light = "<div style=\"color:#000000\"><font size=20>" + text + "</font></div></body></html>"
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        self.aboutMainWebView.isOpaque = false
        if self.darkMode {
            self.view.backgroundColor = KKCBackgroundNightMode
            aboutMainWebView.backgroundColor = KKCBackgroundNightMode
            aboutMainWebView.tintColor = KKCTextNightMode
            titleLabel.textColor = KKCTextNightMode
            
            aboutMainWebView.loadHTMLString("<html><body>" + self.text_dark, baseURL: nil)
        } else {
            self.view.backgroundColor = KKCBackgroundLightMode
            aboutMainWebView.backgroundColor = KKCBackgroundLightMode
            aboutMainWebView.tintColor = KKCTextLightMode
            titleLabel.textColor = KKCTextLightMode
            
            aboutMainWebView.loadHTMLString("<html><body>" + self.text_light, baseURL: nil)
        }
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)

    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return false
    }
    @objc private func darkModeEnabled(_ notification: Notification) {
        self.darkMode = true
        self.view.backgroundColor = KKCBackgroundNightMode
        self.aboutMainWebView.backgroundColor = KKCBackgroundNightMode
        aboutMainWebView.loadHTMLString("<html><body>" + self.text_dark, baseURL: nil)
        titleLabel.textColor = KKCTextNightMode
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        self.darkMode = false
        self.view.backgroundColor = KKCBackgroundLightMode
        self.aboutMainWebView.backgroundColor = KKCBackgroundLightMode
        aboutMainWebView.loadHTMLString("<html><body>" + self.text_light, baseURL: nil)
        titleLabel.textColor = KKCTextLightMode
    }
}

