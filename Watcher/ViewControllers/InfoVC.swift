//
//  InfoVC.swift
//  Watcher
//
//  Created by Евгений Березенцев on 08.10.2021.
//

import Foundation
import UIKit

extension UIViewController {
    @objc func presentInfo() {
        let infoVC = AppInfoViewController()
        let navVC = UINavigationController(rootViewController: infoVC)
        present(navVC, animated: true)
    }
}
