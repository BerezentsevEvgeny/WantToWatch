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
    
    let watchlistStorage: WatchlistStorage
    
    init(watchlistStorage: WatchlistStorage) { 
        self.watchlistStorage = watchlistStorage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")  //
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedMovies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        let movie = searchedMovies[indexPath.row]
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
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 130
    }
}

extension SearchTableViewController {
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let selectedMovie = self.searchedMovies[indexPath.row]
        let addAction = UIContextualAction(style: .normal, title: "To Watchlist") { _, _, hides in
            self.watchlistStorage.watchList.append(selectedMovie)
            self.watchlistStorage.saveWatchlist()
            hides(true)
        }
        addAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, hides in
            self.watchlistStorage.remove(selectedMovie)
            hides(true)
        }
        return UISwipeActionsConfiguration(actions: [watchlistStorage.watchList.contains(selectedMovie) ? deleteAction : addAction])
    }
}

