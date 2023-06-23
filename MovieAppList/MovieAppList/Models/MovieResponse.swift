import Foundation
import RealmSwift


// MARK: - Welcome
struct MovieResponse: Codable {
    let page: Int?
    let results: [Movie]?
    let totalPages, totalResults: Int?
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
struct GenreResponse: Codable {
    let genres: [Genre]?
}
// MARK: - Genre
class Genre: Codable {
    var id: Int?
    var name: String?
}

class Movie: Codable {
    var id: Int
    var adult: Bool?
    var backdropPath: String?
    var genreIDS: List<Int?>
    var originalTitle: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var releaseDate: String?
    var title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var genreName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(id: Int, adult: Bool, backdropPath: String,
         genreIDS: List<Int?>, originalTitle: String?,
         overview: String, popularity: Double?, posterPath: String,
         releaseDate: String, title: String, video: Bool,
         voteAverage: Double, voteCount: Int, genreName: String?) {
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
    
    static func mapToItem(model: MovieEntity) -> Movie {
        return Movie(id: model.id, adult: model.adult ?? false,
                           backdropPath: model.backdropPath ?? "", genreIDS: model.genreIDS,
                           originalTitle: model.originalTitle, overview: model.overview ?? "",
                           popularity: model.popularity, posterPath: model.posterPath ?? "",
                           releaseDate: model.releaseDate ?? "", title: model.title ?? "",
                           video: model.video ?? false, voteAverage: model.voteAverage ?? 0.0,
                           voteCount: model.voteCount ?? 0, genreName: model.genreName)
    }
}
enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case nl = "nl"
}
