//
//  MovieModel.swift
//  MovieList
//
//  Created by Suresh Kumar on 14/02/25.
//

import Foundation

struct Movie: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    var watched: Bool = false
    var watch: Bool = false
}
