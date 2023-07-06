//  APIManager.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 6.05.2023.
//

import Foundation
import RealmSwift

// movie api: https://api.themoviedb.org/3/discover/movie?api_key=d0cb5f9ae1c996d1bd22dc17e287debd

class APIManager {

    static let shared = APIManager()
    
    private var favoriteMoviesArray: [Movie] = []
    private var categoryMoviesArray: [Genre] = []
    private var searchedMoviesArray: [Movie] = []

    var query = String()

    var baseURL = "https://api.themoviedb.org/"
    var apiKey = "api_key=d0cb5f9ae1c996d1bd22dc17e287debd"

    var apiURL: String {
        baseURL + "3/discover/movie?" + apiKey
    }
    
    var genreApiURL: String {
        baseURL + "3/genre/movie/list?" + apiKey
    }

    var searchApiURL: String {
      baseURL + "3/search/movie?query=\(query)&" + apiKey
    }

    let imgUrl = "http://image.tmdb.org/t/p/w500"

    private init() { }

    func setFavoriteMovie(movie: Movie, genre: Genre) -> Bool {

        if !favoriteMoviesArray.contains(where: {$0.id == movie.id}){
            favoriteMoviesArray.append(movie)
            categoryMoviesArray.append(genre)
        } else {
            if let index = favoriteMoviesArray.firstIndex(where: {$0.id == movie.id}), let categoryIndex = categoryMoviesArray.firstIndex(where: {$0.id == genre.id}) {
                favoriteMoviesArray.remove(at: index)
                categoryMoviesArray.remove(at: categoryIndex)
            }
            return false
        }
        return true
    }
    
    func getFavoriteMovies() -> [Movie] {
        return favoriteMoviesArray
    }

    func getCategoryMovies() -> [Genre] {
        return categoryMoviesArray
    }
    func getSearchedMovies(title: String) -> [Movie] {
            return searchedMoviesArray
    }
  
    func execute<T: Decodable>(url: String, completion: @escaping(T?) -> ()) {
        guard let url = URL(string: url) else { return }
        
        let session = URLSession(configuration: .default)

        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(decodedData)
                    } catch {
                        print("parsing error \(error)")
                    }
                } else {
                    print("failed fetch data")
                    completion(nil)
                }
            } else {
                print("error data task \(String(describing: error))")
                completion(nil)
            }
        }
        dataTask.resume()
    }
}
