//
//  CoreDataStack.swift
//  myDevices
//
//  Created by synerzip on 13/10/15.
//  Copyright © 2015 synerzip. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {
    static let moduleName = "myDevices"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let persistentStoreURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(moduleName).sqlite")
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType,
                configuration: nil,
                URL: persistentStoreURL,
                options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: false])
        } catch {
            fatalError("persistent store error! \(error)")
        }
        return coordinator
    }()
    
    private lazy var saveManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.parentContext = self.saveManagedObjectContext
        return managedObjectContext
    }()
    
    func saveMainContext() {
        
        guard managedObjectContext.hasChanges || saveManagedObjectContext.hasChanges else {
            return
        }
        managedObjectContext.performBlockAndWait() {
            do {
                try self.managedObjectContext.save()
            } catch {
                fatalError("Error saving main managed object context! \(error)")
            }
        }
        saveManagedObjectContext.performBlock() {
            do {
                try self.saveManagedObjectContext.save()
            } catch {
                fatalError("Error saving main managed object context! \(error)")
            }
        }
    }
}
