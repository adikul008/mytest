//
//  ViewController.swift
//  AdaptiveImageDemo
//
//  Created by synerzip on 04/09/15.
//  Copyright (c) 2015 synerzip. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var imageTableView: UITableView!
    var imageArray = ["pano-1.jpg", "pano-2.jpg", "pano-3.jpg", "pano-4.jpg", "pano-5.jpg"]
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTableView.delegate = self
        imageTableView.dataSource = self
        navigationItem.title = "Panoramas"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("imageNameCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = imageArray[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        return cell
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ImageInfo") as! ImageInfoViewController
        vc.info = imageArray[indexPath.row]
        vc.popoverPresentationController?.sourceView = tableView
        vc.popoverPresentationController?.sourceRect = tableView.rectForRowAtIndexPath(indexPath)
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage" {
            let destViewController = segue.destinationViewController as! ContainerViewController
            let selectedIndex = imageTableView.indexPathForSelectedRow()!
            destViewController.imageName = imageArray[selectedIndex.row]
        }
    }
}

