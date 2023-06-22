//
//  DetailViewModel.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 28.04.2023.
//

import Foundation

class DetailViewModel{
    
    var movie: Movie?
    var firstGenre: Genre?
    
    init(movie: Movie, firstGenre: Genre?) {
        self.movie = movie
        self.firstGenre = firstGenre
    }
    
}
