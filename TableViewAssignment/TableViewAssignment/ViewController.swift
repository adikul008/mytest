//
//  ViewController.swift
//  TableViewAssignment
//
//  Created by synerzip on 21/08/15.
//  Copyright (c) 2015 synerzip. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var appsArray = [[String: String]]()
    var imageCache = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerClass(AppCell.self, forCellReuseIdentifier: "AppCell")
        tableView.registerNib(UINib(nibName: "AppCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "AppCell")
        getDataFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromServer() {
        let urlPath: String = "https://itunes.apple.com/us/rss/topfreeapplications/limit=100/genre=6014/json"
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse? >= nil
        var error: NSErrorPointer = nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request1, returningResponse: response, error:nil)!
        self.parseJSON(dataVal)
    }
    
    func parseJSON(jsonData : NSData)
    {
        let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments, error:nil)
        
        if let topApps = parsedObject as? NSDictionary {
            if let feed = topApps["feed"] as? NSDictionary {
                if let apps = feed["entry"] as? NSArray {
                    for app in apps {
                        var appInfo = [String:String]()
                        if let imname = app["im:name"] as? NSDictionary {
                            if let appName = imname["label"] as? NSString {
                                appInfo.updateValue((appName as? String)!, forKey: "name")
                            }
                        }
                        if let imimage = app["im:image"] as? NSArray {
                            if let appLogoDict = imimage[0] as? NSDictionary {
                                if let appLogoURL = appLogoDict["label"] as? NSString {
                                    appInfo.updateValue((appLogoURL as? String)!, forKey: "logo")
                                }
                            }
                        }
                        if let imimage = app["im:image"] as? NSArray {
                            if let appLogoDict = imimage[2] as? NSDictionary {
                                if let appLogoURL = appLogoDict["label"] as? NSString {
                                    appInfo.updateValue((appLogoURL as? String)!, forKey: "icon")
                                }
                            }
                        }
                        if let imname = app["im:artist"] as? NSDictionary {
                            if let appName = imname["label"] as? NSString {
                                appInfo.updateValue((appName as? String)!, forKey: "author")
                            }
                        }
                        if let imname = app["summary"] as? NSDictionary {
                            if let appName = imname["label"] as? NSString {
                                appInfo.updateValue((appName as? String)!, forKey: "summary")
                            }
                        }
                        appsArray.append(appInfo)
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: AppCell = tableView.dequeueReusableCellWithIdentifier("AppCell", forIndexPath: indexPath) as! AppCell

        let appInfoDict = appsArray[indexPath.row]
        cell.configureCellWithData(appInfoDict)
        return cell
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cellsArray = tableView.indexPathsForVisibleRows() as? [NSIndexPath] {
            let found = find(cellsArray, indexPath)
            if found == nil {
                var appCell = tableView.cellForRowAtIndexPath(indexPath) as! AppCell
                appCell.cancelInvisibleCellRequest()
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "showDetails") {
            let detailsViewController = segue.destinationViewController as! DetailsViewController
            let selectedCellIndex = tableView.indexPathForSelectedRow()
            let appInfo = appsArray[selectedCellIndex!.row] as NSDictionary
            detailsViewController.appInfoDict = appInfo
        }
        
    }
}

