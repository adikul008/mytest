//
//  ViewController.swift
//  AdaptiveLayoutTest
//
//  Created by synerzip on 03/09/15.
//  Copyright (c) 2015 synerzip. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let scale1x = UITraitCollection(displayScale: 1.0)
//        let scale2x = UITraitCollection(displayScale: 2.0)
//        let scale3x = UITraitCollection(displayScale: 3.0)
//        
//        let compactHeight = UITraitCollection(verticalSizeClass: .Compact)
//        
//        let image = UIImage(named: "cloud_Small.png")!
//        image.imageAsset.registerImage(UIImage(named: "cloud_Small_2x.png")!, withTraitCollection: scale2x)
//        image.imageAsset.registerImage(UIImage(named: "cloud_Small_3x.png")!, withTraitCollection: scale3x)
//        
//        image.imageAsset.registerImage(UIImage(named: "cloud_Big.png")!, withTraitCollection: UITraitCollection(traitsFromCollections: [scale1x, compactHeight]))
//        image.imageAsset.registerImage(UIImage(named: "cloud_Big_2x.png")!, withTraitCollection: UITraitCollection(traitsFromCollections: [scale2x, compactHeight]))
//        image.imageAsset.registerImage(UIImage(named: "cloud_Big_3x.png")!, withTraitCollection: UITraitCollection(traitsFromCollections: [scale3x, compactHeight]))
//        
//        weatherImage.image = image
        
        if let mapView = mapView {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.498333, longitude: 138.685278), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            mapView.setRegion(region, animated: true)
            mapView.scrollEnabled = false
            mapView.zoomEnabled = false
            mapView.rotateEnabled = false
            mapView.pitchEnabled = false
            mapView.mapType = .Hybrid
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

