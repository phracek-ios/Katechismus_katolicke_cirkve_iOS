//
//  Global.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 04.03.2021.
//  Copyright © 2021 Petr Hracek. All rights reserved.
//

import UIKit
import UserNotifications
import SystemConfiguration

class Global {
    static func vibrate() {
        let vibrate = UserDefaults.standard.bool(forKey: SettingsBundleHelper.SettingsBundleKeys.vibrationEnabled)
        if vibrate {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    static func appFont() -> String{
        let font = UserDefaults.standard.bool(forKey: SettingsBundleHelper.SettingsBundleKeys.serifEnabled)
        if font {
            return "Times New Roman"
        }
        return "Helvetica"
    }
}

func get_cgfloat(size: String) -> CGFloat {
    guard let n = NumberFormatter().number(from: size) else { return 0 }
    let f = CGFloat(truncating: n)
    return f
}
