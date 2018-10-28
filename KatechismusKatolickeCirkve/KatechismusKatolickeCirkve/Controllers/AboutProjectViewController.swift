//
//  AboutProjectViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import WebKit

class AboutProjectViewController: BaseViewController, UITextViewDelegate{

    fileprivate var catechismStructure: CatechismStructure?
    @IBOutlet weak var contentTextView: UITextView!
    var darkMode: Bool = true
    var text_dark: String = ""
    var text_light: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "O projektu"

        catechismStructure = CatechismDataService.shared.catechismStructure
        // Do any additional setup after loading the view.
        guard let catechismStructure = catechismStructure else { return }
        //let htmlString = catechismStructure.about_project_1 + "<a href=\"https://www.ikarmel.cz\">Karmelitánské nakladatelství</a>" + catechismStructure.about_project_1a + "<a href=\"http://www.donum.cz\">Donum</a> nebo u <a href=\"https://www.paulinky.cz\">Paulínek</a>.<br><br>" + catechismStructure.about_project_1b + "<a href=\"https://www.cirkev.cz\">České biskupské konference</a>" + catechismStructure.about_project_1c + catechismStructure.about_project_2 + catechismStructure.about_project_3 + "<a href=\"https://www.ikarmel.cz\">Karmelitánské nakladatelství</a>" + catechismStructure.about_project_3a
        let text = "\(catechismStructure.about_project_1)Karmelitánské nakladatelství\(catechismStructure.about_project_1a) nebo u Paulínek.\n\n\(catechismStructure.about_project_1b)České biskupské konference\(catechismStructure.about_project_1c)\(catechismStructure.about_project_2)\(catechismStructure.about_project_3)Karmelitánské nakladatelství\(catechismStructure.about_project_3a)"
        
        contentTextView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 15, right: 10)
        contentTextView.text = text
        
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        if self.darkMode {
            self.view.backgroundColor = KKCBackgroundNightMode
            contentTextView.backgroundColor = KKCBackgroundNightMode
            contentTextView.textColor = KKCTextNightMode
        } else {
            self.view.backgroundColor = KKCBackgroundLightMode
            contentTextView.backgroundColor = KKCBackgroundLightMode
            contentTextView.textColor = KKCTextLightMode
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
        UIApplication.shared.open(URL)
        return false
    }
    @objc private func darkModeEnabled(_ notification: Notification) {
        self.darkMode = true
        self.view.backgroundColor = KKCBackgroundNightMode
        contentTextView.textColor = KKCTextNightMode
        contentTextView.backgroundColor = KKCBackgroundNightMode
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        self.darkMode = false
        self.view.backgroundColor = KKCBackgroundLightMode
        contentTextView.textColor = KKCTextLightMode
        contentTextView.backgroundColor = KKCBackgroundLightMode
    }
}
