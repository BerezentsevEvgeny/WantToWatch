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

class TrendingViewController: UICollectionViewController {
        
    var viewModel: TrendingViewModelProtocol! {
        didSet {
            viewModel.getTrendingMovies {
                self.createSnapshot()
            }
        }
    }
    
    let watchlistStorage = WatchlistStorage.shared
        
    private var dataSource: UICollectionViewDiffableDataSource<Sections,Movie>!
        
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        collectionView.collectionViewLayout = configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TrendingViewModel()
        setupView()
        setupSearchController()
        configBarButtons()
        createDataSource()
//        createSnapshot()
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
                    
    private func setupView() {
        title = "Trending movies"
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
        
        dataSource = UICollectionViewDiffableDataSource<Sections,Movie>(collectionView: collectionView){
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Movie) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: identifier)
        }
    }
    
    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Sections,Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.trendingMovies)
        dataSource.apply(snapshot)
    }
    
    private func createSnapshot(with sortedList: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections,Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sortedList)
        dataSource.apply(snapshot)
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
            let sortedMovies = viewModel.trendingMovies.sorted {$0.title ?? "" < $1.title ?? "" }
            self.createSnapshot(with: sortedMovies)
        }
        let action2 = UIAlertAction(title: "By rating", style: .default) { [unowned self] _ in
            let sortedMovies = viewModel.trendingMovies.sorted {$0.rate ?? 0 < $1.rate ?? 0 }
            self.createSnapshot(with: sortedMovies)
        }
        let action3 = UIAlertAction(title: "By release date", style: .default) { [unowned self] _ in
            let sortedMovies = viewModel.trendingMovies.sorted {$0.year ?? "" < $1.year ?? "" }
            self.createSnapshot(with: sortedMovies)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(cancelAction )
        present(alert, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

