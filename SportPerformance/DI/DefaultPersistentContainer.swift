//
//  DefaultPersistentContainer.swift
//  SportPerformance
//
//  Created by Ivan Fabri on 27/07/2025.
//

import CoreData

final class DefaultPersistentContainer: PersistentContainerProtocol {
    private let container: NSPersistentContainer

    init(name: String) {
        container = NSPersistentContainer(name: name)
    }

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    func loadPersistentStores(completion: @escaping (NSPersistentStoreDescription, Error?) -> Void) {
        container.loadPersistentStores(completionHandler: completion)
    }
}
