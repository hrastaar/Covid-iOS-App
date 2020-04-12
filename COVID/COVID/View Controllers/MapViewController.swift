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
    @IBOutlet var trackingButton: MKUserTrackingButton!
    @IBOutlet var centerButton: UIButton!
    var covidData: CovidData?
    
    @IBOutlet var popupHeadingLabel: UILabel!
    @IBOutlet var confirmedCaseLabel: UILabel!
    @IBOutlet var criticalCaseLabel: UILabel!
    @IBOutlet var deathsLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    
    let showPopoverButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Live Covid Data", for: .normal)
        button.frame = CGRect(x: UIScreen.main.bounds.midX - 87.5, y: (UIScreen.main.bounds.maxY - 125), width: 175, height: 40)
        button.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.9)
        button.setTitleColor(UIColor(red: 1.00, green: 0.004, blue: 0.429, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "D-DIN", size: 20)

        return button
    }()
    let dismissPopoverButton : UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Hide", for: .normal)
            button.frame = CGRect(x: UIScreen.main.bounds.midX - 87.5, y: (UIScreen.main.bounds.maxY - 125), width: 175, height: 40)
           button.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
           button.layer.cornerRadius = 10
           return button
       }()
     let popoverView : UIView = {
        let popoverView = UIView()
        popoverView.layer.cornerRadius = 30
        let removeButton = UIButton()
        removeButton.setTitle("Exit", for: .normal)
        removeButton.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
        popoverView.addSubview(removeButton)
        
        return popoverView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetup()
        mapSetup()
        view.addSubview(mapView!)
        view.sendSubviewToBack(mapView!)
        view.addSubview(showPopoverButton)
        view.bringSubviewToFront(showPopoverButton)
        self.covidData = CovidData()
        // make the style dark mode
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark
        }
        
        centerButton = UIButton()
        centerButton.addTarget(self, action: #selector(centerMap), for: .touchUpInside)
        
        trackingButton = MKUserTrackingButton()
        // add the buttons to the view controller
        view.addSubview(centerButton)
        view.addSubview(trackingButton)
        // push in front of the map view
        view.bringSubviewToFront(centerButton)
        view.bringSubviewToFront(trackingButton)

    }
    
    // configures map settings
    func mapSetup() {
        self.mapView = MKMapView(frame: UIScreen.main.bounds)
        self.mapView?.showsUserLocation = true
        self.mapView?.showsTraffic = true
        self.mapView?.showsBuildings = true
        self.mapView?.showsCompass = true
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
    @objc func centerMap() {
        // set the location user is at, otherwise just use Staples Center
        var loc: CLLocationCoordinate2D
        loc = locationManager.location?.coordinate ?? CLLocationCoordinate2DMake(-118.2673, 34.0430)
        // update the map
        mapView?.setCenter(loc, animated: true)
        print("Map has been centered to user location")
    }

    @objc func showPopup(){
        self.dismissPopoverButton.frame = CGRect(x: popoverView.center.x, y: popoverView.center.y+160, width: 300, height: 300)
        self.dismissPopoverButton.isHidden = false
        self.showPopoverButton.isHidden = true
        popoverView.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0)
        popoverView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.popoverView.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 300, height: 300)
            self.popoverView.center = self.view.center
            self.popoverView.alpha = 1
            self.popoverView.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.8)
            self.view.addSubview(self.popoverView)
            self.view.addSubview(self.dismissPopoverButton)
            
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

}
