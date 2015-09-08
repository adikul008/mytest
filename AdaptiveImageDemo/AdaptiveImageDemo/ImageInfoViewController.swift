//
//  ImageInfoViewController.swift
//  AdaptiveImageDemo
//
//  Created by synerzip on 08/09/15.
//  Copyright (c) 2015 synerzip. All rights reserved.
//

import UIKit

class ImageInfoViewController: UIViewController {
    
    var info = ""
    @IBOutlet weak var infoText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = .Popover
        popoverPresentationController?.delegate = self
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        infoText.text = info
        navigationItem.title = info

    }

    func dismissModal() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ImageInfoViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
        return .None
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        if adaptivePresentationStyleForPresentationController(controller, traitCollection: UITraitCollection()) == .None {
            return nil
        }
        
        let nav = UINavigationController(rootViewController: controller.presentedViewController)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissModal")
        controller.presentedViewController.navigationItem.leftBarButtonItem = doneButton
        return nav
        
    }
}