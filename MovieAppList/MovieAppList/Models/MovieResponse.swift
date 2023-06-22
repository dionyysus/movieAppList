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
class Genre: Object, Codable {
    @Persisted  var id: Int?
    @Persisted var name: String?
}

class Movie: Object, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var adult: Bool?
    @Persisted var backdropPath: String?
    @Persisted var genreIDS: List<Int>
    @Persisted var originalTitle: String?
    @Persisted var overview: String?
    @Persisted var popularity: Double?
    @Persisted var posterPath: String?
    @Persisted var releaseDate: String?
    @Persisted var title: String?
    @Persisted var video: Bool?
    @Persisted var voteAverage: Double?
    @Persisted var voteCount: Int?
    @Persisted var firstGenre: Genre?
    
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
    
    convenience init(id: Int, adult: Bool, backdropPath: String,
                     genreIDS: List<Int>, originalTitle: String?,
                     overview: String, popularity: Double?, posterPath: String,
                     releaseDate: String, title: String, video: Bool,
                     voteAverage: Double, voteCount: Int, firstGenre: Genre?) {
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
        self.firstGenre = firstGenre
    }
}
enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case nl = "nl"
}
