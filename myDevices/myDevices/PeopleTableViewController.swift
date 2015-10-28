//
//  PeopleTableViewController.swift
//  myDevices
//
//  Created by synerzip on 12/10/15.
//  Copyright © 2015 synerzip. All rights reserved.
//

import UIKit
import CoreData

protocol PersonPickerDelegate: class {
    func didSelectPerson(person: Person)
}

class PeopleTableViewController: UITableViewController {
    
    var people = [Person]()
//    var managedObjectContext:NSManagedObjectContext = {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        return appDelegate.managedObjectContext
//    }()
    var coreDataStack: CoreDataStack = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.coreDataStack
        }()
    weak var pickerDelegate: PersonPickerDelegate?
    var selectedPerson: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "People"
        if pickerDelegate == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPerson:")
        }
        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func reloadData() {
        let personFetchRequest = NSFetchRequest(entityName: "Person")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        personFetchRequest.sortDescriptors = [sortDescriptor]
        do {
            if let results = try coreDataStack.managedObjectContext.executeFetchRequest(personFetchRequest) as? [Person] {
                people = results
            }
        } catch {
            print("There was error")
        }
        tableView.reloadData()
    }
    
//MARK: - Tableview datasource methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("personCell", forIndexPath: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = person.name
        
        if let selectedPerson = selectedPerson where selectedPerson == person {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let pickerDelegate = pickerDelegate {
            let person = people[indexPath.row]
            selectedPerson = person
            pickerDelegate.didSelectPerson(person)
            
            tableView.reloadData()
        } else {
            if let deviceTableViewController = storyboard?.instantiateViewControllerWithIdentifier("Devices") as? DevicesTableViewController {
                let person = people[indexPath.row]
                deviceTableViewController.selectedPerson = person
                navigationController?.pushViewController(deviceTableViewController, animated: true)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return pickerDelegate == nil
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let person = people[indexPath.row]
            coreDataStack.managedObjectContext.deleteObject(person)
            reloadData()
        }
        
    }
    
//    MARK: - segue methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? DevicesTableViewController {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let person = people[selectedIndexPath.row]
                dest.selectedPerson = person
            }
        }
    }
    
//    MARK: - add person
    func addPerson(sender: AnyObject?) {
        let alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as UITextField
            self.saveName(textField.text!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in }
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveName(name: String) {
        if name != "" {
            guard let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: coreDataStack.managedObjectContext) else {
                fatalError("Could not find entity description")
            }
            
            let person = Person(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
            person.name = name
            do {
                try coreDataStack.managedObjectContext.save()
            } catch {
                coreDataStack.managedObjectContext.deleteObject(person)
                let alert = UIAlertController(title: "Error", message: "A person's name must be stronger than single character!", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            reloadData()
        }
//        reloadData()
        tableView.reloadData()
    }
}