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
struct Genre: Codable {
  let id: Int?
  let name: String?
}
class Movie: Object, Codable {
    
    init(id: Int, adult: Bool, backdropPath: String, genreIDS: List<Int>, originalTitle: String?, overview: String, popularity: Double?, posterPath: String, releaseDate: String, title: String, video: Bool, voteAverage: Double, voteCount: Int) {
        super.init()
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
      }
    
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
  convenience required init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
    backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    genreIDS = try container.decode(List<Int>.self, forKey: .genreIDS)
    originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
    overview = try container.decodeIfPresent(String.self, forKey: .overview)
    popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
    posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
    title = try container.decodeIfPresent(String.self, forKey: .title)
    video = try container.decodeIfPresent(Bool.self, forKey: .video)
    voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
    voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
  }
}
enum OriginalLanguage: String, Codable {
  case en = "en"
  case es = "es"
  case nl = "nl"
}



//import Foundation
//import RealmSwift
//// MARK: - Welcome
//struct MovieResponse: Codable {
//    let page: Int?
//    let results: [Movie]?
//    let totalPages, totalResults: Int?
//    enum CodingKeys: String, CodingKey {
//        case page, results
//        case totalPages = "total_pages"
//        case totalResults = "total_results"
//    }
//
//}
//struct GenreResponse: Codable {
//    let genres: [Genre]?
//}
//// MARK: - Genre
//struct Genre: Codable {
//    let id: Int?
//    let name: String?
//}
//// MARK: - Result
//class Movie: Object, Codable {
//    @Persisted var adult: Bool?
//    @Persisted var backdropPath: String?
//    @Persisted var genreIDS: List<Int>?
//    @Persisted var id: Int?
//    @Persisted var originalTitle, overview: String?
//    @Persisted var popularity: Double?
//    @Persisted var posterPath, releaseDate, title: String?
//    @Persisted var video: Bool?
//    @Persisted var voteAverage: Double?
//    @Persisted var voteCount: Int?
//    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case genreIDS = "genre_ids"
//        case id
//        case originalTitle = "original_title"
//        case overview, popularity
//        case posterPath = "poster_path"
//        case releaseDate = "release_date"
//        case title, video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(adult, forKey: .adult)
//        try container.encode(backdropPath, forKey: .backdropPath)
//        try container.encode(genreIDS, forKey: .genreIDS)
//        try container.encode(id, forKey: .id)
//        try container.encode(originalTitle, forKey: .originalTitle)
//        try container.encode(popularity, forKey: .popularity)
//        try container.encode(posterPath, forKey: .posterPath)
//        try container.encode(overview, forKey: .overview)
//        try container.encode(releaseDate, forKey: .releaseDate)
//        try container.encode(title, forKey: .title)
//        try container.encode(video, forKey: .video)
//        try container.encode(voteAverage, forKey: .voteAverage)
//        try container.encode(voteCount, forKey: .voteCount)
//
//           // Diğer özellikleri encode etme
//       }
//}
//enum OriginalLanguage: String, Codable {
//    case en = "en"
//    case es = "es"
//    case nl = "nl"
//}
//
//
//
//
////import Foundation
////import RealmSwift
////
////// MARK: - Welcome
////struct MovieResponse: Codable {
////    let page: Int?
////    let results: [Movie]?
////    let totalPages, totalResults: Int?
////    enum CodingKeys: String, CodingKey {
////        case page, results
////        case totalPages = "total_pages"
////        case totalResults = "total_results"
////    }
////}
////
////struct GenreResponse: Codable {
////    let genres: [Genre]?
////}
////// MARK: - Genre
////struct Genre: Codable {
////    let id: Int?
////    let name: String?
////}
////// MARK: - Result
////struct Movie: Codable {
////    let adult: Bool?
////    let backdropPath: String?
////    let genreIDS: [Int]?
////    var id: Int?
////    let originalTitle, overview: String?
////    let popularity: Double?
////    let posterPath, releaseDate, title: String?
////    let video: Bool?
////    let voteAverage: Double?
////    let voteCount: Int?
////
////    enum CodingKeys: String, CodingKey {
////        case adult
////        case backdropPath = "backdrop_path"
////        case genreIDS = "genre_ids"
////        case id
////        case originalTitle = "original_title"
////        case overview, popularity
////        case posterPath = "poster_path"
////        case releaseDate = "release_date"
////        case title, video
////        case voteAverage = "vote_average"
////        case voteCount = "vote_count"
////    }
////}
////
////enum OriginalLanguage: String, Codable {
////    case en = "en"
////    case es = "es"
////    case nl = "nl"
////}
