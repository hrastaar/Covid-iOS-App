//
//  ImageDetectionManager.swift
//  CoreImageSwiftUIIntegration
//
//  Created by Mohammad Azam on 8/6/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation
import CoreML
import UIKit

class ImageDetectionManager {
    
    let model = Resnet50()
    
    func detect(_ img: UIImage) -> String? {
        
        guard let pixelBuffer = img.toCVPixelBuffer(),
            let prediction = try? model.prediction(image: pixelBuffer) else {
                return nil
        }
        
        return prediction.classLabel
        
    }
    
}
