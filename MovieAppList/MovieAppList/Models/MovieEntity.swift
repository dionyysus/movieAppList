//
//  MovieEntity.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 23.06.2023.
//

import Foundation
import RealmSwift

class MovieEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var adult: Bool?
    @Persisted var backdropPath: String?
    @Persisted var genreIDS: List<Int?>
    @Persisted var originalTitle: String?
    @Persisted var overview: String?
    @Persisted var popularity: Double?
    @Persisted var posterPath: String?
    @Persisted var releaseDate: String?
    @Persisted var title: String?
    @Persisted var video: Bool?
    @Persisted var voteAverage: Double?
    @Persisted var voteCount: Int?
    @Persisted var genreName: String?
    
    convenience init(id: Int, adult: Bool, backdropPath: String,
                     genreIDS: List<Int?>, originalTitle: String?,
                     overview: String, popularity: Double?, posterPath: String,
                     releaseDate: String, title: String, video: Bool,
                     voteAverage: Double, voteCount: Int, genreName: String?) {
        self.init()
        self.id = id
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.genreName = genreName
    }
    
    static func mapToEntity(model: Movie) -> MovieEntity {
        return MovieEntity(id: model.id, adult: model.adult ?? false,
                           backdropPath: model.backdropPath ?? "", genreIDS: model.genreIDS,
                           originalTitle: model.originalTitle, overview: model.overview ?? "",
                           popularity: model.popularity, posterPath: model.posterPath ?? "",
                           releaseDate: model.releaseDate ?? "", title: model.title ?? "",
                           video: model.video ?? false, voteAverage: model.voteAverage ?? 0.0,
                           voteCount: model.voteCount ?? 0, genreName: model.genreName)
    }
}
