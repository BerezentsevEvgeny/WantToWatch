//
//  DetailViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedMovie: Movie?
        
    var posterImageView: UIImageView = {
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
    
    var overviewLabel: UILabel = {
        let overviewLabel = UILabel()
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.textAlignment = .left
        overviewLabel.adjustsFontSizeToFitWidth = true
        overviewLabel.font = .systemFont(ofSize: 20)
        overviewLabel.numberOfLines = 0
        return overviewLabel
    }()
    
    var addToWatchlistButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Add to Watchlist", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedMovie?.title
        overviewLabel.text = selectedMovie?.overview
        view.backgroundColor = .systemBackground
        setupSubviews()
        
        infoLabel.text = """
                         Release date: \n\(selectedMovie?.year ?? "")
                         
                         Rating: \(selectedMovie?.rate ?? 0.0 < 7 ? "💙" : "❤️‍🔥")
                         
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
            
            infoLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 40),
            infoLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40),
            
            overviewLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: addToWatchlistButton.topAnchor, constant: -10),
            
            addToWatchlistButton.heightAnchor.constraint(equalToConstant: 35),
            addToWatchlistButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToWatchlistButton.widthAnchor.constraint(equalToConstant: 180),
            addToWatchlistButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -18)
        ])
    }
    
    
}
