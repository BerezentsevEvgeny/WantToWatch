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
    
    func presentAlert(message: String,actionTitle: String, completion: @escaping (UIAlertAction)-> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: completion)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc func presentInfoVC() {
        let infoViewController = AppInfoViewController()
        let navigationController = UINavigationController(rootViewController: infoViewController)
        present(navigationController, animated: true)
    }
}
