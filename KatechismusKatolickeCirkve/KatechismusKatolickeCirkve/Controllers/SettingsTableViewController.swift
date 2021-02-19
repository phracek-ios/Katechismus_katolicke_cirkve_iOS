//
//  SettingsTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var nightSwitch: UISwitch!
    @IBOutlet weak var nightSwitchLabel: UILabel!
    @IBOutlet weak var dimOffSwitchLabel: UILabel!
    @IBOutlet weak var dimOffSwitch: UISwitch!
    @IBOutlet weak var nightSwitchCell: UITableViewCell!
    @IBOutlet weak var dimOffSwitchCell: UITableViewCell!
    @IBOutlet weak var fontCell: UITableViewCell!
    @IBOutlet weak var fontName: UILabel!
    @IBOutlet weak var fontCaptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nastavení   "

        let userDefaults = UserDefaults.standard
        nightSwitch.isOn = userDefaults.bool(forKey: "NightSwitch")
        if nightSwitch.isOn == true {
            enabledDark()
        }
        else {
            disabledDark()
        }
        dimOffSwitch.isOn = userDefaults.bool(forKey: "DimmScreen")
        set_font_text()
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        set_font_text()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "FontSettings":
            guard let fontController = segue.destination as? FontViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            fontController.navigationItem.title = "Nastavení písma pro paragrafy"
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
    
    @IBAction func funcNightMode(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if nightSwitch.isOn == true {
            userDefaults.set(true, forKey: "NightSwitch")
            enabledDark()
            NotificationCenter.default.post(name: .darkModeEnabled, object:nil)
        }
        else {
            userDefaults.set(false, forKey: "NightSwitch")
            disabledDark()
            NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
        }
    }
    @IBAction func funcDisableDisplay(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if dimOffSwitch.isOn == true {
            UIApplication.shared.isIdleTimerDisabled = true
            userDefaults.set(true, forKey: "DimmScreen")
        }
        else {
            UIApplication.shared.isIdleTimerDisabled = false
            userDefaults.set(false, forKey: "DimmScreen")
        }
    }
    
    private func set_font_text() {
        let userDefaults = UserDefaults.standard
        var font_name = userDefaults.string(forKey: "FontName")
        var font_size = userDefaults.string(forKey: "FontSize")
        
        if font_name == nil {
            font_name = "Helvetica"
        }
        if font_size == nil {
            font_size = "16"
        }
        self.fontName.text = "\(String(font_name!)), \(String(font_size!))px"
    }
    func enabledDark() {
        self.view.backgroundColor = KKCBackgroundNightMode
        self.nightSwitch.backgroundColor = KKCBackgroundNightMode
        self.nightSwitchLabel.textColor = KKCTextNightMode
        self.nightSwitchCell.backgroundColor = KKCBackgroundNightMode
        self.dimOffSwitchLabel.textColor = KKCTextNightMode
        self.dimOffSwitch.backgroundColor = KKCBackgroundNightMode
        self.dimOffSwitchCell.backgroundColor = KKCBackgroundNightMode
        self.fontCell.backgroundColor = KKCBackgroundNightMode
        self.fontCaptionLabel.textColor = KKCTextNightMode
        self.fontCaptionLabel.backgroundColor = KKCBackgroundNightMode
        self.fontName.backgroundColor = KKCBackgroundNightMode
        self.fontName.textColor = KKCTextNightMode
        //self.FullScreenLabel.textColor = UIColor.white
    }
    
    func disabledDark() {
        self.view.backgroundColor = KKCBackgroundLightMode
        self.nightSwitch.backgroundColor = KKCBackgroundLightMode
        self.nightSwitchLabel.textColor = KKCTextLightMode
        self.nightSwitchCell.backgroundColor = KKCBackgroundLightMode
        self.dimOffSwitchLabel.textColor = KKCTextLightMode
        self.dimOffSwitch.backgroundColor = KKCBackgroundLightMode
        self.dimOffSwitchCell.backgroundColor = KKCBackgroundLightMode
        self.fontCell.backgroundColor = KKCBackgroundLightMode
        self.fontCaptionLabel.backgroundColor = KKCBackgroundLightMode
        self.fontCaptionLabel.textColor = KKCTextLightMode
        self.fontName.backgroundColor = KKCBackgroundLightMode
        self.fontName.textColor = KKCTextLightMode
        //self.FullScreenLabel.textColor = UIColor.black
    }
}
