//
//  AppDelegate.swift
//  MyReseau
//
//  Created by fan li on 2020/4/3.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseAuth
import FirebaseRemoteConfig
import FirebaseCore
import FirebaseFirestore
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.hex(hexString: "323232")], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.hex(hexString: "FF696B")], for: .selected)
        UITabBar.appearance().tintColor = UIColor.hex(hexString: "FF696B")
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white

        window?.rootViewController = MainTabbarViewController()
        
        IQKeyboardManager.shared.enable = true;
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true;
        IQKeyboardManager.shared.toolbarTintColor = .hex(0xFF686B)
    
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        return true
    }


}

