//
//  CoreDataController.swift
//  What I See
//
//  Created by ibrahim al-khatib on 3/19/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import CoreData

class CoreDataController {

    static let sharedController = CoreDataController(modelName: "DataModel")!

    private let model: NSManagedObjectModel
    private let coordinator: NSPersistentStoreCoordinator
    private let modelURL: URL
    private let dbURL: URL
    let context: NSManagedObjectContext
    
    init?(modelName: String) {
        
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print("Unable to find \(modelName)")
            return nil
        }
        
        self.modelURL = modelURL
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            print("Unable to create a model from \(modelURL)")
            return nil
        }
        
        self.model = model
        
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .allDomainsMask).last else {
            print("Unable to reach document folder")
            return nil
        }
        
        let dbURL = documentURL.appendingPathComponent("DataModel.sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
        } catch {
            print("Unable to add store at \(dbURL)")
        }
        self.dbURL = dbURL
        
    }

    
    
    func dropAllData() throws {
        try coordinator.destroyPersistentStore(at: dbURL, ofType: NSSQLiteStoreType, options: nil)
    }
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    func deleteAllRecognizedUsers() {
        let fetch = NSFetchRequest<DBRecognizedUser>(entityName: "RecognizedUser")
        
        do {
            let recognizedUsers = try context.fetch(fetch)
            for recognizedUser in recognizedUsers {
                context.delete(recognizedUser)
            }
            
            try saveContext()
        } catch {
            
        }
    }
    
    func addRecognizedUser(model: RecognizedUserModel) {
        let recognizedUser = NSEntityDescription.insertNewObject(forEntityName: "RecognizedUser", into: context) as! DBRecognizedUser
        recognizedUser.name = model.name
        do {
            try saveContext()
        } catch  {
            
        }
    }
    
    func addRecognizedUsers(models: [RecognizedUserModel]) {
        for model in models {
            addRecognizedUser(model: model)
        }
    }

    
    func getRecognizedUsers() -> [RecognizedUserModel]? {
        let fetch = NSFetchRequest<DBRecognizedUser>(entityName: "RecognizedUser")
        fetch.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        do {
            let recognizedUsers = try context.fetch(fetch) 
            var models = [RecognizedUserModel]()
            
            for recognizedUser in recognizedUsers {
                let model = RecognizedUserModel()
                model.name = recognizedUser.name
                models.append(model)
            }

            return models
        } catch {
            return nil
        }
    }
}

