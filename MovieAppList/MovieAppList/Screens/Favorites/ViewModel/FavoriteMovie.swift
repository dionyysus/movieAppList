//
//  FavoriteMovie.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 11.06.2023.
//

import Foundation

import RealmSwift

class FavoriteMovie: Object {
    @objc dynamic var id = ""
        
    override static func primaryKey() -> String? {
        return "id"
    }
}
