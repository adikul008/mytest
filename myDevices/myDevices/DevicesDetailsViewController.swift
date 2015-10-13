//
//  DevicesDetailsViewController.swift
//  myDevices
//
//  Created by synerzip on 09/10/15.
//  Copyright © 2015 synerzip. All rights reserved.
//

import UIKit
import CoreData

class DevicesDetailsViewController: UITableViewController {
    
    @IBOutlet weak var deviceName: UITextField!
    @IBOutlet weak var deviceType: UITextField!
    @IBOutlet weak var deviceOwner: UILabel!
    
    var managedObjectContext:NSManagedObjectContext!
    var device:Devices!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let device = device {
            deviceName.text = device.name
            deviceType.text = device.deviceType
            title = device.name
            if let owner = device.owner {
                deviceOwner.text = owner.name
            } else {
                deviceOwner.text = "Set Device Owner"
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        // need to add a device?
        if let device = device, name = deviceName.text, type = deviceType.text {
            device.name = name
            device.deviceType = type
        } else if device == nil {
            if (deviceType.text != "" && deviceName != "") {
                guard let entity = NSEntityDescription.entityForName("Devices", inManagedObjectContext: managedObjectContext) else {
                    fatalError("Could not find entity description")
                }
                
                let device = Devices(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
                device.name = deviceName.text!
                device.deviceType = deviceType.text!
                
            }
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving device !!!")
        }
    }
    
//    MARK: - Tableview delegate & datasource
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1 && indexPath.row == 0) && device != nil {
            if let personPicker = storyboard?.instantiateViewControllerWithIdentifier("People") as? PeopleTableViewController {
                
                // more personPicker setup code here
                personPicker.pickerDelegate = self
                personPicker.selectedPerson = device?.owner
                navigationController?.pushViewController(personPicker, animated: true)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

extension DevicesDetailsViewController:PersonPickerDelegate {
    func didSelectPerson(person: Person) {
        device?.owner = person
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving the managed object context!")
        }
    }
}



