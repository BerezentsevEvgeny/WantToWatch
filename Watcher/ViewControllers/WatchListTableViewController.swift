//
//  WatchListTableViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import UIKit

class WatchListTableViewController: UITableViewController {
    
    // -
    private var dataSource: UITableViewDiffableDataSource<Section,Movie>!
    
//    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        if let savedMovies = StorageManager.shared.fetchWatchlist() {
//            movies = savedMovies
//        } else {
//            movies = StorageManager.shared.watchList
//        }
        title = "Watchlist"
        tableView.rowHeight = 100
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.register(WatchlistTableViewCell.self, forCellReuseIdentifier: WatchlistTableViewCell.identifier)
//        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: StorageManager.shared.updateNotification, object: nil)
        
        // -
        createDatasource()
        createSnapshot()
    }

    // MARK: - Table view data source

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        StorageManager.shared.watchList.count
////        movies.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: WatchlistTableViewCell.identifier, for: indexPath) as! WatchlistTableViewCell
//        let movie = StorageManager.shared.watchList[indexPath.row]
////        let movie = movies[indexPath.row]
//        cell.configureCell(with: movie)
//        return cell
//    }
    
    // -
    private func createDatasource() {
        dataSource = UITableViewDiffableDataSource<Section,Movie>(tableView: tableView) { (tableView, indexPath, movie) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: WatchlistTableViewCell.identifier, for: indexPath) as! WatchlistTableViewCell
            let movie = StorageManager.shared.watchList[indexPath.row]
            cell.configureCell(with: movie)
            return cell
        }
    }
    
    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Movie>()
        snapshot.appendSections([.first])
        snapshot.appendItems(StorageManager.shared.watchList)
        dataSource.apply(snapshot,animatingDifferences: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createSnapshot()
    }
    

    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = StorageManager.shared.watchList[indexPath.row]
        goToDetailVC(with: selectedMovie)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.watchList.remove(at: indexPath.row)
            StorageManager.shared.save()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moved = StorageManager.shared.watchList.remove(at: sourceIndexPath.row)
        StorageManager.shared.watchList.insert(moved, at: destinationIndexPath.row)
        StorageManager.shared.save()
    }

    

}

extension WatchListTableViewController: SearchTableViewControllerDelegate {
    func goToDetailVC(with movie: Movie) {
        let detailViewController = DetailViewController()
        detailViewController.selectedMovie = movie
        guard let imageString = movie.posterImage else { return }
        let url = URL(string: "https://image.tmdb.org/t/p/w200" + imageString)
        detailViewController.posterImageView.af.setImage(withURL: url!)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
}


// -
extension WatchListTableViewController {
    private enum Section {
        case first
    }
}
