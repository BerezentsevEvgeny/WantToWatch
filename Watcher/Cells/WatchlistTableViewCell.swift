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
//        accessoryType = .disclosureIndicator
        var content = defaultContentConfiguration()
        content.text = movie.title
        content.secondaryText = movie.year
        content.imageProperties.cornerRadius = 4
        guard let urlString = movie.posterImage, let url = URL(string: "https://image.tmdb.org/t/p/w200" + urlString) else  { return }
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    content.image = image
                    self.contentConfiguration = content
                }
            case .failure(let error):
                print(error)
            }
        }
    }



}
