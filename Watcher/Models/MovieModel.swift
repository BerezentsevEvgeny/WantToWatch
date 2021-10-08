//
//  MovieModel.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

struct MoviesData: Decodable {
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie : Codable, Hashable {
    let id: Int?
    let title: String?
    let year: String?
    let rate: Double?
    let posterImage: String?
    let overview: String?
    let popularity: Float?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title, overview
        case year = "release_date"
        case rate = "vote_average"
        case posterImage = "poster_path"
        case popularity = "popularity"
    }
}
