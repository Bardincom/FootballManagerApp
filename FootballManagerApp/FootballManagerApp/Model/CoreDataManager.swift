//
//  CoreDataManager.swift
//  FootballManagerApp
//
//  Created by Aleksey Bardin on 13.08.2020.
//  Copyright © 2020 Aleksey Bardin. All rights reserved.
//

import CoreData

extension CoreDataManager {
    static let shared = CoreDataManager(modelName: Model.name)
}

final class CoreDataManager {
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)

        container.loadPersistentStores { (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError()
            }
        }
        return container
    }()

    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func save() {
        guard getContext().hasChanges else { return }

        do {
            try getContext().save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func save(context: NSManagedObjectContext) {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func createObject<T: NSManagedObject>(from entity: T.Type) -> T {
        let context = getContext()
        let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: entity), into: context) as! T
        return object
    }

    func delete(object: NSManagedObject) {
        let context = getContext()
        context.delete(object)
        save(context: context)
    }

    func fetchData<T: NSManagedObject>(for entity: T.Type,
                                       selectionNameKeyPath: String? = nil,
                                       predicate: NSCompoundPredicate? = nil) -> NSFetchedResultsController<T> {
        let context = getContext()
        
        let request: NSFetchRequest<T>

        request = entity.fetchRequest() as! NSFetchRequest<T>

        let sortDescriptor = NSSortDescriptor(key: #keyPath(Player.position),
                                              ascending: true)

        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]

        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: selectionNameKeyPath,
                                                    cacheName: nil)

        do {
            try controller.performFetch()
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }

        return controller
    }
}
