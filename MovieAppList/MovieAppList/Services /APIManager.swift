//
//  APIManager.swift
//  MovieAppList
//
//  Created by Gizem Coşkun on 6.05.2023.
//

import Foundation

class APIManager {

    static let shared = APIManager()
    private init() {}
    
    func fetchMovies<Model: Decodable>(url: String, completion: @escaping(Model?) -> ()) {
        
        let baseUrl = URL(string: url)
        let session = URLSession(configuration: .default)
        if let url = baseUrl {
            let dataTask = session.dataTask(with: url) {(data, response, error) in
                if error == nil {
                    if let data = data {
                        do {
                            let decodedData = try JSONDecoder().decode(Model.self, from: data)
                            completion(decodedData)
                        } catch {
                            print("ggwp parsing error \(error)")
                        }
                    } else {
                        print("ggwp failed fetch data")
                        completion(nil)
                    }
                } else {
                    print("ggwp error data task \(String(describing: error))")
                    completion(nil)
                }
            }
            dataTask.resume()
        }
    }
}
