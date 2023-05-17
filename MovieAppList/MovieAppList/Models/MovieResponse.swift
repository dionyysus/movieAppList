

import Foundation

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
// MARK: - Result
struct Movie: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    var id: Int?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case nl = "nl"
}
