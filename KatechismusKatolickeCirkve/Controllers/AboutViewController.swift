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

    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var darkMode: Bool = false
    var text_dark: String = ""
    var text_light: String = ""
    var font_name: String = "Helvetica"
    var font_size: CGFloat = 16
    var about_project: Bool = false // true for project
    fileprivate var catechismStructure: CatechismStructure?
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    let text = "Katechismus katolické církve.<br>Offline mobilní verze pro iOS.<br><br>Autor aplikace: Petr Hráček<br>Autorská práva byla poskytnuta Karmelitánským nakladatelstvím.<br><br>Tato aplikace vznikla se souhlasem a za podpory České biskupské konference a byla finančně podpořena společností.<br><br>Na vývoji se stále pracuje.<br><br>Přepis textů spolu s autorem zajišťovali Pavel Souček a Josef Řídký.<br><br>Případné chyby, připomínky, nápady či postřehy prosím začlete na adresu: phracek@gmail.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if about_project {
            title = "O projektu"
        }
        else {
            title = "O aplikaci"
        }

        let userDefaults = UserDefaults.standard
        if let saveFontName = userDefaults.string(forKey: keys.fontName) {
            self.font_name = saveFontName
        } else {
            userDefaults.set("Helvetica", forKey: keys.fontName)
        }
        if let saveFontSize = userDefaults.string(forKey: keys.fontSize) {
            guard let n = NumberFormatter().number(from: saveFontSize) else { return }
            self.font_size = CGFloat(truncating: n)
        } else {
            userDefaults.set(16, forKey: keys.fontSize)
            self.font_size = 16
        }
        setupView()
        if about_project {
            catechismStructure = CatechismDataService.shared.catechismStructure
            // Do any additional setup after loading the view.
            guard let catechismStructure = catechismStructure else { return }
            let karmelText = "Karmelitánské nakladatelství"
            let paulinText = "Paulínek"
            let cbkText = "České biskupské konference"
            let donumText = "Donum"
            let text = "\(catechismStructure.about_project_1)\(karmelText)\(catechismStructure.about_project_1a)\(donumText) nebo u \(paulinText).\n\n\(catechismStructure.about_project_1b)\(cbkText)\(catechismStructure.about_project_1c)\(catechismStructure.about_project_2)\(catechismStructure.about_project_3)\(karmelText)\(catechismStructure.about_project_3a)"

            let userDefaults = UserDefaults.standard
            self.darkMode = userDefaults.bool(forKey: keys.NightSwitch)
            var attributedText: NSMutableAttributedString
            if self.darkMode {
                self.view.backgroundColor = KKCBackgroundNightMode
                self.textView.backgroundColor = KKCBackgroundNightMode
                attributedText = NSMutableAttributedString(string: text, attributes: [
                                                            NSAttributedString.Key.foregroundColor: KKCTextNightMode,
                                                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
            } else {
                self.view.backgroundColor = KKCBackgroundLightMode
                self.textView.backgroundColor = KKCBackgroundLightMode
                attributedText = NSMutableAttributedString(string: text, attributes: [
                                                            NSAttributedString.Key.foregroundColor: KKCTextLightMode,
                                                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
            }
            print(text)
            print(attributedText)
            var numberWords = 0
            attributedText.addAttribute(.link, value: URL(string: Constants.Link.karmelCz)!, range: NSRange(location:catechismStructure.about_project_1.count, length: karmelText.count))
            numberWords += catechismStructure.about_project_1.count + cbkText.count + catechismStructure.about_project_1a.count + 2
            attributedText.addAttribute(.link, value: URL(string: Constants.Link.donumCz)!, range: NSRange(location:numberWords, length: donumText.count))
            numberWords += donumText.count + 8
            attributedText.addAttribute(.link, value: URL(string: Constants.Link.paulinkyCz)!, range: NSRange(location: numberWords, length: paulinText.count))
            numberWords += catechismStructure.about_project_1b.count + 10
            attributedText.addAttribute(.link, value: URL(string: Constants.Link.cbkCz)!, range: NSRange(location:numberWords, length: cbkText.count + 1))
            numberWords += catechismStructure.about_project_1c.count + catechismStructure.about_project_2.count + catechismStructure.about_project_3.count + 27
            attributedText.addAttribute(.link, value: URL(string: Constants.Link.karmelCz)!, range: NSRange(location: numberWords, length: karmelText.count))
            self.textView.attributedText = attributedText
            self.textView.delegate = self

        }
        else {
            textView.attributedText = generateContent(text: text)
        }
        self.darkMode = userDefaults.bool(forKey: keys.NightSwitch)
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

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    
    func darkModeEnabled() {
        self.darkMode = true
        self.view.backgroundColor = KKCBackgroundNightMode
        //self.contentView.backgroundColor = KKCBackgroundNightMode
        self.textView.backgroundColor = KKCBackgroundNightMode
        self.textView.textColor = KKCTextNightMode
    }
    
    func darkModeDisabled() {
        self.darkMode = false
        self.view.backgroundColor = KKCBackgroundLightMode
        //self.contentView.backgroundColor = KKCBackgroundLightMode
        self.textView.backgroundColor = KKCBackgroundLightMode
        self.textView.textColor = KKCTextLightMode
    }
}

extension AboutViewController {
    private func setupView() {
        self.view.addSubview(stackView)
        stackView.addSubview(textView)
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 5).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -10).isActive = true
        textView.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
}
