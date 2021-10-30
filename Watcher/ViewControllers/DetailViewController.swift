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
    
    lazy var infoLabel: UILabel = {
        let yearLabel = UILabel()
        yearLabel.layer.cornerRadius = 10
        yearLabel.backgroundColor = .systemGreen
        yearLabel.text = "\(selectedMovie?.rate ?? 0.0)"
        yearLabel.layer.masksToBounds = true
        yearLabel.textColor = .white
        yearLabel.textAlignment = .center
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        return yearLabel
    }()
    
    private let overviewLabel: UILabel = {
        let overviewLabel = UILabel()
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.textAlignment = .left
        overviewLabel.adjustsFontSizeToFitWidth = true
        overviewLabel.font = .systemFont(ofSize: 20)
        overviewLabel.numberOfLines = 0
        return overviewLabel
    }()
    
    lazy var addAndRemoveButton: UIButton = {
        let button = UIButton()
        button.setTitle(!WatchlistStorage.shared.watchList.contains(selectedMovie!) ? "Add to list" : "Remove" , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToWatchlist), for: .touchUpInside)
        return button
    }()
    
    lazy var watchTrailerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Watch trailer" , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(watchTrailer), for: .touchUpInside)
        return button
    }()
    
    private var hstack = UIStackView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
    }
    
    private func setViews() {
        title = selectedMovie?.title
        overviewLabel.text = selectedMovie?.overview
        view.backgroundColor = .systemBackground
        view.addSubview(posterImageView)
        view.addSubview(infoLabel) //
        view.addSubview(overviewLabel)
        view.addSubview(addAndRemoveButton)
        view.addSubview(watchTrailerButton)
        
        hstack = UIStackView(arrangedSubviews: [addAndRemoveButton, watchTrailerButton])
        hstack.axis = .horizontal
        hstack.distribution = .fillEqually
        hstack.spacing = 20
        hstack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hstack)
        
    }
     
    
    private func setConstraints() {
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
            infoLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20),
            infoLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: addAndRemoveButton.topAnchor, constant: -10),
        ])
        
//        NSLayoutConstraint.activate([
//            addToWatchlistButton.heightAnchor.constraint(equalToConstant: 35),
//            addToWatchlistButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
//            addToWatchlistButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -15),
//            addToWatchlistButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -18)
//        ])
//
//        NSLayoutConstraint.activate([
//            watchTrailerButton.heightAnchor.constraint(equalToConstant: 35),
//            watchTrailerButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 15),
//            watchTrailerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
//            watchTrailerButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -18)
//        ])
        NSLayoutConstraint.activate([
            hstack.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            hstack.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            hstack.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -18)
        ])
 
    }
    
    @objc private func addToWatchlist() {
        guard let selectedMovie = selectedMovie else { return }
        
        if !WatchlistStorage.shared.watchList.contains(selectedMovie) {
            presentAlert(message: "Add to watchlist?", actionTitle: "Add") { _ in
                WatchlistStorage.shared.watchList.append(selectedMovie)
                WatchlistStorage.shared.saveWatchlist()
                self.addAndRemoveButton.setTitle("Remove", for: .normal)
                self.navigationController?.popViewController(animated: true)                
            }
        } else {
            presentAlert(message: "Remove from watchlist?", actionTitle: "Remove") { _ in
                guard let indexPath = WatchlistStorage.shared.watchList.firstIndex(of: selectedMovie) else { return }
                WatchlistStorage.shared.watchList.remove(at: indexPath)
                WatchlistStorage.shared.saveWatchlist()
                self.addAndRemoveButton.setTitle("Add to watchlist", for: .normal)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func watchTrailer() {
        guard let query = selectedMovie?.title?.replacingOccurrences(of: " ", with: "+") else { return }
        let escapedYoutubeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let appURL = NSURL(string: "youtube://www.youtube.com/results?search_query=\(escapedYoutubeQuery!)")!
        let webURL = NSURL(string: "https://www.youtube.com/results?search_query=\(escapedYoutubeQuery!)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }
    
    
}
