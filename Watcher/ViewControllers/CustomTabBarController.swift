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
        
        let tabOne = createTabBarController(vc: TrendingViewController(),
                                            title: "Trending movies",
                                            image: UIImage(systemName: "film")!)
        
        let tabTwo = createTabBarController(vc: WatchListTableViewController(),
                                            title: "Watchlist",
                                            image: UIImage(systemName: "list.star")!)
                
        viewControllers = [tabOne, tabTwo]
    }
    
    private func createTabBarController(vc: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
