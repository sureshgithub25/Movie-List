//
//  MovieStorage.swift
//  MovieList
//
//  Created by Suresh Kumar on 19/02/25.
//

import Foundation
import CoreData

class MovieStorage {
    static let shared = MovieStorage()
    
    private var context = CoreDataStack.shared.context
    
    func fetchMovies() -> [Movie] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        do {
            let entites = try context.fetch(request)
            return entites.map { entity in
                Movie(id: Int(entity.id),
                      name: entity.name ?? "",
                      watched: entity.watched,
                      watch: entity.watch)
            }
            
        } catch {
            return []
        }
    }
    
    func saveMovie(_ movie: Movie) {
        let entity = MovieEntity(context: context)
        entity.id = Int64(movie.id)
        entity.name = movie.name
        entity.watch = movie.watch
        entity.watched = movie.watched
        CoreDataStack.shared.saveContext()
    }
    
    func updateMovie(_ movie: Movie) {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movie.id)
        
        do {
            let result = try context.fetch(request)
            
            if let entity = result.first {
                entity.watched = movie.watched
                entity.watch = movie.watch
                
                CoreDataStack.shared.saveContext()
            }
        } catch {
            
        }
    }
    
    func deleteMovie(_ movie: Movie) {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movie.id)
        
        do {
            let result = try context.fetch(request)
            if let entity = result.first {
                context.delete(entity)
                CoreDataStack.shared.saveContext()
            }
        } catch {
            
        }
    }
    
    func fetchMoviesAsync(offSet: Int = 0, batchSize: Int = 10, completion: @escaping ([Movie]) -> Void) {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.fetchLimit = batchSize
        request.fetchOffset = offSet
        
        let context = CoreDataStack.shared.presistentContainer.newBackgroundContext()
        
        context.perform {
            do {
                 let entities = try context.fetch(request)
                let movies = entities.map { entity in
                    Movie(id: Int(entity.id),
                          name: entity.name ?? "",
                          watched: entity.watched,
                          watch: entity.watch)
                }
                completion(movies)
            } catch {
                completion([])
            }
        }
    }
    
    func updateMovieAsync(_ movie: Movie) {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movie.id)
        
        let context = CoreDataStack.shared.presistentContainer.newBackgroundContext()
        
        context.perform {
            
            do {
                let result = try context.fetch(request)
                
                if let entity = result.first {
                    entity.watch = movie.watch
                    entity.watched = movie.watched
                    
                    try context.save()
                }
            } catch {
                
            }
        }
    }
    
    func deleteMovieAsync(_ movie: Movie) {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movie.id)
        
        let context = CoreDataStack.shared.presistentContainer.newBackgroundContext()
        
        context.perform {
            
            do {
                let result = try context.fetch(request)
                
                if let entity = result.first {
                    context.delete(entity)
                    try context.save()
                }
            } catch {
                
            }
        }
    }
    
    func insertInitialMoviesIfNeeded() {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()

        let context = CoreDataStack.shared.presistentContainer.newBackgroundContext()
        context.perform {
            do {
                let count = try context.count(for: request)
                if count == 0 {  // Only insert if CoreData is empty
                    let initialMovies = [
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

                    for movie in initialMovies {
                        let entity = MovieEntity(context: context)
                        entity.id = Int64(movie.id)
                        entity.name = movie.name
                        entity.watched = movie.watched
                        entity.watch = movie.watch
                    }
                    
                    try context.save()
                }
            } catch {
                print("Failed to insert initial movies: \(error)")
            }
        }
    }

}
