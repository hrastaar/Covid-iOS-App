//
//  ImageDetectionViewModel.swift
//  CoreImageSwiftUIIntegration
//
//  Created by Mohammad Azam on 8/6/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ImageDetectionViewModel: ObservableObject {
    
    var name: String = ""
    var manager: ImageDetectionManager
    
    @Published var predictionLabel: String = ""
    
    init(manager: ImageDetectionManager) {
        self.manager = manager
    }
    
    func detect(image: UIImage!) {
                
        guard let resizedImage = image?.resizeImage(targetSize: CGSize(width: 224, height: 224)) else {
            fatalError("Unable to resize the image!")
        }
        
        if let label = self.manager.detect(resizedImage) {
            self.predictionLabel = label
        }
      
    }
    
}
