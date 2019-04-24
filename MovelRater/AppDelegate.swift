//
//  AppDelegate.swift
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit
import CoreGraphics
import WebKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window!.frame  = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width + 0.01, height: UIScreen.main.bounds.height + 0.01)
        window!.backgroundColor = UIColor.white


        
        UITextField.appearance().tintColor = MTColor.main
        UITextView.appearance().tintColor = MTColor.main
        
        DBManager.default.checkDefaultUsers()
        
        self.window?.rootViewController = ESTabBarController.createTabbar()
        
        
        self.window?.makeKeyAndVisible()
        sleep(3)
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}


