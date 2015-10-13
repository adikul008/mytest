//
//  Person+CoreDataProperties.swift
//  myDevices
//
//  Created by synerzip on 12/10/15.
//  Copyright © 2015 synerzip. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var name: String
    @NSManaged var devices: NSSet

}
