//
//  ViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 18.08.2021.
//

import AlamofireImage

class MainViewController: UIViewController, UICollectionViewDelegate {
    
    private var dataSource: UICollectionViewDiffableDataSource<Sections,Movie>!
    private var trendingMovies = [Movie]()
    private let mainView = MainView()
    
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    private func createDataSource() {
        let registration = UICollectionView.CellRegistration<MainCollectionViewCell,Movie> { cell, indexPath, movie in
            guard let posterImage = movie.posterImage else { return }
            let urlString = "https://image.tmdb.org/t/p/w300" + posterImage
            let url = URL(string: urlString)!
            cell.posterImage.af.setImage(withURL: url, placeholderImage: UIImage(named: "moviePlaceholder"))
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
}


extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(loadSearchedMovies), object: nil)
        perform(#selector(loadSearchedMovies), with: nil, afterDelay: 0.2)
    }
    
    @objc func loadSearchedMovies() {
        let movieToSearch = navigationItem.searchController?.searchBar.text
        let searchVC = navigationItem.searchController?.searchResultsController as? SearchTableViewController
//        searchVC?.delegate = self //////
        if movieToSearch != "" {
            SearchControllerModel.shared.fetchSearchedMoviesData(movieTosearch: movieToSearch ?? "") {
                DispatchQueue.main.async {
                    searchVC?.tableView.reloadData()
                }
            }
        }
    }
}

extension MainViewController {
    private enum Sections {
        case main
    }
}

