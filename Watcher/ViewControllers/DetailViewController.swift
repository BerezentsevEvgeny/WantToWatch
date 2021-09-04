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
    
    var overviewLabel: UILabel = {
        let overviewLabel = UILabel()
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.textAlignment = .center
        overviewLabel.numberOfLines = 0
        overviewLabel.text = "Hello"
        overviewLabel.textColor = .black
        return overviewLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedMovie?.title
        overviewLabel.text = selectedMovie?.overview
        view.backgroundColor = .systemBackground
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(posterImageView)
        view.addSubview(overviewLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -80),
            posterImageView.widthAnchor.constraint(equalToConstant: 200),
            posterImageView.heightAnchor.constraint(equalToConstant: 320),
        ])
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            overviewLabel.heightAnchor.constraint(equalToConstant: 200)

        ])
        
    }
    

    



}
