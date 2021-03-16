//
//  AppDelegate.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        CatechismDataService.shared.loadData()
        ChaptersDataService.shared.loadData()
        ParagraphDataService.shared.loadData()
        IndexDataService.shared.loadData()
        UINavigationBar.appearance().barTintColor = KKCMainColor
        UINavigationBar.appearance().tintColor = KKCTextNightMode
        UINavigationBar.appearance().isTranslucent = false
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
        let mainVC = CatechismCollectionViewController(collectionViewLayout: layout)
        window?.rootViewController = UINavigationController(rootViewController: mainVC)
        return true
    }

}

