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
    
    let yearLabel: UILabel = {
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
    
    var watchlistButton: UIButton = {
        let button = UIButton(type: .roundedRect, primaryAction: nil)
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
        
        yearLabel.text = """
                         Release date: \n\(selectedMovie?.year ?? "")
                         
                         Rating: \(selectedMovie?.rate ?? 0.0 < 7 ? "💙" : "❤️‍🔥")
                         
                         Popularity: \(selectedMovie?.popularity ?? 0.0)
                         """
        
    }
    
    private func setupSubviews() {
        view.addSubview(posterImageView)
        view.addSubview(yearLabel) //
        view.addSubview(overviewLabel)
        view.addSubview(watchlistButton)

        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 160),
            posterImageView.heightAnchor.constraint(equalToConstant: 240),
//            posterImageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3),
//            posterImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            
            yearLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 40),
            yearLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40),
            
            overviewLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            overviewLabel.heightAnchor.constraint(equalToConstant: view.bounds.height / 3.5),
//            overviewLabel.bottomAnchor.constraint(equalTo: watchlistButton.topAnchor,constant: -10),
            
//            watchlistButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            watchlistButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchlistButton.widthAnchor.constraint(equalToConstant: 200),
            watchlistButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -25),
        ])
    }
    
    
}
