//
//  APIManager.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 6.05.2023.
//

import Foundation

class APIManager {

    static let shared = APIManager()
    
    private var favoriteMoviesArray: [Movie] = []

    private init() {}
    
    func setFavoriteMovie(movie: Movie) -> Bool {

        if !favoriteMoviesArray.contains(where: {$0.id == movie.id}){
            favoriteMoviesArray.append(movie)
        } else {
            if let index = favoriteMoviesArray.firstIndex(where: {$0.id == movie.id}) {
                favoriteMoviesArray.remove(at: index)
            }
            return false
        }
        return true
          
//        for item in movie {
//            if !favoriteMoviesArray.contains(where: {$0.id == item.id}){
//                favoriteMoviesArray.append(contentsOf: movie)
//            } else {
//                if let index = favoriteMoviesArray.firstIndex(where: {$0.id == item.id}) {
//                    favoriteMoviesArray.remove(at: index)
//                }
//                return false
//            }
//        }
        
    }
    
    func getFavoriteMovies() -> [Movie]{
        return favoriteMoviesArray
    }
    
    func fetchMovies<Model: Decodable>(url: String, completion: @escaping(Model?) -> ()) {
        
        let baseUrl = URL(string: url)
        let session = URLSession(configuration: .default)
        if let url = baseUrl {
            let dataTask = session.dataTask(with: url) {(data, response, error) in
                if error == nil {
                    if let data = data {
                        do {
                            let decodedData = try JSONDecoder().decode(Model.self, from: data)
                            completion(decodedData)
                        } catch {
                            print("ggwp parsing error \(error)")
                        }
                    } else {
                        print("ggwp failed fetch data")
                        completion(nil)
                    }
                } else {
                    print("ggwp error data task \(String(describing: error))")
                    completion(nil)
                }
            }
            dataTask.resume()
        }
    }
}
