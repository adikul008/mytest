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
    var coreDataStack: CoreDataStack = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.coreDataStack
        }()
    var device:Devices!
    
    @IBOutlet weak var deviceName: UITextField!
    @IBOutlet weak var deviceType: UITextField!
    @IBOutlet weak var deviceOwner: UILabel!
    @IBOutlet weak var deviceID: UITextField!
    @IBOutlet weak var devicePurchaseDate: UITextField!
    @IBOutlet weak var deviceImage: UIImageView!
    
    private let datePicker = UIDatePicker()
    private var selectedDate: NSDate?
    private lazy var dateFormatter: NSDateFormatter = {
        let df = NSDateFormatter()
        df.timeStyle = .NoStyle
        df.dateStyle = .MediumStyle
        return df
    }()
    
    private let deviceTypePicker = UIPickerView()
    private var deviceTypes = [DeviceType]()
    private var selectedDeviceType: DeviceType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: .ValueChanged)
        datePicker.datePickerMode = .Date
        devicePurchaseDate.inputView = datePicker
        devicePurchaseDate.delegate = self
        
        loadDeviceTypes()
        deviceTypePicker.delegate = self
        deviceTypePicker.dataSource = self
        deviceType.inputView = deviceTypePicker
    }
    
    func loadDeviceTypes() {
        let fetchRequest = NSFetchRequest(entityName: "DeviceType")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        do {
            if let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [DeviceType] {
                deviceTypes = results
            }
        } catch {
            fatalError("There was an error fetching the list of device types!")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let device = device {
            deviceName.text = device.name
            deviceType.text = device.deviceType?.name
            deviceID.text = device.deviceID
            deviceImage.image = device.image
            title = device.name
            if let owner = device.owner {
                deviceOwner.text = owner.name
            } else {
                deviceOwner.text = "Set Device Owner"
            }
            
            if let deviceType = device.deviceType {
                selectedDeviceType = deviceType
                
                for (index, oneDeviceType) in deviceTypes.enumerate() {
                    if deviceType == oneDeviceType {
                        deviceTypePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                }
            }

            if let purchaseDate = device.purchaseDate {
                selectedDate = purchaseDate
                datePicker.date = purchaseDate
                devicePurchaseDate.text = dateFormatter.stringFromDate(purchaseDate)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        // need to add a device?
        if let device = device, name = deviceName.text, type = deviceType.text {
            device.name = name
            device.deviceType = selectedDeviceType
            device.deviceID = deviceID.text
            device.purchaseDate = selectedDate
            device.image = deviceImage.image
        } else if device == nil {
            if (deviceType.text != "" && deviceName != "") {
                guard let entity = NSEntityDescription.entityForName("Devices", inManagedObjectContext: coreDataStack.managedObjectContext) else {
                    fatalError("Could not find entity description")
                }
                
                let device = Devices(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
                device.name = deviceName.text!
                device.deviceType = selectedDeviceType
                device.deviceID = deviceID.text
                device.purchaseDate = selectedDate
                device.image = deviceImage.image
            }
        }
        let startTime = CFAbsoluteTimeGetCurrent()
        coreDataStack.saveMainContext()
        let endTime = CFAbsoluteTimeGetCurrent()
        let elapsedTime = (endTime - startTime) * 1000
        print("Elapsed time = \(elapsedTime) ms")
    }
    
//    MARK: - Tableview delegate & datasource
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1 && indexPath.row == 0) && device != nil {
            if let personPicker = storyboard?.instantiateViewControllerWithIdentifier("People") as? PeopleTableViewController {
                
                // more personPicker setup code here
//                personPicker.coreDataStack = coreDataStack
                personPicker.pickerDelegate = self
                personPicker.selectedPerson = device?.owner
                navigationController?.pushViewController(personPicker, animated: true)
            }
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            let sheet = UIAlertController(title: "Device Image", message: nil, preferredStyle: .ActionSheet)
            sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            if (deviceImage.image != nil) {
                sheet.addAction(UIAlertAction(title: "Remove Current Image", style: .Destructive, handler: {
                    (action) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.deviceImage.image = nil
                    }
                }))
            }
            
            sheet.addAction(UIAlertAction(title: "Select Image from Library", style: .Default, handler: {
                (action) -> Void in
                let picker = UIImagePickerController()
                picker.sourceType = .PhotoLibrary
                picker.delegate = self
                self.presentViewController(picker, animated: true, completion: nil)
            }))
            presentViewController(sheet, animated: true, completion: nil)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func datePickerValueChanged(datePicker: UIDatePicker) {
        devicePurchaseDate.text = dateFormatter.stringFromDate(datePicker.date)
        selectedDate = dateFormatter.dateFromString(devicePurchaseDate.text!)
    }
}

//MARK: - Pickerview Datasource and delegate

extension DevicesDetailsViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return deviceTypes[row].name
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDeviceType = deviceTypes[row]
        deviceType.text = selectedDeviceType?.name
    }
}

extension DevicesDetailsViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return deviceTypes.count
    }
}

//MARK: - person pickerview delegate

extension DevicesDetailsViewController: PersonPickerDelegate {
    func didSelectPerson(person: Person) {
        device?.owner = person
        coreDataStack.saveMainContext()
    }
}

//MARK: - Textfield delegate

extension DevicesDetailsViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        devicePurchaseDate.resignFirstResponder()
        return true
    }
}

//MARK: - ImagePicker delegate

extension DevicesDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dispatch_async(dispatch_get_main_queue()) {
            self.deviceImage.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}


