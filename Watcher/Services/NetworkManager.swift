//
//  NetworkManager.swift
//  Watcher
//
//  Created by Евгений Березенцев on 24.08.2021.
//

import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let myApiKey = "api_key=7f436759c524bf275d9293a80907af37"
            
    //MARK: - Fetch trending movies
    func getTrendingMoviesData(complition: @escaping (Result<MoviesData,Error>) -> Void) {
        
        AF.request("https://api.themoviedb.org/3/movie/popular?" + myApiKey
                    + "&page=1&language=us_US").responseData { response in
            guard let data = response.data, response.error == nil else { return }
                        
            do {
                let decoder = JSONDecoder()
                let trendingMovies = try decoder.decode(MoviesData.self, from: data)
                DispatchQueue.main.async {
                    complition(.success(trendingMovies))
                }
            } catch {
                complition(.failure(error))
            }
        }
    }
    
    //MARK: - Fetch searching movies
    func getSearchedMoviesData(lookingForMovie: String, completition: @escaping (Result<MoviesData, Error>) -> Void) {
        
        let apiURL1 = "https://api.themoviedb.org/3/search/movie?"
        let apiURL2 = "&language=en-US&page=1&include_adult=false"
        let searchedMoviesURL = apiURL1 + myApiKey + apiURL2 + "&query=\(lookingForMovie)"
        
        guard let url = URL(string: searchedMoviesURL) else { return }
        AF.request(url).responseData { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let searchedMovies = try decoder.decode(MoviesData.self, from: data)
                DispatchQueue.main.async {
                    completition(.success(searchedMovies))
                }
            } catch {
                completition(.failure(error))
            }
        }
    }
    
    //MARK: - Fetch searching image
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
    
    
    private init() {}
}
