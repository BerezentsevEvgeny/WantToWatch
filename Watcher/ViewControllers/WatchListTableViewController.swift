//
//  WatchlistTableViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 14.11.2021.
//

import UIKit

class WatchlistTableViewController: UITableViewController {
    
    let watchlistStorage: WatchlistStorage
    
    private var dataSource: UITableViewDiffableDataSource<Section,Movie>!
    
    init(watchlistStorage: WatchlistStorage) { 
        self.watchlistStorage = watchlistStorage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        checkForItems()
        navigationItem.leftBarButtonItem = editButtonItem
        
        configInfoButton()
        setupView()
        createDatasource()
        createSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkForItems()
    }
            
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let selectedMovie = watchlistStorage.watchList[indexPath.row] //
        let detailViewController = DetailViewController(selectedMovie: selectedMovie, watchlistStorage: watchlistStorage)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeMovie = UIContextualAction(style: .destructive, title: "Remove") { [unowned self] _, _, _ in
            self.watchlistStorage.watchList.remove(at: indexPath.row)
            self.watchlistStorage.saveWatchlist()
            self.checkForItems() //////////////
            self.createSnapshot()
        }
        return UISwipeActionsConfiguration(actions: [removeMovie])
    }
    
    @objc func reloadData() {
        createSnapshot()
    }

    private func checkForItems() {
        if watchlistStorage.watchList.isEmpty {
            let alert = UIAlertController(title: "Your watchlist is empty now", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
                self?.tabBarController?.selectedIndex = 0
            }
            alert.addAction(okAction)
            present(alert, animated: true)
            
        }
    }
    
    // MARK: - TableView DataSource
    private func createDatasource() {
        dataSource = UITableViewDiffableDataSource<Section,Movie>(tableView: tableView) { [weak self] (tableView, indexPath, movie) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: WatchlistTableViewCell.identifier, for: indexPath) as! WatchlistTableViewCell
            let movie = self?.watchlistStorage.watchList[indexPath.row] //
            cell.configureCell(with: movie)
            return cell
        }
    }
    
    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Movie>()
        snapshot.appendSections([.first])
        snapshot.appendItems(watchlistStorage.watchList) //
        dataSource.apply(snapshot,animatingDifferences: true)
    }
        
    private func configInfoButton() {
        let button = UIBarButtonItem(title: "App Info", style: .done, target: self, action: #selector(presentInfoVC))
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupView() {
        title = "Watchlist"
        tableView.rowHeight = 140
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(WatchlistTableViewCell.self, forCellReuseIdentifier: WatchlistTableViewCell.identifier)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: watchlistStorage.updateNotification, object: nil)
    }
}

extension WatchlistTableViewController {
    private enum Section {
        case first
    }
}
