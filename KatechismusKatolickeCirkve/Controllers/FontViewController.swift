//
//  FontViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 13/05/2019.
//  Copyright © 2019 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation

class FontViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Properties
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    lazy var fontTextLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var fontNamePickerView: UIPickerView = {
       let fn = UIPickerView()
        fn.translatesAutoresizingMaskIntoConstraints = false
        return fn
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var pickerData: [[String]] = [[String]]()
    var example_text: String = "„Katecheze je <i>výchova</i> dětí, mládeže a dospělých <i>ve víře</i>, která v sobě zahrnuje obzvláště výuku křesťanského učení, podávanou zpravidla plynulým a soustavným způsobem, aby je tak uvedla do plnosti křesťanského života.“ (1)</p><p><small>1) Jan Pavel II., Apoštolská exhortace Catechesi tradendae, 18<br></small>"

    var darkMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        self.fontNamePickerView.delegate = self
        self.fontNamePickerView.dataSource = self
        title = "Nastavení písma pro paragrafy"
        setupView()
        fontTextLabel.numberOfLines = 0
        darkMode = userDefaults.bool(forKey: keys.NightSwitch)
        // Do any additional setup after loading the view.
        let fontNames: [String] = [
            "Arial", "Helvetica", "Times New Roman", "Baskerville", "Didot", "Gill Sans", "Hoefler Text", "Palatino", "Trebuchet MS", "Verdana"
        ]
        let fontSizes: [String] = ["14", "16", "18", "20", "22", "24", "26", "28", "30"]
        pickerData = [fontNames, fontSizes]
        var fontName = userDefaults.string(forKey: keys.fontSize)
        var fontSize = userDefaults.string(forKey: keys.fontName)
        if fontName == nil {
            fontName = "Helvetica"
        }
        if fontSize == nil {
            fontSize = "14"
        }
        if darkMode {
            self.view.backgroundColor = KKCBackgroundNightMode
            fontTextLabel.backgroundColor = KKCBackgroundNightMode
            fontNamePickerView.backgroundColor = KKCBackgroundNightMode
        }
        else {
            self.view.backgroundColor = KKCBackgroundLightMode
            fontTextLabel.backgroundColor = KKCBackgroundLightMode
            fontNamePickerView.backgroundColor = KKCBackgroundLightMode
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
        userDefaults.set(fontStr, forKey: keys.fontSize)
        userDefaults.set(fontName, forKey: keys.fontName)
    }
    
}

extension FontViewController {
    private func setupView() {
        self.view.addSubview(stackView)
        stackView.addSubview(fontNamePickerView)
        stackView.addSubview(fontTextLabel)
        
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 5).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        fontNamePickerView.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 10).isActive = true
        fontNamePickerView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 10).isActive = true
        fontNamePickerView.bottomAnchor.constraint(equalTo: fontTextLabel.topAnchor, constant: -40).isActive = true
        fontNamePickerView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -10).isActive = true
        fontNamePickerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10).isActive = true
        
        fontTextLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 10).isActive = true
        fontTextLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10).isActive = true
        fontTextLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -10).isActive = true
        fontTextLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -10).isActive = true

    }
}
