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
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemBlue
        present(safariVC, animated: true)
    }
}
