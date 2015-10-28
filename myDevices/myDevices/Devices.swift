//
//  Devices.swift
//  myDevices
//
//  Created by synerzip on 09/10/15.
//  Copyright © 2015 synerzip. All rights reserved.
//

import Foundation
import CoreData

class Devices: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    var deviceDescription: String {
        if let deviceType = deviceType {
        return "\(name) (\(deviceType.name))"
    } else {
        return "\(name)"
        }
    }
}
