//
//  DetailsViewController.swift
//  TableViewAssignment
//
//  Created by synerzip on 25/08/15.
//  Copyright (c) 2015 synerzip. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var appDescriptionTextView: UITextView!
    
    var appInfoDict: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageURL = NSURL(string: (appInfoDict.valueForKey("icon") as? String)!)
        appImageView.image = UIImage(data: NSData(contentsOfURL: imageURL!)!)
        nameLabel.text = appInfoDict.valueForKey("name") as? String
        var artist = "Artist : "
        var artistName = appInfoDict.valueForKey("author") as? String
        authorNameLabel.text = artist + artistName!
        appDescriptionTextView.text = appInfoDict.valueForKey("summary") as? String
        navigationItem.title = nameLabel.text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}