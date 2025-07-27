//
//  PersistentContainerProtocol.swift
//  SportPerformance
//
//  Created by Ivan Fabri on 27/07/2025.
//

import CoreData

protocol PersistentContainerProtocol {
    var viewContext: NSManagedObjectContext { get }
    func loadPersistentStores(completion: @escaping (NSPersistentStoreDescription, Error?) -> Void)
}
