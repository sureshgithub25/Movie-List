//
//  CoreDataStack.swift
//  MovieList
//
//  Created by Suresh Kumar on 19/02/25.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var presistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieList")
        
        container.loadPersistentStores { _, error in
            
            if let error = error {
                fatalError("failed to load presistent stores: \(error.localizedDescription)")
            }
             
        }
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return presistentContainer.viewContext
    }()
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("context could not be saved")
        }
    }
}
