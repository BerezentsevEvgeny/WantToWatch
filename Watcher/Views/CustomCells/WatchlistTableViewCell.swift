//
//  WatchlistTableViewCell.swift
//  Watcher
//
//  Created by Евгений Березенцев on 05.09.2021.
//

import UIKit

class WatchlistTableViewCell: UITableViewCell {
    
    static let identifier = "watchlistCell"
    
    func configureCell(with movie: Movie?) {
        guard let movie = movie else { return }
        var content = defaultContentConfiguration()
        content.text = movie.title
        content.textProperties.font = .systemFont(ofSize: 20, weight: .medium)
        content.secondaryText = movie.year?.replacingOccurrences(of: "-", with: ".")
        content.imageProperties.cornerRadius = 4
        guard let urlString = movie.posterImage, let url = URL(string: "https://image.tmdb.org/t/p/w200" + urlString) else  { return }
        APIService.shared.fetchImage(from: url) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    content.image = image
                    self?.contentConfiguration = content
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
