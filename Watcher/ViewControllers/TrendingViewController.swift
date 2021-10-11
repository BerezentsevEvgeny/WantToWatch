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
    private var sorting = SortingBy.title
    private let mainView = MainView()
    
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configBarButtons()
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
    
    private func configBarButtons() {
        let rightButton = UIBarButtonItem(title: "App Info", style: .plain, target: self, action: #selector(presentInfo))
        navigationItem.rightBarButtonItem = rightButton
        
        let leftButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortBy))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc private func sortBy() {
        let alert = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Title", style: .default) { _ in
            self.trendingMovies = (self.trendingMovies.sorted {$0.title ?? "" < $1.title ?? "" })
            self.createSnapshot()
        }
        let action2 = UIAlertAction(title: "Rating", style: .default) { _ in
            self.trendingMovies = self.trendingMovies.sorted {$0.rate ?? 0 < $1.rate ?? 1}
            self.createSnapshot()
        }
        let action3 = UIAlertAction(title: "Release date", style: .default) { _ in
            self.trendingMovies = self.trendingMovies.sorted {$0.year ?? "0" < $1.year ?? "1"}
            self.createSnapshot()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        present(alert, animated: true, completion: nil)

//        switch sorting {
//        case .title:
//            self.trendingMovies = trendingMovies.sorted {$0.title ?? "" < $1.title ?? "" }
//            createSnapshot()
//            sorting = .rating
//        case .rating:
//            self.trendingMovies = trendingMovies.sorted {$0.rate ?? 0 < $1.rate ?? 1}
//            createSnapshot()
//            sorting = .releaseDate
//        case .releaseDate:
//            self.trendingMovies = trendingMovies.sorted {$0.year ?? "0" < $1.year ?? "1"}
//            createSnapshot()
//            sorting = .title
//        }


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

extension TrendingViewController {
    private enum SortingBy: String {
        case title = "Title"
        case rating = "Rating"
        case releaseDate = "Release date"
    }
}


