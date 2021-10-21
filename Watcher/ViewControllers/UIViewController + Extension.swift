//
//  SafariVC.swift
//  Watcher
//
//  Created by Евгений Березенцев on 05.10.2021.
//

import Foundation
import SafariServices

extension UIViewController {
    
    func presentSafariVC(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .systemBlue
        present(safariViewController, animated: true)
    }
    
    @objc func presentInfoVC() {
        let infoViewController = AppInfoViewController()
        let navigationController = UINavigationController(rootViewController: infoViewController)
        present(navigationController, animated: true)
    }
}
