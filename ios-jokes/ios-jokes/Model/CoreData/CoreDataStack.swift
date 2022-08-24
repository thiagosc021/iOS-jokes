//
//  CoreDataStack.swift
//  Tasks-CoreData
//
//  Created by Thiago Costa on 5/13/22.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ios_jokes")
        container.loadPersistentStores { _,error in
            if let error = error {
                fatalError("Error loading persistent stores: \(error)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { container.viewContext }
    
    static func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
