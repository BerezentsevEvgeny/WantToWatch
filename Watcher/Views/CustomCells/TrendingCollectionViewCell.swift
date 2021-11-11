//
//  MainCollectionViewCell.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {
    
    var posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(posterImageView)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10  //
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.6
        layer.shadowOffset = .zero
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        ])
    }
}
