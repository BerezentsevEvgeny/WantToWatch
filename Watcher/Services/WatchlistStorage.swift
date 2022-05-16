//
//  StorageManager.swift
//  Watcher
//
//  Created by Евгений Березенцев on 02.09.2021.
//

import Foundation

class WatchlistStorage {
    
    private let watchlistKey = "watchlist" //
    private let defaults = UserDefaults.standard
    
    var watchList = [Movie]() {
        didSet {
            NotificationCenter.default.post(name: updateNotification, object: nil)
        }
    }
    
    let updateNotification = Notification.Name("watchlistUpdated")
    
    init() {
        fetchWatchlist()
    }
    
    func saveWatchlist() {
        guard let data = try? JSONEncoder().encode(watchList) else { return }
        defaults.set(data, forKey: watchlistKey)
    }
    

    
    func remove(_ selectedMovie: Movie) {
        guard let indexPath = watchList.firstIndex(of: selectedMovie) else { return }
        watchList.remove(at: indexPath)
        saveWatchlist()
    }
    
    func append(_ selectedMovie: Movie) {
        watchList.append(selectedMovie)
        saveWatchlist()
    }
    
    func fetchWatchlist() {
        if let data = defaults.object(forKey: watchlistKey) as? Data {
            guard let savedWatchlist = try? JSONDecoder().decode([Movie].self, from: data) else { return }
            watchList = savedWatchlist
        }
    }
    

    
    
}
