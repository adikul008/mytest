//
//  AppDelegate.swift
//  myDevices
//
//  Created by synerzip on 09/10/15.
//  Copyright © 2015 synerzip. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()

    func addTestData() {
        
        guard let personEntity = NSEntityDescription.entityForName("Person", inManagedObjectContext: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity description")
        }
        
        let bob = Person(entity: personEntity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        bob.name = "Bob"
        let jane = Person(entity: personEntity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        jane.name = "Jane"
        
        guard let deviceTypeEntity = NSEntityDescription.entityForName("DeviceType", inManagedObjectContext: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity description")
        }
        let phoneDeviceType = DeviceType(entity: deviceTypeEntity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        phoneDeviceType.name = "iPhone"
        let watchDeviceType = DeviceType(entity: deviceTypeEntity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        watchDeviceType.name = "Watch"

        guard let deviceEntity = NSEntityDescription.entityForName("Devices", inManagedObjectContext: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity description")
        }
        
        for i in 1...75000 {
            let device = Devices(entity: deviceEntity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
            device.deviceType = i % 3 == 0 ? watchDeviceType : phoneDeviceType
            device.name = "Some Device #\(i)"
            
        }
        
                coreDataStack.saveMainContext()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let fetchRequest = NSFetchRequest(entityName: "Devices")
        
        do {
            let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest)
            if results.count == 0 {
                addTestData()
            }
        } catch {
            fatalError("Error fetching data!")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataStack.saveMainContext()
    }

}

