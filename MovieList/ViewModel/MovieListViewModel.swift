//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by Suresh Kumar on 14/02/25.
//

import Foundation

/////MARK Using UserDefault for saving data
class MovieListViewModelOne: MovieStorageProtocol, ObservableObject {
    @Published var movies: [Movie] = []
    
    init() {
        movies = loadMovie(forKey: "movies")
        
        if movies.isEmpty {
            // Initialize movies if first-time use
            movies = [
                Movie(id: 1, name: "Inception"),
                Movie(id: 2, name: "Interstellar"),
                Movie(id: 3, name: "The Matrix"),
                Movie(id: 4, name: "Titanic"),
                Movie(id: 5, name: "Avatar"),
                Movie(id: 6, name: "The Dark Knight"),
                Movie(id: 7, name: "The Prestige"),
                Movie(id: 8, name: "Forrest Gump"),
                Movie(id: 9, name: "The Shawshank Redemption"),
                Movie(id: 10, name: "Pulp Fiction"),
                Movie(id: 11, name: "Gladiator"),
                Movie(id: 12, name: "The Godfather"),
                Movie(id: 13, name: "Schindler's List"),
                Movie(id: 14, name: "Fight Club"),
                Movie(id: 15, name: "The Lion King")
            ]
            saveMovie(movies, forKey: "movies")
        }
    }
    
    func toggleWatchedList(_ id: Int) {
        if let index = movies.firstIndex(where: {$0.id == id}) {
            movies[index].watched.toggle()
            movies = movies
            saveMovie(movies, forKey: "movies")
        }
    }
    
    func toggleWatchList(_ id: Int) {
        if let index = movies.firstIndex(where: {$0.id == id}) {
            movies[index].watch.toggle()
            movies = movies
            saveMovie(movies, forKey: "movies")
        }
    }
}

///// Using CoreData for storage , fetching data in sync and one go
class MovieListViewModelTwo: ObservableObject {
    @Published var movies: [Movie]
    private let movieStorage = MovieStorage.shared
    
    
    init() {
        movies = movieStorage.fetchMovies()
        
        if movies.isEmpty {
            let intialMovies = [
                Movie(id: 1, name: "Inception"),
                Movie(id: 2, name: "Interstellar"),
                Movie(id: 3, name: "The Matrix"),
                Movie(id: 4, name: "Titanic"),
                Movie(id: 5, name: "Avatar"),
                Movie(id: 6, name: "The Dark Knight"),
                Movie(id: 7, name: "The Prestige"),
                Movie(id: 8, name: "Forrest Gump"),
                Movie(id: 9, name: "The Shawshank Redemption"),
                Movie(id: 10, name: "Pulp Fiction"),
                Movie(id: 11, name: "Gladiator"),
                Movie(id: 12, name: "The Godfather"),
                Movie(id: 13, name: "Schindler's List"),
                Movie(id: 14, name: "Fight Club"),
                Movie(id: 15, name: "The Lion King")
            ]
            
            intialMovies.forEach{ movieStorage.saveMovie($0) }
            
            movies = movieStorage.fetchMovies()
        }
    }
    
    func toggleWatchedList(_ id: Int) {
        if let index = movies.firstIndex(where: {$0.id == id}) {
            movies[index].watched.toggle()
            movieStorage.updateMovie(movies[index])
        }
    }
    
    func toggleWatchList(_ id: Int) {
        if let index = movies.firstIndex(where: {$0.id == id}) {
            movies[index].watch.toggle()
            movieStorage.updateMovie(movies[index])
        }
    }
}

/// Using CoreData for storage , fetching data in async and in batches
class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    
    private let movieStorage = MovieStorage.shared
    
    private var offSet = 0
    private var batchSize = 5
    
    init() {
        movieStorage.insertInitialMoviesIfNeeded() // Ensures data is available
        fetchNextBatch()
    }
    
    func fetchNextBatch() {
        movieStorage.fetchMoviesAsync(offSet: offSet, batchSize: batchSize) { movies in
            self.offSet += self.batchSize
            DispatchQueue.main.async {
                self.movies.append(contentsOf: movies)
            }
        }
    }
    
    func toggleWatchedList(_ id: Int) {
        if let index = movies.firstIndex(where: {$0.id == id}) {
            movies[index].watched.toggle()
            movieStorage.updateMovieAsync(movies[index])
        }
    }
    
    func toggleWatchList(_ id: Int) {
        if let index = movies.firstIndex(where: {$0.id == id}) {
            movies[index].watch.toggle()
            movieStorage.updateMovieAsync(movies[index])
        }
    }
}

