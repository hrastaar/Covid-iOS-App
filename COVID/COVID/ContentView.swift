//
//  ContentView.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/8/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var tester = CovidData();
    

    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
