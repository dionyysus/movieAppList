//
//  SearchViewModel.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 6.07.2023.
//

import Foundation

class SearchViewModel{
    
    private var apiManager: APIManager?
    var filteredMovies: [Movie]?
    var categoryMovies: [Movie]?
    var movies: [Movie]?
    
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


