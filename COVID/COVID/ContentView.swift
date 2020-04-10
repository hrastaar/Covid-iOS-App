//
//  ContentView.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/8/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {

    let navOptions: [NavigationOption] = [
            NavigationOption(optionName: "Send a Product Update", imageName: "product"),
            NavigationOption(optionName: "Search for a Product", imageName: "search"),
            NavigationOption(optionName: "Check for Covid Update", imageName: "data")
        ]
    
    
    var body: some View {
        MapViewPage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

