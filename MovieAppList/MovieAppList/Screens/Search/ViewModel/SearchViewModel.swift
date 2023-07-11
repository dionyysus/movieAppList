//
//  SearchViewModel.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 6.07.2023.
//

import Foundation

class SearchViewModel{
    

    var movies: [Movie]?
    private var apiManager: APIManager?
    var firstGenre: Genre?

    init(apiManager: APIManager) {
           self.apiManager = apiManager
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


