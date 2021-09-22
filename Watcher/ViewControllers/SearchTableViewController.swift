//
//  SearchTableViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import UIKit

class SearchTableViewController: UITableViewController {
        
    var delegate: SearchTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.rowHeight = 130
        tableView.keyboardDismissMode = .onDrag

    }

    // MARK: - Table view Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SearchControllerModel.shared.searchedMovies.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        let movie = SearchControllerModel.shared.searchedMovies[indexPath.row]
        cell.configureCell(with: movie)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMovie = SearchControllerModel.shared.searchedMovies[indexPath.row]
        delegate?.goToDetailVC(with: selectedMovie)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addToWatchlist = UIContextualAction(style: .normal, title: "To Watchlist") { _, _, Hides in
            let selectedMovie = SearchControllerModel.shared.searchedMovies[indexPath.row]
            if !StorageManager.shared.watchList.contains(selectedMovie) {
                StorageManager.shared.watchList.append(selectedMovie)
                StorageManager.shared.save()
            }
            Hides(true)
        }
        addToWatchlist.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [addToWatchlist])
    }
    
}


    

