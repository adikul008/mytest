//
//  ImageScrollViewController.swift
//  AdaptiveImageDemo
//
//  Created by synerzip on 04/09/15.
//  Copyright (c) 2015 synerzip. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView?
    var toggleButton: UIBarButtonItem?
    var imageName = ""
    var navItem: UINavigationItem?
    var toggled:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView()
        scrollView.addSubview(imageView!)
        scrollView.delegate = self
        toggleButton = UIBarButtonItem(title: "Toggle", style: UIBarButtonItemStyle.Plain, target: self, action: "toggleAction:")
        navItem!.setRightBarButtonItem(toggleButton, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if imageView?.image == nil {
            if let image = UIImage(named: imageName) {
                imageView?.image = image
                imageView?.sizeToFit()
                scrollView.contentSize = image.size
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        toggled = false
        resetZoomScale()
    }
    
    func resetZoomScale() {
        if let image = imageView?.image {
            var zoomScale: CGFloat = 1.0
            var contentOffset = CGPoint.zeroPoint
            
            if traitCollection.verticalSizeClass == .Compact || toggled == true {
                zoomScale = CGRectGetWidth(view.frame) / image.size.width
                let verticalSpace = (CGRectGetHeight(view.frame) - (image.size.height * zoomScale)) / 2
                contentOffset = CGPoint(x: 0, y: -verticalSpace)
            }
            else {
                zoomScale = CGRectGetHeight(view.frame) / image.size.height
            }
            
            scrollView.minimumZoomScale = zoomScale
            scrollView.maximumZoomScale = zoomScale
            scrollView.zoomScale = zoomScale
            scrollView.contentOffset = contentOffset
        }
    }
    
    func toggleAction (sender:UIButton) {
        toggled = !toggled
        resetZoomScale()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
