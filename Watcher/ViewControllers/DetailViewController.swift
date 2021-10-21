//
//  DetailViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedMovie: Movie?
        
    let posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.image = UIImage(named: "moviePlaceholder")
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        return posterImageView
    }()
    
    let infoLabel: UILabel = {
        let yearLabel = UILabel()
        yearLabel.numberOfLines = 0
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return yearLabel
    }()
    
    let overviewLabel: UILabel = {
        let overviewLabel = UILabel()
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.textAlignment = .left
        overviewLabel.adjustsFontSizeToFitWidth = true
        overviewLabel.font = .systemFont(ofSize: 20)
        overviewLabel.numberOfLines = 0
        return overviewLabel
    }()
    
    lazy var addToWatchlistButton: UIButton = {  ///?? lazy   var
        let button = UIButton()
        button.isEnabled = true
        button.setTitle(!WatchlistStorage.shared.watchList.contains(selectedMovie!) ? "Add to watchlist" : "Remove" , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToWatchlist), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = selectedMovie?.title
        overviewLabel.text = selectedMovie?.overview
        view.backgroundColor = .systemBackground
        setupSubviews()
        
        infoLabel.text = """
                         Release date: \n\(selectedMovie?.year ?? "")
                         
                         Rating: \(selectedMovie?.rate ?? 0.0)
                         
                         Popularity: \(selectedMovie?.popularity ?? 0.0)
                         """
        
    }
    
    private func setupSubviews() {
        view.addSubview(posterImageView)
        view.addSubview(infoLabel) //
        view.addSubview(overviewLabel)
        view.addSubview(addToWatchlistButton)
        
        let margins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 160),
            posterImageView.heightAnchor.constraint(equalToConstant: 240),
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 40),
            infoLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40),
        ])
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: addToWatchlistButton.topAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            addToWatchlistButton.heightAnchor.constraint(equalToConstant: 35),
            addToWatchlistButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            addToWatchlistButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            addToWatchlistButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -18)
        ])
    }
    
    @objc private func addToWatchlist() {
        guard let selectedMovie = selectedMovie else { return }
        
        if !WatchlistStorage.shared.watchList.contains(selectedMovie) {
            presentAlert(message: "Do you want to add ?", actionTitle: "Add") { _ in
                WatchlistStorage.shared.watchList.append(selectedMovie)
                WatchlistStorage.shared.saveWatchlist()
                self.addToWatchlistButton.setTitle("Remove", for: .normal)
                self.navigationController?.popViewController(animated: true)                
            }
        } else {
            presentAlert(message: "Do you want to remove ?", actionTitle: "Remove") { _ in
                guard let indexPath = WatchlistStorage.shared.watchList.firstIndex(of: selectedMovie) else { return }
                WatchlistStorage.shared.watchList.remove(at: indexPath)
                WatchlistStorage.shared.saveWatchlist()
                self.addToWatchlistButton.setTitle("Add to watchlist", for: .normal)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
}
