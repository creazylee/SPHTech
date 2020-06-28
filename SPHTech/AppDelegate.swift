//
//  AppDelegate.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds);
        
        let vc = ChartListViewController.init(nibName: "ChartListViewController", bundle: nil);
        
        self.window?.rootViewController = vc;
        self.window?.makeKeyAndVisible();
        
        return true
    }
}

