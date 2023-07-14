//
//  SearchViewModel.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 6.07.2023.
//

import Foundation

class SearchViewModel{
    
    var movies: [Movie]?
    var genres: [Genre]?
    private var apiManager: APIManager?
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
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
            self.movies = data?.results ?? []
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}


