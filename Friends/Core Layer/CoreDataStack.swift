//
//  CoreDataStack.swift
//  Friends
//
//  Created by Mary Milchenko on 20.03.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()

    var storeUrl: URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentUrl.appendingPathComponent("MyStore.sqlite")
    }

    let dataModelName = "DataModel"
    let dataModelExtension = "momd"

    enum StrorageManagerContext {
        case master
        case main
        case save
    }

    private var _managedObjectModel: NSManagedObjectModel?
    private var managedObjectModel: NSManagedObjectModel? {
        if _managedObjectModel == nil {
            guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension)
                else {
                    print("Model url is empty")
                    return nil
                }
                _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            }
        return _managedObjectModel
    }

    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        if _persistentStoreCoordinator == nil {
            guard let model = self.managedObjectModel
            else {
                print("Managed object model is empty")
                return nil
            }

            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

            do {
                try _persistentStoreCoordinator?.addPersistentStore(
                                    ofType: NSSQLiteStoreType,
                                    configurationName: nil,
                                    at: self.storeUrl,
                                    options: nil)
            } catch {
                assert(false, "Error adding persistent store to coordinator: \(error)")
            }
        }
        return _persistentStoreCoordinator
    }

    private var _masterContext: NSManagedObjectContext?
    private var masterContext: NSManagedObjectContext? {
        if _masterContext == nil {
            guard let persistentStoreCoordinator = self.persistentStoreCoordinator else {
                print("Empty persistent store coordinator")
                return nil
            }
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = persistentStoreCoordinator
            context.mergePolicy = NSOverwriteMergePolicy
            _masterContext = context
        }

        return _masterContext
    }

    private var _mainContext: NSManagedObjectContext?
    private var mainContext: NSManagedObjectContext? {
        if _mainContext == nil {
            guard let parentContext = self.masterContext else {
                print("No master context!")
                return nil
            }

            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.parent = parentContext
            context.mergePolicy = NSOverwriteMergePolicy
            _mainContext = context
        }

            return _mainContext
    }

    private var _saveContext: NSManagedObjectContext?
    private var saveContext: NSManagedObjectContext? {
        if _saveContext == nil {
            guard let parentContext = self.mainContext else {
                print("No master context!")
                return nil
            }

            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = parentContext
            context.mergePolicy = NSOverwriteMergePolicy
            _saveContext = context
        }

        return _saveContext
    }

    public func perfomSave(context: NSManagedObjectContext, completionHandler: (() -> Void)?) {
        context.perform {
            if context.hasChanges {
                context.perform { [weak self] in
                    do {
                        try context.save()
                    } catch {
                        print("Context save error: \(error)")
                    }

                    if let parent = context.parent {
                        self?.perfomSave(context: parent, completionHandler: completionHandler)
                    } else {
                        completionHandler?()
                    }
                }
            } else {
                completionHandler?()
            }
        }
    }

    public func getContext(_ type: StrorageManagerContext) -> NSManagedObjectContext? {
        switch type {
        case .main:
            return mainContext
        case .master:
            return masterContext
        case .save:
            return saveContext
        }
    }

}

extension User {
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        let templateName = "AppUser"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        return fetchRequest
    }

    static func fetchRequestAppUser() -> NSFetchRequest<User> {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")

        return fetchRequest
    }

    static func insertUserData(in context: NSManagedObjectContext) -> User? {
        guard let userData = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
            else { return nil }

        return userData
    }

    static func findUserData(in context: NSManagedObjectContext) -> User? {
        let fetchRequest = User.fetchRequestAppUser()
        var userData: User?
        context.performAndWait {
            do {
                let results = try context.fetch(fetchRequest)
                assert(results.count < 2, "Multiple User found")
                if let foundData = results.first {
                    userData = foundData
                }
            } catch {
                print("Failed to fetch User: \(error)")
            }
        }
        context.performAndWait {
            if userData == nil {
                userData = User.insertUserData(in: context)
            }
        }
        return userData
    }

}

extension CDConversation {

}

extension CDMessage {

}
