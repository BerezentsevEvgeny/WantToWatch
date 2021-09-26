//
//  CustomTabBar.swift
//  Watcher
//
//  Created by Евгений Березенцев on 19.08.2021.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barOne = createTabBarController(vc: MainViewController(),
                                            title: "Trending movies",
                                            image: UIImage(systemName: "film")!)

        let barTwo = createTabBarController(vc: WatchListTableViewController(),
                                            title: "Watchlist",
                                            image: UIImage(systemName: "list.star")!)
        
        viewControllers = [barOne, barTwo]
    }
    
    private func createTabBarController(vc: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
