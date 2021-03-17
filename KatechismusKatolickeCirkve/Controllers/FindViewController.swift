//
//  FindViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 22.02.2021.
//  Copyright © 2021 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation

class FindViewController: UIViewController, UITextFieldDelegate {
    var findData = [Int]()
    var findString: String = ""
    var darkMode: Bool = false
    
    var word_number_find: Bool = false // true for number find
    
    fileprivate var paragraphStructure: ParagraphStructure?
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    lazy var staticLabel: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var ok_button: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    lazy var labelForNoneResults: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var findTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.layer.borderColor = UIColor.black.cgColor
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var subsectionLabel: UILabel = {
        let l = UILabel()
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
        findTextField.delegate = self
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
        setupView()
        if self.darkMode {
            self.darkModeEnable()
        } else {
            self.darkModeDisable()
        }
        navigationController?.navigationBar.barTintColor = KKCMainColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: KKCMainTextColor]
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }

    private func setupView() {
        self.view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true

        stackView.addSubview(staticLabel)
        stackView.addSubview(findTextField)
        stackView.addSubview(labelForNoneResults)
        staticLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 20).isActive = true
        staticLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -20).isActive = true
        staticLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 20).isActive = true
        findTextField.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 20).isActive = true
        findTextField.topAnchor.constraint(equalTo: staticLabel.bottomAnchor, constant: 40).isActive = true

        labelForNoneResults.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 20).isActive = true
        labelForNoneResults.topAnchor.constraint(equalTo: findTextField.bottomAnchor, constant: 20).isActive = true
        labelForNoneResults.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -20).isActive = true
        //stackView.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: staticLabel)
        //stackView.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: findTextField)
        //stackView.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: labelForNoneResults)
        //stackView.addConstraintsWithFormat(format: "V:|-20-[v0]-40-[v1]-20-[v2]-|", views: staticLabel, findTextField, labelForNoneResults)
        if word_number_find {
            stackView.addSubview(ok_button)
            findTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -20).isActive = true
            findTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
            ok_button.topAnchor.constraint(equalTo: staticLabel.bottomAnchor, constant: 40).isActive = true
            ok_button.leftAnchor.constraint(equalTo: findTextField.rightAnchor, constant: 40).isActive = true

            findTextField.text = ""
            findTextField.returnKeyType = .done
            findTextField.keyboardType = .numbersAndPunctuation
            staticLabel.text = "Zvolte číslo paragrafu:"
            labelForNoneResults.isEnabled = false
            labelForNoneResults.text = ""
        }
        else
        {
            findTextField.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -20).isActive = true
            findTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -50).isActive = true

            findTextField.addTarget(self, action: #selector(self.textFieldShouldReturn), for: .editingDidEndOnExit)
            staticLabel.text = "Zvolte slovo, které chcete najít:"
            findTextField.returnKeyType = .done
            labelForNoneResults.isEnabled = false
            labelForNoneResults.text = "Help"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func darkModeEnable() {
        self.view.backgroundColor = KKCBackgroundNightMode
        self.labelForNoneResults.backgroundColor = KKCBackgroundNightMode
        self.labelForNoneResults.textColor = KKCTextNightMode
        self.staticLabel.backgroundColor = KKCBackgroundNightMode
        self.staticLabel.textColor = KKCTextNightMode
        self.findTextField.backgroundColor = KKCBackgroundNightMode
        self.findTextField.textColor = KKCTextNightMode
    }
    
    func darkModeDisable() {
        self.view.backgroundColor = KKCBackgroundLightMode
        self.labelForNoneResults.backgroundColor = KKCBackgroundLightMode
        self.labelForNoneResults.textColor = KKCTextLightMode
        self.staticLabel.backgroundColor = KKCBackgroundLightMode
        self.staticLabel.textColor = KKCTextLightMode
        self.findTextField.backgroundColor = KKCBackgroundLightMode
        self.findTextField.textColor = KKCTextLightMode
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

extension FindViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let paragraphStructure = paragraphStructure else { return false }
        self.findString = findTextField.text!
        print(findString)
        if word_number_find == true {
            for par in paragraphStructure.paragraph {
                if String(par.id).range(of: self.findString) != nil {
                    findData.append(par.id)
                }
            }
            if findData.count != 0 {
                labelForNoneResults.text = ""
                labelForNoneResults.isEnabled = false
                let pcvc = ParagraphTableViewController()
                pcvc.kindOfSource = 3
                pcvc.findString = self.findString
                pcvc.findData = findData
                navigationController?.pushViewController(pcvc, animated: true)
                findTextField.resignFirstResponder()
            }
            else {
                labelForNoneResults.isEnabled = true
                labelForNoneResults.text = "Hledaný paragraph nebyl nalezen"
            }
        }
        else {
            for par in paragraphStructure.paragraph {
                if par.text_no_html.range(of: findString) != nil {
                    findData.append(par.id)
                }
                if par.caption_no_html.range(of: findString) != nil {
                    findData.append(par.id)
                }
            }
            if findData.count != 0 {
                print(findData.count)
                let pcvc = ParagraphTableViewController()
                pcvc.kindOfSource = 2
                pcvc.findString = self.findString
                pcvc.findData = findData
                navigationController?.pushViewController(pcvc, animated: true)
                findTextField.resignFirstResponder()
            }
            else {
                labelForNoneResults.isEnabled = true
                labelForNoneResults.text = "Hledaný výraz nebyl nalezen"
            }
        }
    
        return true
    }
}
