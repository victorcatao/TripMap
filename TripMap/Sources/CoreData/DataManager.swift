//
//  DataManager.swift
//  TripMap
//
//  Created by Victor Catão on 03/01/23.
//

import CoreData

final class DataManager {
    
    private init() {}
    
    static let shared = DataManager()
    
    lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "TripMap")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()

    /// Core Data Saving support
    func save () {
        let context = context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
