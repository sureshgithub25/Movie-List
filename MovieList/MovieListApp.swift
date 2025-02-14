//
//  MovieListApp.swift
//  MovieList
//
//  Created by Suresh Kumar on 14/02/25.
//

import SwiftUI

@main
struct MovieListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
