//
//  MapViewController.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/9/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import CoreLocation
import SwiftUI

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    var mapView: MKMapView?
    @IBOutlet weak var trackingButton: MKUserTrackingButton?
    @IBOutlet weak var centerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetup()
        mapSetup()
        
        view.addSubview(mapView!)
        
        // make the style dark mode
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark
        }
        
    }
    
    // configures map settings
    func mapSetup() {
        self.mapView = MKMapView(frame: UIScreen.main.bounds)
        self.mapView?.showsUserLocation = true
        self.mapView?.showsTraffic = true
        self.mapView?.showsBuildings = true
        self.mapView?.showsCompass = true
        self.mapView?.cameraZoomRange
        centerMap()
        print("Map Configured!")
    }
    
    func locationSetup() {
        // set location manager data
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        print("Location Setup Complete!")
    }
    
    // update the view to the center
    func centerMap() {
        // set the location user is at, otherwise just use Staples Center
        var loc: CLLocationCoordinate2D
        loc = locationManager.location?.coordinate ?? CLLocationCoordinate2DMake(-118.2673, 34.0430)
        // update the map
        mapView?.setCenter(loc, animated: true)
        print("Map has been centered to user location")
    }
    
}
