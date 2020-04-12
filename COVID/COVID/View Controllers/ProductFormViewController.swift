//
//  ProductFormViewController.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/10/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import Foundation
import UIKit
import CoreML
import CoreLocation
import AVFoundation
import Vision
import Combine

// a form that will allow user to select essential item, take a picture as proof, and use CoreML to process if a legitimate product
class ProductFormViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    

    @IBOutlet var productName: String!
    var locationManager: CLLocationManager!
    var imageSelected: UIImage!
    
    
    let uploadImageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload Picture", for: .normal)
        button.frame = CGRect(x: UIScreen.main.bounds.midX - 100, y: 200, width: 200, height: 40)
        button.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.9)
        button.setTitleColor(UIColor(red: 1.00, green: 0.004, blue: 0.429, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "D-DIN", size: 20)

        return button
    }()
        
    override func viewDidLoad() {
        view.addSubview(uploadImageButton)
       
        print("Loaded the product page")
    }

    
    func setupLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        print("Location Setup Complete!")
    }
    
    // opens image picker, where user can take a picture
    @objc func takePicture() {
        print("Take Picture Called")
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        self.imageSelected = image

        // print out the image size as a test
        print(image.size)
        

    }
}
