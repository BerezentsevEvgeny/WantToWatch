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
        
        let bar1 = createTabBaerController(vc: MainViewController(), title: "Trending movies", image: UIImage(systemName: "film")!)

        viewControllers = [bar1]
    }
    
    
    private func createTabBaerController(vc: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
