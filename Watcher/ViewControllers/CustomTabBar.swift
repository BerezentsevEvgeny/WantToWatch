//
//  CustomTabBar.swift
//  Watcher
//
//  Created by Евгений Березенцев on 19.08.2021.
//

import UIKit

class CustomTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar1 = createTabBaerController(vc: MainViewController(), title: "Search", image: UIImage(systemName: "film")!)

        viewControllers = [bar1]
    }
    
    
    func createTabBaerController(vc: UIViewController, title: String, image: UIImage) -> UINavigationController {
//        vc.navigationItem.title = title
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
