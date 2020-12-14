//
//  CoreDataManager.swift
//  CoreDataTraining
//
//  Created by Vsevolod Shelaiev on 08.12.2020.
//

import CoreData
struct CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer:NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModels")
        container.loadPersistentStores { (storeDesription, err) in
            if let err = err {
                fatalError("Failed loading of store \(err)")
            }
        }
        return container
    }()
}
