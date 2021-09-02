//
//  StorageManager.swift
//  Watcher
//
//  Created by Евгений Березенцев on 02.09.2021.
//

import Foundation

class StorageManager {
    
    let shared = StorageManager()
    
    private init() {}
    
    func save(with items: [Movie]) {
        UserDefaults.standard.setValue(items, forKey: "savedMovies")
    }
    
    
    
    
}