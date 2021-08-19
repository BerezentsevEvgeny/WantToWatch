//
//  AppDelegate.swift
//  Watcher
//
//  Created by Евгений Березенцев on 18.08.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBar = CustomTabBar()
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
        self.window = window

        return true
    }


}

