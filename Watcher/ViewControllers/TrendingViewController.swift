//
//  ViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 18.08.2021.
//

import AlamofireImage
import UIKit

protocol SearchTableViewControllerDelegate {
    func goToDetailVC(with movie: Movie)
}

class TrendingViewController: UIViewController, UICollectionViewDelegate {
    
    private var dataSource: UICollectionViewDiffableDataSource<Sections,Movie>!
    private var trendingMovies = [Movie]()
    private let mainView = MainView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getTrendingMovies()
        configBarButtons()
        createDataSource()
        createSnapshot()
    }
    
    private func setupView() {
        title = "Trending movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = mainView.searchController
        navigationItem.searchController?.searchBar.delegate = self
        mainView.collectionView.delegate = self
    }
        
    private func createDataSource() {
        let registration = UICollectionView.CellRegistration<TrendingCollectionViewCell,Movie> { cell, indexPath, movie in
            guard let posterImage = movie.posterImage else { return }
            let urlString = "https://image.tmdb.org/t/p/w300" + posterImage
            let url = URL(string: urlString)!
            cell.posterImageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "moviePlaceholder"))
        }
        
        dataSource = UICollectionViewDiffableDataSource<Sections,Movie>(collectionView: mainView.collectionView){
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Movie) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: identifier)
        }
    }
    
    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Sections,Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(trendingMovies)
        dataSource.apply(snapshot)
    }
    
    private func getTrendingMovies() {
        APIService.shared.getTrendingMoviesData { [weak self] result in
            switch result {
            case .success(let listOf):
                self?.trendingMovies = listOf.movies
                self?.createSnapshot()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configBarButtons() {
        let rightButton = UIBarButtonItem(title: "App Info", style: .done, target: self, action: #selector(presentInfoVC))
        navigationItem.rightBarButtonItem = rightButton
        
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(switchMoviesSorting))
        navigationItem.leftBarButtonItem = leftButton
    }
    
//    @objc func presentSearch() {
//        navigationItem.searchController = mainView.searchController
//        navigationItem.searchController?.searchBar.delegate = self
//        view.layoutIfNeeded()
//    }
    
    @objc private func switchMoviesSorting() {
        let alert = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "By title", style: .default) { _ in
            self.trendingMovies = (self.trendingMovies.sorted {$0.title ?? "" < $1.title ?? "" })
            self.createSnapshot()
        }
        let action2 = UIAlertAction(title: "By rating", style: .default) { _ in
            self.trendingMovies = self.trendingMovies.sorted {$0.rate ?? 0 < $1.rate ?? 1}
            self.createSnapshot()
        }
        let action3 = UIAlertAction(title: "By release date", style: .default) { _ in
            self.trendingMovies = self.trendingMovies.sorted {$0.year ?? "0" < $1.year ?? "1"}
            self.createSnapshot()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(cancelAction )
        present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedMovie = dataSource.itemIdentifier(for: indexPath) else { return }
        goToDetailVC(with: selectedMovie)
    }
    

    
}

// MARK: - Presenting DetailViewController
extension TrendingViewController: SearchTableViewControllerDelegate {
    
    func goToDetailVC(with movie: Movie) {
        let detailViewController = DetailViewController()
        detailViewController.selectedMovie = movie
        guard let imageString = movie.posterImage else { return }
        let url = URL(string: "https://image.tmdb.org/t/p/w200" + imageString)  // quality
        detailViewController.posterImageView.af.setImage(withURL: url!)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - SearchBar Delegate
extension TrendingViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(loadSearchedMovies), object: nil)
        perform(#selector(loadSearchedMovies), with: nil, afterDelay: 0.2)
    }
    
    @objc func loadSearchedMovies() {
        let movieToSearch = navigationItem.searchController?.searchBar.text
        let searchVC = navigationItem.searchController?.searchResultsController as? SearchTableViewController
        searchVC?.delegate = self
        if movieToSearch != "" {

            APIService.shared.getSearchedMoviesData(lookingForMovie: movieToSearch ?? "") { result in
                switch result {
                case .success(let listOf):
                    DispatchQueue.main.async {
                        searchVC?.searchedMovies = listOf.movies
                        searchVC?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension TrendingViewController {
    private enum Sections {
        case main
    }
}


extension TrendingViewController {
    // Context menu
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let selectedMovie = trendingMovies[indexPath.row]
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let toWatchlist = UIAction(title: "Add to watchlist", image: UIImage(systemName: "star"   ), state: .off) { _ in
                if !WatchlistStorage.shared.watchList.contains(selectedMovie) { ///
                    WatchlistStorage.shared.watchList.append(selectedMovie)
                    WatchlistStorage.shared.saveWatchlist()
                }
            }
            let remove = UIAction(title: "Remove", image: UIImage(systemName: "minus"   ), attributes: .destructive, state: .off ) { _ in
                guard let indexPath = WatchlistStorage.shared.watchList.firstIndex(of: selectedMovie) else { return }
                WatchlistStorage.shared.watchList.remove(at: indexPath)
                WatchlistStorage.shared.saveWatchlist()
            }

            if #available(iOS 15.0, *) {
                
                return UIMenu(title: "", subtitle: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children:
                                WatchlistStorage.shared.watchList.contains(selectedMovie) ? [remove] : [toWatchlist])
            } else {
                return nil
            }
        }
        
        return configuration
    }
    
}


