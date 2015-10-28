//
//  DebugViewController.swift
//  myDevices
//
//  Created by synerzip on 13/10/15.
//  Copyright © 2015 synerzip. All rights reserved.
//

import UIKit
import CoreData

class DebugViewController: UIViewController {
    
    @IBOutlet weak var exportDataButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    var managedObjectContext:NSManagedObjectContext = {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        return appDelegate.managedObjectContext
//        }()
    var coreDataStack: CoreDataStack = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.coreDataStack
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func exortAction(sender: AnyObject) {
        
        activityIndicator.startAnimating()
        exportDataButton.enabled = false
        
        let childManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        childManagedObjectContext.parentContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Devices")
        childManagedObjectContext.performBlock() {
            do {
                if let results = try self.coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [Devices] {
                    for device in results {
                        print("\(device.name) \(device.deviceType?.name)")
                    }
                }
            } catch {
                print("Error fetching records for export")
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                self.exportDataButton.enabled = true
            }
        }
    }
    
    @IBAction func unAssignAllAction(sender: AnyObject) {
        let fetchRequest = NSFetchRequest(entityName: "Devices")
        fetchRequest.predicate = NSPredicate(format: "owner != nil")
        
        do {
            if let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [Devices] {
                for device in results {
                    device.owner = nil
                }
                
                try coreDataStack.managedObjectContext.save()
                
                let alert = UIAlertController(title: "Batch Update Succeeded", message: "\(results.count) devices unassigned.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
        } catch {
            let alert = UIAlertController(title: "Batch Update Failed", message: "There was an error unassigning the devices.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteAllAction(sender: AnyObject) {

        let deviceFetchRequest = NSFetchRequest()
        deviceFetchRequest.entity = NSEntityDescription.entityForName("Devices", inManagedObjectContext: coreDataStack.managedObjectContext)
        deviceFetchRequest.includesPropertyValues = false
        
        let personFetchRequest = NSFetchRequest()
        personFetchRequest.entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: coreDataStack.managedObjectContext)
        personFetchRequest.includesPropertyValues = false
        
        let deviceTypeFetchRequest = NSFetchRequest()
        deviceTypeFetchRequest.entity = NSEntityDescription.entityForName("DeviceType", inManagedObjectContext: coreDataStack.managedObjectContext)
        deviceTypeFetchRequest.includesPropertyValues = false
        
        do {
        
            if let deviceResults = try coreDataStack.managedObjectContext.executeFetchRequest(deviceFetchRequest) as? [NSManagedObject], let personResults = try coreDataStack.managedObjectContext.executeFetchRequest(personFetchRequest) as? [NSManagedObject], let deviceTypeResults = try coreDataStack.managedObjectContext.executeFetchRequest(deviceTypeFetchRequest) as? [NSManagedObject] {
                
                for result in deviceResults {
                    coreDataStack.managedObjectContext.deleteObject(result)
                }
                for result in personResults {
                    coreDataStack.managedObjectContext.deleteObject(result)
                }
                for result in deviceTypeResults {
                    coreDataStack.managedObjectContext.deleteObject(result)
                }
                try coreDataStack.managedObjectContext.save()
                let alert = UIAlertController(title: "Batch Delete Succeeded", message: "\(deviceResults.count) device records, \(personResults.count) person records and \(deviceTypeResults.count) device type records deleted.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
        } catch {
            let alert = UIAlertController(title: "Batch Delete Failed", message: "There was an error with the batch delete.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }
}
