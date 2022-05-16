//
//  MainCollectionViewCell.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {
        
    func configureCell(with movie: Movie) {
        let posterImageView = UIImageView()
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.6
        layer.shadowOffset = .zero
        
        posterImageView.frame = contentView.bounds
        contentView.addSubview(posterImageView)
        guard let posterImage = movie.posterImage else { return }
        let urlString = "https://image.tmdb.org/t/p/w300" + posterImage
        let url = URL(string: urlString)!
        posterImageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "moviePlaceholder"))
    }
    

}
