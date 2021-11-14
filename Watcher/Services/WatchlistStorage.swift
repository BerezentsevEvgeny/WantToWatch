//
//  StorageManager.swift
//  Watcher
//
//  Created by Евгений Березенцев on 02.09.2021.
//

import Foundation

class WatchlistStorage {
    
//    static let shared = WatchlistStorage()
    
    let updateNotification = Notification.Name("watchlistUpdated")
    let userDefaults = UserDefaults.standard
    
    var watchList = [Movie]() {
        didSet {
//            NotificationCenter.default.post(name: WatchlistStorage.shared.updateNotification, object: nil)
            NotificationCenter.default.post(name: updateNotification, object: nil)
        }
    }
    
    init() {
        watchList = fetchWatchlist()
    }
        
    func fetchWatchlist() -> [Movie] {
        guard let data = UserDefaults.standard.object(forKey: "watchlist") as? Data else { return [] }
        guard let savedWatchlist = try? JSONDecoder().decode([Movie].self, from: data) else { return [] }
        return savedWatchlist
    }
    
    func saveWatchlist() {
        guard let data = try? JSONEncoder().encode(watchList) else { return }
        userDefaults.set(data, forKey: "watchlist")
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
    
}
