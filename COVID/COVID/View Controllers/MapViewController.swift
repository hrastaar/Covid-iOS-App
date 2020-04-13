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
    var covidData: CovidData?

    
    @IBOutlet var showPopoverButton: UIButton!
    @IBOutlet var dismissPopoverButton: UIButton!
    
    @IBOutlet var popupHeadingLabel: UILabel!
    @IBOutlet var confirmedCaseLabel: UILabel!
    @IBOutlet var criticalCaseLabel: UILabel!
    @IBOutlet var deathsLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    var popoverView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetup()
        self.mapView = MKMapView(frame: UIScreen.main.bounds)
        self.covidData = CovidData()

        mapSetup()
        view.addSubview(mapView!)
        view.sendSubviewToBack(mapView!)
        
        view.backgroundColor = UIColor.black

        popoverView = UIView()
        popoverView.layer.cornerRadius = 25
        popoverView.isHidden = true
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
        view.addSubview(self.popoverView)
        view.addSubview(self.dismissPopoverButton)
        
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
        self.dismissPopoverButton.frame = CGRect(x: popoverView.center.x, y: popoverView.center.y+160, width: 300, height: 300)
        self.dismissPopoverButton.isHidden = false
        self.showPopoverButton.isHidden = true
        popoverView.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0)
        popoverView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.popoverView.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 300, height: 300)
            self.popoverView.center = self.view.center
            self.popoverView.alpha = 1
            self.popoverView.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.8)
            
        }
        updateCovidLabels()

    }
    
    @objc func hidePopup(){
        self.dismissPopoverButton.isHidden = true
        self.showPopoverButton.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.popoverView.frame = CGRect(x:  self.view.center.x, y: self.view.center.y, width: 0, height: 0)
            self.dismissPopoverButton.isHidden = true
            
        },
            completion: {(value: Bool) in
                        self.popoverView.removeFromSuperview()
        })
        popupHeadingLabel.removeFromSuperview()
        confirmedCaseLabel.removeFromSuperview()
        criticalCaseLabel.removeFromSuperview()
        deathsLabel.removeFromSuperview()
        recoveredLabel.removeFromSuperview()
    }
    
    func updateCovidLabels() {
        
        self.popupHeadingLabel = UILabel(frame: CGRect(x: self.view.center.x, y: self.popoverView.center.y-120, width: 300, height: 50))
        self.popupHeadingLabel.center.x = view.center.x
        self.popupHeadingLabel.textAlignment = .center
        self.popupHeadingLabel.font = UIFont(name: "D-DIN", size: 35)
        
        self.confirmedCaseLabel = UILabel(frame: CGRect(x: self.view.center.x, y: self.popoverView.center.y-60, width: 300, height: 50))
        self.confirmedCaseLabel.center.x = view.center.x
        self.confirmedCaseLabel.textAlignment = .center
        self.confirmedCaseLabel.font = UIFont(name: "D-DIN", size: 20)
        
        self.criticalCaseLabel = UILabel(frame: CGRect(x: self.view.center.x, y: self.popoverView.center.y-6, width: 300, height: 50))
        self.criticalCaseLabel.center.x = view.center.x
        self.criticalCaseLabel.textAlignment = .center
        self.criticalCaseLabel.font = UIFont(name: "D-DIN", size: 20)

        self.deathsLabel = UILabel(frame: CGRect(x: self.view.center.x, y: self.popoverView.center.y+47, width: 300, height: 50))
        self.deathsLabel.center.x = view.center.x
        self.deathsLabel.textAlignment = .center
        self.deathsLabel.font = UIFont(name: "D-DIN", size: 20)

        self.recoveredLabel = UILabel(frame: CGRect(x: self.view.center.x, y: self.popoverView.center.y+100, width: 300, height: 50))
        self.recoveredLabel.center.x = view.center.x
        self.recoveredLabel.textAlignment = .center
        self.recoveredLabel.font = UIFont(name: "D-DIN", size: 20)

        view.addSubview(popupHeadingLabel)
        view.addSubview(confirmedCaseLabel)
        view.addSubview(criticalCaseLabel)
        view.addSubview(deathsLabel)
        view.addSubview(recoveredLabel)
        
        self.popupHeadingLabel.text = "Current Covid Data"
        self.confirmedCaseLabel.text = covidData!.confirmedCount + " confirmed cases"
        self.criticalCaseLabel.text = covidData!.criticalCount + " patients in critical condition"
        self.deathsLabel.text = covidData!.deathCount + " people died."
        self.recoveredLabel.text = covidData!.recoveredCount + " people recovered"
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
