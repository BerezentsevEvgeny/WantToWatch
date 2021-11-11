//
//  WatchListTableViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import UIKit

class WatchlistTableViewController: UITableViewController {
    
    private var dataSource: UITableViewDiffableDataSource<Section,Movie>!
//    private let storage = WatchlistStorage.shared
    
    let watchlistStorage: WatchlistStorage //
    
    init(watchlistStorage: WatchlistStorage) {  //
        self.watchlistStorage = watchlistStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")  //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForItems()
        configInfoButton()
        setupView()
        createDatasource()
        createSnapshot()
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: WatchlistStorage.shared.updateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: watchlistStorage.updateNotification, object: nil)
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
//        let selectedMovie = storage.watchList[indexPath.row]
        let selectedMovie = watchlistStorage.watchList[indexPath.row]

        let detailViewController = DetailViewController(selectedMovie: selectedMovie, watchlistStorage: watchlistStorage) //
        navigationController?.pushViewController(detailViewController, animated: true)
//        goToDetailVC(with: selectedMovie)
    }
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeMovie = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, Hides in
//            self?.storage.watchList.remove(at: indexPath.row)
            self?.watchlistStorage.watchList.remove(at: indexPath.row)
            self?.createSnapshot()
//            self?.storage.saveWatchlist()
            self?.watchlistStorage.saveWatchlist()

        }
        return UISwipeActionsConfiguration(actions: [removeMovie])
    }
    
    @objc func reloadData() {
        createSnapshot()
    }

    func checkForItems() {
//        if storage.watchList.isEmpty {
//            let okAction = UIAlertAction(title: "Ok", style: .cancel)
//            let alert = UIAlertController(title: "", message: "Saved movies will be visible here", preferredStyle: .alert)
//            alert.addAction(okAction)
//            present(alert, animated: true )
//        }
        if watchlistStorage.watchList.isEmpty {
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            let alert = UIAlertController(title: "", message: "Saved movies will be visible here", preferredStyle: .alert)
            alert.addAction(okAction)
            present(alert, animated: true )
        }
        
    }
    
    // MARK: - TableView DataSource
    private func createDatasource() {
        dataSource = UITableViewDiffableDataSource<Section,Movie>(tableView: tableView) { [weak self] (tableView, indexPath, movie) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: WatchlistTableViewCell.identifier, for: indexPath) as! WatchlistTableViewCell
//            let movie = self?.storage.watchList[indexPath.row]
            let movie = self?.watchlistStorage.watchList[indexPath.row]
            cell.configureCell(with: movie)
            return cell
        }
    }
    
    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Movie>()
        snapshot.appendSections([.first])
//        snapshot.appendItems(storage.watchList)
        snapshot.appendItems(watchlistStorage.watchList)
        dataSource.apply(snapshot,animatingDifferences: true)
    }
        
    private func configInfoButton() {
        let button = UIBarButtonItem(title: "App Info", style: .done, target: self, action: #selector(presentInfoVC))
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupView() {
        title = "Watchlist"
        tableView.rowHeight = 100
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(WatchlistTableViewCell.self, forCellReuseIdentifier: WatchlistTableViewCell.identifier)
    }
    
}

//// MARK: - Presenting DetailViewController
//extension WatchListTableViewController: SearchTableViewControllerDelegate {
//    func goToDetailVC(with movie: Movie) {
////        let detailViewController = DetailViewController()
//        let detailViewController = DetailViewController(selectedMovie: movie)
////        detailViewController.selectedMovie = movie
////        guard let imageString = movie.posterImage else { return }
////        let url = URL(string: "https://image.tmdb.org/t/p/w200" + imageString)
////        detailViewController.posterImageView.af.setImage(withURL: url!)
//        navigationController?.pushViewController(detailViewController, animated: true)
//    }
//}

extension WatchlistTableViewController {
    private enum Section {
        case first
    }
}
