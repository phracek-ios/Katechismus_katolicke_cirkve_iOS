//
//  FindWordViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 12/09/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation

class FindWordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var staticLabel: UILabel!
    @IBOutlet weak var labelForNoneResults: UILabel!
    var findData = [Int]()
    var findString: String = ""
    var darkMode: Bool = false
    fileprivate var paragraphStructure: ParagraphStructure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
        wordTextField.delegate = self
        wordTextField.returnKeyType = .done
        labelForNoneResults.isEnabled = false
        labelForNoneResults.text = ""
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
        if self.darkMode {
            self.darkModeEnable()
        } else {
            self.darkModeDisable()
        }
        navigationController?.navigationBar.barTintColor = KKCMainColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: KKCMainTextColor]
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
    }

    func darkModeEnable() {
        self.view.backgroundColor = KKCBackgroundNightMode
        self.labelForNoneResults.backgroundColor = KKCBackgroundNightMode
        self.labelForNoneResults.textColor = KKCTextNightMode
        self.staticLabel.backgroundColor = KKCBackgroundNightMode
        self.staticLabel.textColor = KKCTextNightMode
    }
    func darkModeDisable() {
        self.view.backgroundColor = KKCBackgroundLightMode
        self.labelForNoneResults.backgroundColor = KKCBackgroundLightMode
        self.labelForNoneResults.textColor = KKCTextLightMode
        self.staticLabel.backgroundColor = KKCBackgroundLightMode
        self.staticLabel.textColor = KKCTextLightMode
    }
    @objc private func darkModeEnabled(_ notification: Notification) {
        self.darkMode = true
        self.darkModeEnable()

    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        self.darkMode = false
        self.darkModeDisable()

    }
}
