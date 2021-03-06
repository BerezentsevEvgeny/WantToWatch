//
//  ViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 18.08.2021.
//

import UIKit

protocol SearchTableViewControllerDelegate {
    func goToDetailVC(with movie: Movie)
}

class TrendingViewController: UIViewController, UICollectionViewDelegate {
    
    let watchlistStorage: WatchlistStorage
        
    private var dataSource: UICollectionViewDiffableDataSource<Sections,Movie>!
    private var trendingMovies = [Movie]()
    private let mainView = MainView()
        
    init(watchlistStorage: WatchlistStorage) { 
        self.watchlistStorage = watchlistStorage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSearchController()
        getTrendingMovies()
        configBarButtons()
        createDataSource()
        createSnapshot()
    }
            
    private func setupView() {
        title = "Trending movies"
        mainView.collectionView.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: SearchTableViewController(watchlistStorage: watchlistStorage))
        searchController.searchBar.placeholder = "Enter movie name to search"
        searchController.definesPresentationContext = true
        searchController.showsSearchResultsController = true
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
    }
        
    private func createDataSource() {
        let registration = UICollectionView.CellRegistration<TrendingCollectionViewCell,Movie> { cell, indexPath, movie in
            cell.configureCell(with: movie)
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
        APIService.shared.getTrendingMoviesData { [unowned self] result in
            switch result {
            case .success(let listOf):
                self.trendingMovies = listOf.movies
                self.createSnapshot()
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
        
    @objc func switchMoviesSorting() {
        let alert = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "By title", style: .default) { [unowned self] _ in
            self.trendingMovies = self.trendingMovies.sorted {$0.title ?? "" < $1.title ?? "" }
            self.createSnapshot()
        }
        let action2 = UIAlertAction(title: "By rating", style: .default) { [unowned self] _ in
            self.trendingMovies = self.trendingMovies.sorted {$0.rate ?? 0 < $1.rate ?? 1}
            self.createSnapshot()
        }
        let action3 = UIAlertAction(title: "By release date", style: .default) { [unowned self] _ in
            self.trendingMovies = self.trendingMovies.sorted {$0.year ?? "0" < $1.year ?? "1"}
            self.createSnapshot()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(cancelAction )
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedMovie = dataSource.itemIdentifier(for: indexPath) else { return }
        goToDetailVC(with: selectedMovie)
    }
    
    
}

// MARK: - Presenting DetailViewController
extension TrendingViewController: SearchTableViewControllerDelegate {
    func goToDetailVC(with movie: Movie) {
        let detailViewController = DetailViewController(selectedMovie: movie, watchlistStorage: watchlistStorage)
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

