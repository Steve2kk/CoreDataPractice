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
    
    func fetchChallenges() -> [Challenge] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Challenge>(entityName: "Challenge")
        do {
            let challenges = try context.fetch(fetchRequest)
            return challenges
        } catch let fetchErr {
            print("Failed to fetch:",fetchErr)
            return []
        }
    }
}
