//
//  ContainerViewController.swift
//  AdaptiveImageDemo
//
//  Created by synerzip on 04/09/15.
//  Copyright (c) 2015 synerzip. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = imageName
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage" {
            let destViewController = segue.destinationViewController as! ImageScrollViewController
            destViewController.imageName = imageName
            destViewController.navItem = self.navigationItem
        }
    }

}
