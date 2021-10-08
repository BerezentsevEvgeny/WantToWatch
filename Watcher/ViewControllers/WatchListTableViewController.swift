//
//  WatchListTableViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import UIKit

class WatchListTableViewController: UITableViewController {
    
    private var dataSource: UITableViewDiffableDataSource<Section,Movie>!
    private let storage = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configInfoButton()
        setupView()
        createDatasource()
        createSnapshot()
//        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: StorageManager.shared.updateNotification, object: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let selectedMovie = storage.watchList[indexPath.row]
        goToDetailVC(with: selectedMovie)
    }
        
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeMovie = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, Hides in
            self?.storage.watchList.remove(at: indexPath.row)
            self?.createSnapshot()
            self?.storage.saveWatchlist()
        }
        return UISwipeActionsConfiguration(actions: [removeMovie])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createSnapshot()
    }
    
    // MARK: - Table view data source

    private func createDatasource() {
        dataSource = UITableViewDiffableDataSource<Section,Movie>(tableView: tableView) { [weak self] (tableView, indexPath, movie) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: WatchlistTableViewCell.identifier, for: indexPath) as! WatchlistTableViewCell
            let movie = self?.storage.watchList[indexPath.row]
            cell.configureCell(with: movie)
            return cell
        }
    }
    
    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Movie>()
        snapshot.appendSections([.first])
        snapshot.appendItems(storage.watchList)
        dataSource.apply(snapshot,animatingDifferences: true)
    }
        
    private func configInfoButton() {
        let button = UIBarButtonItem(title: "App Info", style: .done, target: self, action: #selector(presentInfo))
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupView() {
        title = "Watchlist"
        tableView.rowHeight = 100
        tableView.register(WatchlistTableViewCell.self, forCellReuseIdentifier: WatchlistTableViewCell.identifier)
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


extension WatchListTableViewController {
    private enum Section {
        case first
    }
}
