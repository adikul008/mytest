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
    
    var managedObjectContext:NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func unAssignAllAction(sender: AnyObject) {
        let fetchRequest = NSFetchRequest(entityName: "Devices")
        fetchRequest.predicate = NSPredicate(format: "owner != nil")
        
        do {
            if let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Devices] {
                for device in results {
                    device.owner = nil
                }
                
                try managedObjectContext.save()
                
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
                let deviceFetchRequest = NSFetchRequest(entityName: "Devices")
                let deviceDeleteRequest = NSBatchDeleteRequest(fetchRequest: deviceFetchRequest)
                deviceDeleteRequest.resultType = .ResultTypeCount
                
                let personFetchRequest = NSFetchRequest(entityName: "Person")
                let personDeleteRequest = NSBatchDeleteRequest(fetchRequest: personFetchRequest)
                personDeleteRequest.resultType = .ResultTypeCount
                do {
                    let deviceResult = try managedObjectContext.executeRequest(deviceDeleteRequest) as! NSBatchDeleteResult
                    let personResult = try managedObjectContext.executeRequest(personDeleteRequest) as! NSBatchDeleteResult
                    
                    let alert = UIAlertController(title: "Batch Delete Succeeded", message: "\(deviceResult.result!) device records and \(personResult.result!) person records deleted.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                } catch {
                    let alert = UIAlertController(title: "Batch Delete Failed", message: "There was an error with the batch delete.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }
    }
    
}
