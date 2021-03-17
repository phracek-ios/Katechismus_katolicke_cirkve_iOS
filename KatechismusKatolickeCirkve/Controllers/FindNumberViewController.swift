//
//  FindNumberViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 29/10/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation

class FindNumberViewController: UIViewController, UITextFieldDelegate {

    fileprivate var paragraphStructure: ParagraphStructure?
    var darkMode: Bool = false
    var findString: String = ""
    var findData = [Int]()
    
    @IBOutlet weak var staticLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var labelForNoneResults: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
        numberTextField.delegate = self
        numberTextField.text = ""
        numberTextField.returnKeyType = .done
        numberTextField.keyboardType = .numberPad
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: KKCMainTextColor]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "ShowParagraph":
            guard let paragraphCollectionViewController = segue.destination as? ParagraphTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            paragraphCollectionViewController.kindOfSource = 3
            paragraphCollectionViewController.findString = self.findString
            paragraphCollectionViewController.findData = findData
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    @IBAction func OKButton(_ sender: UIButton) {
        guard let paragraphStructure = paragraphStructure else { return }
        self.findString = numberTextField.text!
        for par in paragraphStructure.paragraph {
            if String(par.id).range(of: self.findString) != nil {
                findData.append(par.id)
            }
        }
        if findData.count != 0 {
            performSegue(withIdentifier: "ShowParagraph", sender: self)
            numberTextField.resignFirstResponder()
            labelForNoneResults.text = ""
            labelForNoneResults.isEnabled = false        }
        else {
            labelForNoneResults.isEnabled = true
            labelForNoneResults.text = "Hledaný paragraph nebyl nalezen"
        }
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
