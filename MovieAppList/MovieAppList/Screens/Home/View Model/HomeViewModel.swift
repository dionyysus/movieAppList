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

    
}


//        // TODO: network istekleri viewModel'e alınacak
//        APIManager.shared.execute(url: APIManager.shared.apiURL) { (data: MovieResponse?) in
//            self.movies = data?.results ?? []
//            self.categoryMovies = data?.results ?? []
//            // TODO: main async değişimi servis isteğinde response alındığı yerde yapılacak
//            DispatchQueue.main.async {
//                self.moviesCollectionView.reloadData()
//                self.categoryCollectionView.reloadData()
//            }
//        }
//        APIManager.shared.execute(url: APIManager.shared.genreApiURL) { (data: GenreResponse?) in
//            self.genres = data?.genres ?? []
//            DispatchQueue.main.async {
//                self.moviesCollectionView.reloadData()
//                self.categoryCollectionView.reloadData()
//            }
//        }
//
