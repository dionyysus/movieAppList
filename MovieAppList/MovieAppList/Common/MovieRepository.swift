//
//  MovieRepository.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 17.06.2023.
//

import Foundation
import RealmSwift

class RealmManager {
  static let shared = RealmManager()
  private let realm: Realm
  private init() {
    realm = try! Realm()
  }
  func saveMovie(_ movie: Movie) {
    try! realm.write {
      realm.add(movie, update: .modified)
    }
  }
  func deleteMovie(_ movie: Movie) {
    try! realm.write {
      realm.delete(movie)
    }
  }
  func getAllMovies() -> Results<Movie> {
    return realm.objects(Movie.self)
  }
}


//class MovieRepository {
//    private let realm: Realm
//
//    init(realm: Realm) {
//        self.realm = realm
//    }
//
//    func addMovie(movie: MovieObject) {
//        do {
//            try realm.write {
//                realm.add(movie)
//            }
//        } catch {
//            print("Failed to add movie: \(error)")
//        }
//    }
//
//    func getAllMovies() -> Results<MovieObject>? {
//        return realm.objects(MovieObject.self)
//    }
//
//    func getMovieById(id: Int) -> MovieObject? {
//        return realm.object(ofType: MovieObject.self, forPrimaryKey: id)
//    }
//
//    func updateMovie(movie: MovieObject) {
//        do {
//            try realm.write {
//                realm.add(movie, update: .modified)
//            }
//        } catch {
//            print("Failed to update movie: \(error)")
//        }
//    }
//
//    func deleteMovie(movie: MovieObject) {
//        do {
//            try realm.write {
//                realm.delete(movie)
//            }
//        } catch {
//            print("Failed to delete movie: \(error)")
//        }
//    }
//}
