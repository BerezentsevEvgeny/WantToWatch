//
//  SearchControllerModel.swift
//  Watcher
//
//  Created by Евгений Березенцев on 02.09.2021.
//

import Foundation

class SearchControllerModel {
    
    static let shared = SearchControllerModel()
    
    var searchedMovies = [Movie]()

    func fetchSearchedMoviesData(movieTosearch: String, completion: @escaping () -> ()) {
        NetworkManager.shared.getSearchedMoviesData(lookingForMovie: movieTosearch) { [weak self] result in
            switch result {
            case .success(let listOf):
                self?.searchedMovies = listOf.movies
                    completion()
            case .failure(let error):
                print("Error processing data \(error)")
            }
        }
    }
    
    private init() {}

}
