//
//  SearchTableViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import UIKit

class SearchTableViewController: UITableViewController {
            
    var delegate: SearchTableViewControllerDelegate?
    var searchedMovies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedMovies.count //
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        let movie = searchedMovies[indexPath.row] //
        cell.configureCell(with: movie)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMovie = searchedMovies[indexPath.row] //
        delegate?.goToDetailVC(with: selectedMovie)
    }
    
    private func setupTableView() {
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.rowHeight = 130
        tableView.keyboardDismissMode = .onDrag
    }
}

extension SearchTableViewController {
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addToWatchlist = UIContextualAction(style: .normal, title: "To Watchlist") { [weak self] _, _, Hides in
            let selectedMovie = self?.searchedMovies[indexPath.row]
            if !WatchlistStorage.shared.watchList.contains(selectedMovie!) {
                WatchlistStorage.shared.watchList.append(selectedMovie!)
                WatchlistStorage.shared.saveWatchlist()
            } else {
                let alert = UIAlertController(title: "Already in watchlist", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self?.present(alert, animated: true)
            }
            Hides(true)
        }
        addToWatchlist.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [addToWatchlist])
    }
}


    

