//
//  FavoriteViewModel.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 7.06.2023.
//

import Foundation

class FavoriteViewModel {
    
    var movie: Movie?
    var firstGenre: Genre?
    var genres: [Genre]?

    init(movie: Movie? = nil, firstGenre: Genre? = nil, genres: [Genre]? = nil) {
        self.movie = movie
        self.firstGenre = firstGenre
        self.genres = genres
    }
}
