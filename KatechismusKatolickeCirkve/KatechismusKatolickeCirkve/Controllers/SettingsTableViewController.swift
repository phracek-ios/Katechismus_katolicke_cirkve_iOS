//
//  SettingsTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SettingsTableViewController: BaseTableViewController {

    @IBOutlet weak var nightSwitch: UISwitch!
    @IBOutlet weak var nightSwitchLabel: UILabel!
    @IBOutlet weak var dimOffSwitchLabel: UILabel!
    @IBOutlet weak var dimOffSwitch: UISwitch!
    @IBOutlet weak var nightSwitchCell: UITableViewCell!
    @IBOutlet weak var dimOffSwitchCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = UserDefaults.standard
        nightSwitch.isOn = userDefaults.bool(forKey: "NightSwitch")
        if nightSwitch.isOn == true {
            enabledDark()
        }
        else {
            disabledDark()
        }
        dimOffSwitch.isOn = userDefaults.bool(forKey: "DimmScreen")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
    
    func enabledDark() {
        self.view.backgroundColor = KKCBackgroundNightMode
        self.nightSwitch.backgroundColor = KKCBackgroundNightMode
        self.nightSwitchLabel.textColor = KKCTextNightMode
        self.nightSwitchCell.backgroundColor = KKCBackgroundNightMode
        self.dimOffSwitchLabel.textColor = KKCTextNightMode
        self.dimOffSwitch.backgroundColor = KKCBackgroundNightMode
        self.dimOffSwitchCell.backgroundColor = KKCBackgroundNightMode
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
        //self.FullScreenLabel.textColor = UIColor.black
    }
}
