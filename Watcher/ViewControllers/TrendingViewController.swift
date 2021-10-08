//
//  ViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 18.08.2021.
//

import AlamofireImage

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
        configInfoButton()
        title = "Trending movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = mainView.searchController
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = true
        mainView.collectionView.delegate = self
        createDataSource()
        getTrendingMovies()
        createSnapshot()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedMovie = dataSource.itemIdentifier(for: indexPath) else { return }
        goToDetailVC(with: selectedMovie)
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
        NetworkManager.shared.getTrendingMoviesData { [weak self] result in
            switch result {
            case .success(let listOf):
                self?.trendingMovies = listOf.movies
                self?.createSnapshot()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configInfoButton() {
        let button = UIBarButtonItem(title: "App Info", style: .done, target: self, action: #selector(presentInfo))
        navigationItem.rightBarButtonItem = button
    }
    
}

// MARK: - Presenting DetailViewController
extension TrendingViewController: SearchTableViewControllerDelegate {
    
    func goToDetailVC(with movie: Movie) {
        let detailViewController = DetailViewController()
        detailViewController.selectedMovie = movie
        guard let imageString = movie.posterImage else { return }
        let url = URL(string: "https://image.tmdb.org/t/p/w200" + imageString)
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
            SearchControllerModel.shared.fetchSearchedMoviesData(movieTosearch: movieToSearch ?? "") {
                DispatchQueue.main.async {
                    searchVC?.tableView.reloadData()
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

