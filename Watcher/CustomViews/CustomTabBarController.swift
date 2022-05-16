//
//  CustomTabBar.swift
//  Watcher
//
//  Created by Евгений Березенцев on 19.08.2021.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    let watchlistStorage: WatchlistStorage
    
    init(watchlistStorage: WatchlistStorage) {
        self.watchlistStorage = watchlistStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabOne = createTabBarController(vc: TrendingViewController(watchlistStorage: watchlistStorage),
                                            title: "Trending movies",
                                            image: UIImage(systemName: "film")!)
        
        let tabTwo = createTabBarController(vc: WatchlistTableViewController(watchlistStorage: watchlistStorage),
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
