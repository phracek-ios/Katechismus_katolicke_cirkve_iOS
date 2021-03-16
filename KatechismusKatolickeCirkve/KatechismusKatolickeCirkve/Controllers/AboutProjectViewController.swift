//
//  AboutProjectViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class AboutProjectViewController: UIViewController {

    lazy var labelAppl1: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var scrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    fileprivate var catechismStructure: CatechismStructure?
    var darkMode: Bool = true
    var text_dark: String = ""
    var text_light: String = ""
    var about_project: Bool = false // true for project

    override func viewDidLoad() {
        super.viewDidLoad()
        if about_project {
            title = "O projektu"
        }
        else {
            title = "O aplikaci"
        }

        catechismStructure = CatechismDataService.shared.catechismStructure
        // Do any additional setup after loading the view.
        guard let catechismStructure = catechismStructure else { return }
        let karmelText = "Karmelitánské nakladatelství"
        let paulinText = "Paulínek"
        let cbkText = "České biskupské konference"
        let donumText = "Donum"
        let text = "\(catechismStructure.about_project_1)\(karmelText)\(catechismStructure.about_project_1a)\(donumText) nebo u \(paulinText).\n\n\(catechismStructure.about_project_1b)\(cbkText)\(catechismStructure.about_project_1c)\(catechismStructure.about_project_2)\(catechismStructure.about_project_3)\(karmelText)\(catechismStructure.about_project_3a)"

        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        var attributedText: NSAttributedString
        if self.darkMode {
            self.view.backgroundColor = KKCBackgroundNightMode
            //contentLabel.backgroundColor = KKCBackgroundNightMode
            attributedText = NSAttributedString(string: text, attributes: [
                NSAttributedStringKey.foregroundColor: KKCTextNightMode,
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        } else {
            self.view.backgroundColor = KKCBackgroundLightMode
            //contentLabel.backgroundColor = KKCBackgroundLightMode
            attributedText = NSAttributedString(string: text, attributes: [
                NSAttributedStringKey.foregroundColor: KKCTextLightMode,
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        }
        //contentLabel.textInsets = UIEdgeInsets(top: 10, left: 10, bottom: 15, right: 10)
        //contentLabel.setText(attributedText)
        var numberWords = 0
        //contentLabel.addLink(to: URL(string: Constants.Link.karmelCz)!, with: NSRange(location:catechismStructure.about_project_1.count, length: karmelText.count))
        numberWords += catechismStructure.about_project_1.count + cbkText.count + catechismStructure.about_project_1a.count + 2
        //contentLabel.addLink(to: URL(string: Constants.Link.donumCz)!,with: NSRange(location:numberWords, length: donumText.count))
        numberWords += donumText.count + 8
        //contentLabel.addLink(to: URL(string: Constants.Link.paulinkyCz)!,with: NSRange(location: numberWords, length: paulinText.count))
        numberWords += catechismStructure.about_project_1b.count + 10
        //contentLabel.addLink(to: URL(string: Constants.Link.cbkCz)!,with: NSRange(location:numberWords, length: cbkText.count + 1))
        numberWords += catechismStructure.about_project_1c.count + catechismStructure.about_project_2.count + catechismStructure.about_project_3.count + 27
        //contentLabel.addLink(to: URL(string: Constants.Link.karmelCz)!,with: NSRange(location: numberWords, length: karmelText.count))
        //contentLabel.delegate = self
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

}
