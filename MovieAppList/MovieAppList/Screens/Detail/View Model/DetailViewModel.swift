//
//  DetailViewModel.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 28.04.2023.
//

import Foundation

class DetailViewModel{
    
    var movie: Movie?
    var genreName: String?
    
    init(movie: Movie, genreName: String?) {
        self.movie = movie
        self.genreName = genreName
    }
    
}
