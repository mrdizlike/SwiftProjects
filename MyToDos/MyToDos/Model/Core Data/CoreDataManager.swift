//
//  CoreDataManager.swift
//  MyToDos
//
//  Created by Виктор on 08.04.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func saveContext() {
        saveContext(mainContext)
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        if context.parent == mainContext {
            saveDerivedContext(context)
            return
        }
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func saveDerivedContext(_ context: NSManagedObjectContext) {
        context.perform { [self] in
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Error: \(error.localizedDescription)")
            }
            
            saveContext(mainContext)
        }
    }
}

protocol EntityModelMapProtocol {
    associatedtype EntityType: NSManagedObject
    func mapToEntityInContext(_ context: NSManagedObjectContext) -> EntityType
    static func mapFromEntity(_ entity: EntityType) -> Self
}
