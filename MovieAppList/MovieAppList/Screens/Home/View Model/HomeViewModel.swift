//
//  HomeViewModel.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 28.04.2023.
//

import Foundation

class HomeViewModel {

    var movies: [Movie]? //all movies
    var genres: [Genre]? //all categories
    var filteredMovies: [Movie]? // searching
    var categoryMovies: [Movie]?
    
    private var apiManager: APIManager?
    
    init(apiManager: APIManager) {
           self.apiManager = apiManager
       }
    
    func fetchMovies(completion: @escaping () -> Void) {
        APIManager.shared.execute(url: APIManager.shared.apiURL) { (data: MovieResponse?) in
            
            self.movies = data?.results ?? []
            self.categoryMovies = data?.results ?? []
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func fetchGenres(completion: @escaping () -> Void) {
        APIManager.shared.execute(url: APIManager.shared.genreApiURL) { (data: GenreResponse?) in
                
            self.genres = data?.genres ?? []
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func fetchMovie(named name: String, completion: @escaping () -> Void) {
    apiManager = APIManager.shared
      guard let apiManager = apiManager else { return }
        apiManager.query = name
        apiManager.execute(url: apiManager.searchApiURL) { (data: MovieResponse?) in
            self.filteredMovies = data?.results ?? []
            self.categoryMovies = data?.results ?? []
            self.movies = data?.results ?? []
            DispatchQueue.main.async {
              completion()
            }
        }
    }
}

