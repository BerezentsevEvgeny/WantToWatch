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
        let customTabBarController = CustomTabBarController()
        window.rootViewController = customTabBarController
//        window.tintColor
        window.makeKeyAndVisible()
        self.window = window
        
        URLCache.shared.memoryCapacity = 25_000_000
        URLCache.shared.diskCapacity = 50_000_000

        return true
    }


}

