//
//  TrendingViewModel.swift
//  Watcher
//
//  Created by Евгений Березенцев on 16.05.2022.
//

import Foundation

protocol TrendingViewModelProtocol {
    var trendingMovies: [Movie] { get }
    func getTrendingMovies(completion: @escaping () -> Void)
}

class TrendingViewModel: TrendingViewModelProtocol {
    
    var trendingMovies = [Movie]()
    
    func getTrendingMovies(completion: @escaping () -> Void) {
        APIService.shared.getTrendingMoviesData { [unowned self] result in
            switch result {
            case .success(let listOf):
                self.trendingMovies = listOf.movies
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
