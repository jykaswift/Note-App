//
//  CoreDataManager.swift
//  Notes
//
//  Created by Евгений Борисов on 28.01.2024.
//

import Foundation
import CoreData


/// Class responsible for working with coredate
class CoreDataManager {
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var backGroundContrext: NSManagedObjectContext =  {
        return persistentContainer.newBackgroundContext()
    }()
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        ValueTransformer.setValueTransformer(NSAttributedStringTransformer(), forName: NSValueTransformerName("NSAttributedStringTransformer"))
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// Saving the backgound context and merging it with the main context
    func saveBackgroundContex() async {
        await backGroundContrext.perform { [weak viewContext] in
            do {
                try self.backGroundContrext.save()
                
                do {
                    try viewContext?.save()
                } catch {
                    print("Error merging context: \(error)")
                }
                
            } catch {
                print("Error save background context: \(error)")
            }
        }
    }
    
    
    /// Retrieving saved data from the database
    /// - Returns: List of notes
    func obtainSavedData() -> [Note] {
        let notesFetchRequest = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        notesFetchRequest.sortDescriptors = [sortDescriptor]
        
        let result = try? viewContext.fetch(notesFetchRequest)
        
        return result ?? []
    }

}
