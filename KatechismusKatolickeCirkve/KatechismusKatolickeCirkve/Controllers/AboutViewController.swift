//
//  AboutViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation
import BonMot

class AboutViewController: UIViewController {

    //MARK: Properties

    @IBOutlet weak var labelAppl1: UILabel!
    @IBOutlet weak var labelAppl2: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var darkMode: Bool = false
    var text_dark: String = ""
    var text_light: String = ""
    var font_name: String = "Helvetica"
    var font_size: CGFloat = 16
    
    let text_appl1 = "Katechismus katolické církve.<br>Offline mobilní verze pro iOS.<br><br>Autor aplikace: Petr Hráček<br>Autorská práva byla poskytnuta Karmelitánským nakladatelstvím.<br><br>Tato aplikace vznikla se souhlasem a za podpory České biskupské konference a byla finančně podpořena společností"
    let text_appl2 = "Na vývoji se stále pracuje.<br><br>Přepis textů spolu s autorem zajišťovali Pavel Souček a Josef Řídký.<br><br>Případné chyby, připomínky, nápady či postřehy prosím začlete na adresu: phracek@gmail.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "O aplikaci"

        let userDefaults = UserDefaults.standard
        if let saveFontName = userDefaults.string(forKey: "FontName") {
            self.font_name = saveFontName
        } else {
            userDefaults.set("Helvetica", forKey: "FontName")
        }
        if let saveFontSize = userDefaults.string(forKey: "FontSize") {
            guard let n = NumberFormatter().number(from: saveFontSize) else { return }
            self.font_size = CGFloat(truncating: n)
        } else {
            userDefaults.set(16, forKey: "FontSize")
            self.font_size = 16
        }
        labelAppl1.attributedText = generateContent(text: text_appl1, font_name: self.font_name, size: self.font_size)
        labelAppl2.attributedText = generateContent(text: text_appl2, font_name: self.font_name, size: self.font_size)
        labelAppl1.numberOfLines = 0
        labelAppl2.numberOfLines = 0
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        if self.darkMode {
            darkModeEnabled()
        } else {
            darkModeDisabled()
        }
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func darkModeEnabled() {
        self.darkMode = true
        self.view.backgroundColor = KKCBackgroundNightMode
        self.contentView.backgroundColor = KKCBackgroundNightMode
        self.labelAppl1.backgroundColor = KKCBackgroundNightMode
        self.labelAppl1.textColor = KKCTextNightMode
        self.labelAppl2.backgroundColor = KKCBackgroundNightMode
        self.labelAppl2.textColor = KKCTextNightMode    }
    
    func darkModeDisabled() {
        self.darkMode = false
        self.view.backgroundColor = KKCBackgroundLightMode
        self.contentView.backgroundColor = KKCBackgroundLightMode
        self.labelAppl1.backgroundColor = KKCBackgroundLightMode
        self.labelAppl1.textColor = KKCTextLightMode
        self.labelAppl2.backgroundColor = KKCBackgroundLightMode
        self.labelAppl2.textColor = KKCTextLightMode    }
}

