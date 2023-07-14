//
//  FavoriteViewModel.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 7.06.2023.
//

import Foundation
import RealmSwift
class FavoriteViewModel {
    
    var movie: Movie?
    var firstGenre: Genre?
    var genres: [Genre]?

    func fetchGenres(completion: @escaping () -> Void) {
        APIManager.shared.execute(url: APIManager.shared.genreApiURL) { (data: GenreResponse?) in
            self.genres = data?.genres ?? []
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    init(movie: Movie? = nil, firstGenre: Genre? = nil, genres: [Genre]? = nil) {
        self.movie = movie
        self.firstGenre = firstGenre
        self.genres = genres
    }
}
