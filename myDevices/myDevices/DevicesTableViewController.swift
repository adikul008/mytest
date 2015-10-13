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

    var devices = [Devices]()
    var managedObjectContext:NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
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
        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func reloadData(predicate: NSPredicate? = nil) {
        
        if let selectedPerson = selectedPerson {
            if let personsDevices = selectedPerson.devices.allObjects as? [Devices] {
                devices = personsDevices
            }
        } else {
            let devicesFetchRequest = NSFetchRequest(entityName: "Devices")
            devicesFetchRequest.sortDescriptors = [NSSortDescriptor(key: "deviceType", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
            devicesFetchRequest.predicate = predicate
            do {
                if let results = try managedObjectContext.executeFetchRequest(devicesFetchRequest) as? [Devices] {
                    devices = results
                }
            } catch {
                print("There was error")
            }
        }
        tableView.reloadData()
    }
    
//    MARK: - Tableview datasource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("deviceCell", forIndexPath: indexPath)
        let device = devices[indexPath.row]
        cell.textLabel?.text = (device.name)
        cell.detailTextLabel?.text = device.owner?.name
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
            self.reloadData(NSPredicate(format: "deviceType =[c] 'iphone'"))
        }))
        sheet.addAction(UIAlertAction(title: "Only Watches", style: .Default, handler: {
            (action) -> Void in
            self.reloadData(NSPredicate(format: "deviceType =[c] 'watch'"))
        }))
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? DevicesDetailsViewController {
            dest.managedObjectContext = managedObjectContext
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let device = devices[selectedIndexPath.row]
                dest.device = device
            }
        }
    }
}

