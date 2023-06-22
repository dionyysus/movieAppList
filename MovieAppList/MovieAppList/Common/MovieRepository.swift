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
    let realm: Realm
    
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
    
    func getMovie(withID id: Int) -> Movie? {
        return realm.object(ofType: Movie.self, forPrimaryKey: id)
    }
    
    // Update a movie's property
    func updateMovieProperty(movie: Movie, newValue: Genre?) {
        do {
            try realm.write {
                movie.firstGenre = newValue
            }
            print("Movie property updated successfully")
        } catch {
            print("Failed to update movie property: \(error.localizedDescription)")
        }
    }
}

