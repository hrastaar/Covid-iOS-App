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
import HapticButton
import SnapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var mapView: MKMapView?
    
    @IBOutlet var showPopoverButton: UIButton!
    @IBOutlet var dismissPopoverButton: UIButton!
    
    @IBOutlet var popupHeadingLabel: UILabel!
    @IBOutlet var confirmedCaseLabel: UILabel!
    @IBOutlet var criticalCaseLabel: UILabel!
    @IBOutlet var deathsLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    var popoverView: CovidPopupView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetup()
        self.mapView = MKMapView(frame: UIScreen.main.bounds)
        mapSetup()
        view.addSubview(mapView!)
        view.sendSubviewToBack(mapView!)
        
        view.backgroundColor = UIColor.black

        popoverView = CovidPopupView()
        view.addSubview(popoverView)
        popoverView.hide()
        popoverView.designPopup()
        showPopoverButton = UIButton(type: .custom)
        showPopoverButton.setButton()
        showPopoverButton.setTitle("Show Covid-19 Data", for: .normal)
        showPopoverButton.addTarget(self, action: #selector(showPopup), for: .touchUpInside)

        dismissPopoverButton = UIButton(type: .custom)
        dismissPopoverButton.setButton()
        dismissPopoverButton.setTitle("Exit", for: .normal)
        dismissPopoverButton.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
        dismissPopoverButton.isHidden = true
    
        view.addSubview(showPopoverButton)
        view.addSubview(dismissPopoverButton)
        
        setButtonLayout()
        view.bringSubviewToFront(showPopoverButton)

    }
    
    // configures map settings
    func mapSetup() {
        self.mapView?.showsUserLocation = true
        self.mapView?.showsTraffic = true
        self.mapView?.showsBuildings = true
        self.mapView?.showsCompass = true
        centerMap()
        self.mapView?.camera = MKMapCamera(lookingAtCenter: locationManager.location?.coordinate ?? CLLocationCoordinate2DMake(-118.2673, 34.0430), fromEyeCoordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2DMake(-118.2673, 34.0430), eyeAltitude: 5000)
        print("Map Configured!")
    }
    
    // add points to the map from our API
    func addPointToMap(latitude: Double, longitude: Double, storeName: String, productName: String) {
        let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: 11.12, longitude: 12.11)
            annotation.title = storeName
            annotation.subtitle = productName

        self.mapView?.addAnnotation(annotation)
        print("Point added at latitude: \(latitude), longitude: \(longitude)")
    }
    
    func clearPointsOnMap() {
        for point in self.mapView!.annotations {
            self.mapView?.removeAnnotation(point)
        }
        print("Removed annotations from map")
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
    @objc func centerMap() {
         // set the location user is at, otherwise just use Staples Center
           var loc: CLLocationCoordinate2D
           loc = locationManager.location?.coordinate ?? CLLocationCoordinate2DMake(-118.2673, 34.0430)
           // update the map
           mapView?.setCenter(loc, animated: true)
           print("Map has been centered to user location")
    }

    @objc func showPopup(_ sender: UIButton){
        self.dismissPopoverButton.isHidden = false
        self.showPopoverButton.isHidden = true

        UIView.animate(withDuration: 0.2, animations: {
            self.popoverView.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 300, height: 300)
            self.popoverView.center = self.view.center
            self.popoverView.alpha = 1
            self.popoverView.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.8)
        },
            completion: {(value: Bool) in
                self.popoverView.show()
        })
    }
    
    @objc func hidePopup(){
        self.dismissPopoverButton.isHidden = true
        self.showPopoverButton.isHidden = false
        self.popoverView.hide()
    }
    
    func setButtonLayout() {
        self.showPopoverButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view).offset(UIScreen.main.bounds.maxY*(5/6))
            make.left.equalTo(view).offset(75)
            make.bottom.equalTo(view).offset(-20)
            make.right.equalTo(view).offset(-75)
        }
        
        self.dismissPopoverButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view).offset(UIScreen.main.bounds.maxY*(5/6))
            make.left.equalTo(view).offset(75)
            make.bottom.equalTo(view).offset(-20)
            make.right.equalTo(view).offset(-75)
        }
    }
    
}

extension UIButton {
    func setButton() {
        self.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.7)
        self.layer.cornerRadius = 15
        self.setTitleColor(.white, for: .normal)
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

