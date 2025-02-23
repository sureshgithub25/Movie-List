//
//  MovieStorageProtocol.swift
//  MovieList
//
//  Created by Suresh Kumar on 16/02/25.
//

import Foundation

protocol MovieStorageProtocol {
    func saveMovie(_ movies: [Movie], forKey key: String)
    func loadMovie( forKey key: String) -> [Movie]
}

extension MovieStorageProtocol {
    
    func saveMovie(_ movies: [Movie], forKey key: String) {
        let userDefaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(movies) {
            userDefaults.set(encoded, forKey: key)
        }
    }
    
    func loadMovie(forKey key: String) -> [Movie] {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.data(forKey: key),
              let movies = try? JSONDecoder().decode([Movie].self, from: data) else {
            return []
        }
        return movies
    }
}
