//
//  NetworkManager.swift
//  Watcher
//
//  Created by Евгений Березенцев on 24.08.2021.
//

import Alamofire
import UIKit

class APIService {
    
    static let shared = APIService()
    
    let myApiKey = "api_key=7f436759c524bf275d9293a80907af37"
    
    private init() {}
            
    // Fetch trending movies
    func getTrendingMoviesData(complition: @escaping (Result<MoviesData,Error>) -> Void) {
        
        AF.request("https://api.themoviedb.org/3/movie/popular?" + myApiKey
                   + "&page=1&language=us_US").responseData { response in
            guard let data = response.data, response.error == nil else {
                print(response.error?.localizedDescription ?? "No description")
                return }
            
            do {
                let trendingMovies = try JSONDecoder().decode(MoviesData.self, from: data)
                DispatchQueue.main.async {
                    complition(.success(trendingMovies))
                }
            } catch {
                complition(.failure(error))
            }
        }
    }
        
    // Fetch searching movies
    func getSearchedMoviesData(lookingForMovie: String, completition: @escaping (Result<MoviesData, Error>) -> Void) {
        
        let apiURL1 = "https://api.themoviedb.org/3/search/movie?"
        let apiURL2 = "&language=en-US&page=1&include_adult=false"
        let searchedMoviesURL = apiURL1 + myApiKey + apiURL2 + "&query=\(lookingForMovie)"
        guard let url = URL(string: searchedMoviesURL) else { return }
        
        AF.request(url).responseData { response in
            guard let data = response.data else {
                print(response.error?.localizedDescription ?? "No description")
                return }
            
            do {
                let searchedMovies = try JSONDecoder().decode(MoviesData.self, from: data)
                DispatchQueue.main.async {
                    completition(.success(searchedMovies))
                }
            } catch {
                completition(.failure(error))
            }
        }
    }
    
    // Fetch searching image
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
