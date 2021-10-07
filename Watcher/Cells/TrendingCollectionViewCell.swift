//
//  MainCollectionViewCell.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {
    
    var posterImage = UIImageView()
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLabel) //
//        titleLabel.text = "Hello"
        titleLabel.backgroundColor = .systemBlue //
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10  //
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false   //
        
        NSLayoutConstraint.activate([
            posterImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImage.topAnchor.constraint(equalTo: topAnchor),
            posterImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            
            
        ])
    }
}
