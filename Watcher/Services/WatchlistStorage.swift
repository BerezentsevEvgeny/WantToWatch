//
//  StorageManager.swift
//  Watcher
//
//  Created by Евгений Березенцев on 02.09.2021.
//

import Foundation

//protocol WatchlistStorageProtocol {
//    var watchList: [Movie] { get set}
//    var updateNotification: Notification.Name { get }
//
//    func fetchWatchlist()
//    func saveWatchlist()
//    func remove(_ selectedMovie: Movie)
//    func append(_ selectedMovie: Movie)
//}

class WatchlistStorage {
    
    var watchList = [Movie]() {
        didSet {
            NotificationCenter.default.post(name: updateNotification, object: nil)
        }
    }
    
    let updateNotification = Notification.Name("watchlistUpdated")
    let userDefaults = UserDefaults.standard
    
    init() {
        fetchWatchlist()
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
    
    func fetchWatchlist() {
        if let data = UserDefaults.standard.object(forKey: "watchlist") as? Data {
            guard let savedWatchlist = try? JSONDecoder().decode([Movie].self, from: data) else { return }
            watchList = savedWatchlist
        }
    }
}
