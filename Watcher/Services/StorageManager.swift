//
//  StorageManager.swift
//  Watcher
//
//  Created by Евгений Березенцев on 02.09.2021.
//

import Foundation

class StorageManager {
    
    let updateNotification = Notification.Name("watchlistUpdated")
    
    static let shared = StorageManager()
    
    var watchList = [Movie]() {
        didSet {
            NotificationCenter.default.post(name: StorageManager.shared.updateNotification, object: nil) // Post Notification
        }
    }
    
    private init() {}
    
//    func save(with items: [Movie]) {
//        UserDefaults.standard.setValue(items, forKey: "savedMovies")
//    }
    
    
    
    
    
}
