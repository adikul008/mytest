//
//  Devices+CoreDataProperties.swift
//  myDevices
//
//  Created by synerzip on 20/10/15.
//  Copyright © 2015 synerzip. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import UIKit
import CoreData

extension Devices {

    @NSManaged var deviceType: DeviceType?
    @NSManaged var name: String
    @NSManaged var deviceID: String?
    @NSManaged var purchaseDate: NSDate?
    @NSManaged var owner: Person?
    @NSManaged var image: UIImage?
}
