//
//  ViewController.swift
//  myDevices
//
//  Created by synerzip on 09/10/15.
//  Copyright © 2015 synerzip. All rights reserved.
//

import UIKit
import CoreData

class DevicesTableViewController: UITableViewController {

//    var devices = [Devices]()
    var fetchedResultsController: NSFetchedResultsController!
//    var managedObjectContext:NSManagedObjectContext = {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        return appDelegate.managedObjectContext
//    }()
    var coreDataStack: CoreDataStack = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.coreDataStack
    }()
    var selectedPerson: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedPerson = selectedPerson {
            title = "\(selectedPerson.name)'s Devices"
        } else {
            title = "Devices"
            navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addDevice:"),
                                                  UIBarButtonItem(title: "Filter", style: .Plain, target: self, action: "selectFilter:")]
        }
        let fetchRequest = NSFetchRequest(entityName: "Devices")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "deviceType.name", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext, sectionNameKeyPath: "deviceType.name", cacheName: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func reloadData(predicate: NSPredicate? = nil) {
        
        if let selectedPerson = selectedPerson {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "owner == %@", selectedPerson)
//            if let personsDevices = selectedPerson.devices.allObjects as? [Devices] {
//                devices = personsDevices
//            }
        } else {
            fetchedResultsController.fetchRequest.predicate = predicate
//            let devicesFetchRequest = NSFetchRequest(entityName: "Devices")
//            devicesFetchRequest.sortDescriptors = [NSSortDescriptor(key: "deviceType", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
//            devicesFetchRequest.predicate = predicate
//            do {
//                if let results = try coreDataStack.managedObjectContext.executeFetchRequest(devicesFetchRequest) as? [Devices] {
//                    devices = results
//                }
//            } catch {
//                print("There was error")
//            }
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Unable to fetch")
        }
        tableView.reloadData()
    }
    
//    MARK: - Tableview datasource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return devices.count
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("deviceCell", forIndexPath: indexPath)
        
//        let device = devices[indexPath.row]
        let device = fetchedResultsController.objectAtIndexPath(indexPath) as! Devices
//        print(device.deviceDescription)
        cell.textLabel?.text = (device.deviceDescription)
        cell.detailTextLabel?.text = device.owner?.name ?? "no owner"
        if selectedPerson != nil {
            cell.userInteractionEnabled = false
        }
        return cell
    }
    
//    MARK: - Actions & segue
    func addDevice(sender: AnyObject?) {
        performSegueWithIdentifier("deviceDetail", sender: self)
    }
    
    func selectFilter(sender: AnyObject?) {
        let sheet = UIAlertController(title: "Filter Options", message: nil, preferredStyle: .ActionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (action) -> Void in
        }))
        sheet.addAction(UIAlertAction(title: "Show All", style: .Default, handler: {
            (action) -> Void in
            self.reloadData()
        }))
        sheet.addAction(UIAlertAction(title: "Only Owned Devices", style: .Default, handler: {
            (action) -> Void in
            self.reloadData(NSPredicate(format: "owner != nil"))
        }))
        sheet.addAction(UIAlertAction(title: "Only Phones", style: .Default, handler: {
            (action) -> Void in
            self.reloadData(NSPredicate(format: "deviceType.name =[c] 'iphone'"))
        }))
        sheet.addAction(UIAlertAction(title: "Only Watches", style: .Default, handler: {
            (action) -> Void in
            self.reloadData(NSPredicate(format: "deviceType.name =[c] 'watch'"))
        }))
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? DevicesDetailsViewController {
//            dest.coreDataStack = coreDataStack
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                let device = devices[selectedIndexPath.row]
                let device = fetchedResultsController.objectAtIndexPath(selectedIndexPath) as! Devices
                dest.device = device
            }
        }
    }
}

