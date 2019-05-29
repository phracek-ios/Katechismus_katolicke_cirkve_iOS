//
//  FontViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 13/05/2019.
//  Copyright © 2019 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation
import BonMot

class FontViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fontNamePickerView: UIPickerView!
    @IBOutlet weak var fontTextLabel: UILabel!
    
    var pickerData: [[String]] = [[String]]()
    var example_text: String = "„Katecheze je <i>výchova</i> dětí, mládeže a dospělých <i>ve víře</i>, která v sobě zahrnuje obzvláště výuku křesťanského učení, podávanou zpravidla plynulým a soustavným způsobem, aby je tak uvedla do plnosti křesťanského života.“ (1)</p><p><small>1) Jan Pavel II., Apoštolská exhortace Catechesi tradendae, 18<br></small>"

    var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        self.fontNamePickerView.delegate = self
        self.fontNamePickerView.dataSource = self
        fontTextLabel.numberOfLines = 0
        darkMode = userDefaults.bool(forKey: "NightSwitch")
        // Do any additional setup after loading the view.
        let fontNames: [String] = [
            "Arial", "Helvetica", "Times New Roman", "Baskerville", "Didot", "Gill Sans", "Hoefler Text", "Palatino", "Trebuchet MS", "Verdana"
        ]
        let fontSizes: [String] = ["14", "16", "18", "20", "22", "24", "26", "28", "30"]
        pickerData = [fontNames, fontSizes]
        var fontName = userDefaults.string(forKey: "FontName")
        var fontSize = userDefaults.string(forKey: "FontSize")
        if fontName == nil {
            fontName = "Helvetica"
        }
        if fontSize == nil {
            fontSize = "14"
        }
        fontTextLabel.attributedText = generateContent(text: example_text)
        self.fontNamePickerView.selectRow(fontNames.firstIndex(of: fontName!)!, inComponent: 0, animated: true)
        self.fontNamePickerView.selectRow(fontSizes.firstIndex(of: fontSize!)!, inComponent: 1, animated: true)
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let userDefaults = UserDefaults.standard
        let fontName = pickerData[0][pickerView.selectedRow(inComponent: 0)]
        let fontStr = pickerData[1][pickerView.selectedRow(inComponent: 1)]
        guard let n = NumberFormatter().number(from: fontStr) else { return }
        let fontSize = CGFloat(truncating: n)
        fontTextLabel.attributedText = generateContent(text: example_text, font_name: fontName, size: fontSize)
        userDefaults.set(fontStr, forKey: "FontSize")
        userDefaults.set(fontName, forKey: "FontName")
    }
    
    @objc private func darkModeEnabled(_ notification: Notification) {
        self.darkMode = true
        self.view.backgroundColor = KKCBackgroundNightMode
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        self.darkMode = false
        self.view.backgroundColor = KKCBackgroundLightMode
    }
}
