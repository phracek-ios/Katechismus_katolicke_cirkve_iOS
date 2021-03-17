//
//  SettingsTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var DarkModeOn = Bool()
    var DimmOff = Bool()
    let keys = SettingsBundleHelper.SettingsBundleKeys.self
    
    var className: String {
        return String(describing: self)
    }
    var settings = [SettingsItem]()
    var back = KKCBackgroundNightMode
    var text = KKCTextNightMode
    var fontName: String = "Helvetica"
    var fontSize: String = "16"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nastavení"

        loadSettings()
        setupSettingsTable()
        let userDefaults = UserDefaults.standard
        self.DarkModeOn = userDefaults.bool(forKey: keys.NightSwitch)
        print(self.DarkModeOn)
        if self.DarkModeOn == true {
            enabledDark()
        }
        else {
            disabledDark()
        }
        self.DimmOff = userDefaults.bool(forKey: keys.idleTimer)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        tableView.alwaysBounceHorizontal = false
        tableView.tableFooterView = UIView()

    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func funcNightMode(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if self.DarkModeOn == true {
            userDefaults.set(true, forKey: keys.NightSwitch)
            enabledDark()
            NotificationCenter.default.post(name: .darkModeEnabled, object:nil)
        }
        else {
            userDefaults.set(false, forKey: keys.NightSwitch)
            disabledDark()
            NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
        }
    }
    
    func funcDisableDisplay(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if self.DimmOff == true {
            UIApplication.shared.isIdleTimerDisabled = true
            userDefaults.set(true, forKey: keys.idleTimer)
        }
        else {
            UIApplication.shared.isIdleTimerDisabled = false
            userDefaults.set(false, forKey: keys.idleTimer)
        }
    }
    
    func setupSettingsTable() {
        tableView.register(SettingsTextTableViewCell.self, forCellReuseIdentifier: SettingsTextTableViewCell.cellId)
        tableView.register(FontPickerTableViewCell.self, forCellReuseIdentifier: FontPickerTableViewCell.cellId)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    func loadSettings() {
        settings.append(SettingsItem(type: SettingsItemType.onOffSwitch,
                                     title: "Noční režim",
                                     description: "",
                                     prefsString: keys.NightSwitch,
                                     defValue: false,
                                     eventHandler: nil))
        settings.append(SettingsItem(type: SettingsItemType.onOffSwitch,
                                     title: "Zabránit vypínání obrazovky",
                                     description: "",
                                     prefsString: keys.idleTimer,
                                     defValue: false,
                                     eventHandler: nil))
        settings.append(SettingsItem(type: SettingsItemType.fontPicker,
                                     title: "Písmo",
                                     description: "",
                                     prefsString: keys.fontSize,
                                     defValue: false,
                                     eventHandler: nil))
        settings.append(SettingsItem(type: SettingsItemType.text,
                                     title: "Zpětná vazba",
                                     description: "",
                                     prefsString: "",
                                     eventHandler: feedBack))
    }
    
    @objc func nightTarget(_ sender: UISwitch) {
        
        print("Switch Target Night \(sender.isOn)")
        Global.vibrate()
        let userDefaults = UserDefaults.standard
        userDefaults.set(sender.isOn, forKey: keys.NightSwitch)
        self.DarkModeOn = sender.isOn
        if sender.isOn == true {
            self.back = KKCBackgroundNightMode
            self.text = KKCTextNightMode
            NotificationCenter.default.post(name: .darkModeEnabled, object:nil)
        }
        else {
            self.back = KKCBackgroundLightMode
            self.text = KKCTextLightMode
            NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
        }
        setupUI()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func idleTarget(_ sender: UISwitch!) {
        
        print("Idle Target Night \(sender.isOn)")
        Global.vibrate()
        let userDefaults = UserDefaults.standard
        userDefaults.set(sender.isOn, forKey: keys.idleTimer)
    }
    
    func enabledDark() {
        self.view.backgroundColor = KKCBackgroundNightMode
        self.back = KKCBackgroundNightMode
        self.text = KKCTextNightMode
    }
    
    func disabledDark() {
        self.view.backgroundColor = KKCBackgroundLightMode
        self.back = KKCBackgroundLightMode
        self.text = KKCTextLightMode
    }
    
    func setupUI() {
        self.view.backgroundColor = self.back
    }
    
    func feedBack(_ sender: Any?) {
        if let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfHpqeAzGzRvVttcbNiaVuQ1lu_ZLJjpnxZBSlJ5UwniVcAzw/viewform") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else
            {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
}

extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userDefaults = UserDefaults.standard
        switch settings[indexPath.row].type {
        case .fontPicker:
            let cell = tableView.dequeueReusableCell(withIdentifier: FontPickerTableViewCell.cellId, for: indexPath) as! FontPickerTableViewCell
            cell.font_name = fontName
            cell.font_size = fontSize
            cell.configureCell()
            cell.backgroundColor = self.back
            return cell
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTextTableViewCell.cellId, for: indexPath) as! SettingsTextTableViewCell
            cell.configureCell(settingsItem: settings[indexPath.row], cellWidth: tableView.frame.width)
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = self.back
            return cell
        default:
            let set = settings[indexPath.row]
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
            let sw = UISwitch()
            sw.isOn = userDefaults.bool(forKey: set.prefsString)
            if set.prefsString == keys.NightSwitch {
                sw.addTarget(self, action: #selector(self.nightTarget(_:)), for: .valueChanged)
            }
            else if set.prefsString == keys.idleTimer {
                sw.addTarget(self, action: #selector(self.idleTarget(_:)), for: .valueChanged)
            }
            cell.textLabel?.text = settings[indexPath.row].title
            cell.detailTextLabel?.text = settings[indexPath.row].detail

            cell.backgroundColor = self.back
            cell.textLabel?.backgroundColor = self.back
            cell.textLabel?.textColor = self.text
            cell.detailTextLabel?.backgroundColor = self.back
            cell.detailTextLabel?.textColor = self.text

            cell.accessoryView = sw
            cell.accessoryType = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settings[indexPath.row].type == SettingsItemType.fontPicker {
           let fpViewController = FontViewController()
            navigationController?.pushViewController(fpViewController, animated: true)
        }
        let data = settings[indexPath.row]
        if let f = data.eventHandler {
            f(nil)
        }
        
    }

}
