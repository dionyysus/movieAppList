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
    
    func saveMovie(_ movie: MovieEntity) {
        try! realm.write {
            realm.add(movie, update: .modified)
        }
    }
    
    func deleteMovie(_ movie: MovieEntity) {
        
        do {
            try realm.write {
                realm.delete(movie)
            }
        } catch {
            print("Failed to delete movie property: \(error.localizedDescription)")
        }
    }
    
    func getAllMovies() -> Results<MovieEntity> {
        return realm.objects(MovieEntity.self)
    }
    
    func getMovie(withID id: Int) -> MovieEntity? {
        return realm.object(ofType: MovieEntity.self, forPrimaryKey: id)
    }
}


