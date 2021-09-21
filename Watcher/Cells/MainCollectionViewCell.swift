//
//  MainCollectionViewCell.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    var posterImage: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        return posterImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(posterImage) //
        contentView.clipsToBounds = true //
        contentView.layer.cornerRadius = 10  //
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
                
        NSLayoutConstraint.activate([
            posterImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImage.topAnchor.constraint(equalTo: topAnchor),
            posterImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
