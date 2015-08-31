//
//  AppCell.swift
//  TableViewAssignment
//
//  Created by synerzip on 24/08/15.
//  Copyright (c) 2015 synerzip. All rights reserved.
//

import Foundation
import UIKit

class AppCell: UITableViewCell, NSURLConnectionDelegate {
    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var imageData:NSMutableData?
    var connectionToServer: NSURLConnection?
    var appName = ""
    
    func configureCellWithData(data: Dictionary<String, String>) {
        appName = data["name"]!
        let appIconURL = data["logo"]!
        nameLabel.text = appName
        
        let imgURL = NSURL(string: appIconURL)
        let request = NSURLRequest(URL: imgURL!)
        connectionToServer = NSURLConnection(request: request, delegate: self)
        imageData = NSMutableData()
        appIcon.image = nil
    
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        imageData?.length = 0
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        imageData?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if imageData == nil {
            return
        }
        let image = UIImage(data: imageData!)
        print(appName)
        println(image)
        
        appIcon.image = image
    }
    
    func cancelInvisibleCellRequest() {
        connectionToServer?.cancel()
        connectionToServer = nil
    }
}