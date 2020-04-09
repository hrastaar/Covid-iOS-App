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
        
        NavigationView {
            List {
                VStack {
                    Section(header: Text("Options")) {
                        NavigationLink(destination: CovidDataView()) {
                            HStack {
                                Image("data")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    
                                Text("Live Covid Data")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

