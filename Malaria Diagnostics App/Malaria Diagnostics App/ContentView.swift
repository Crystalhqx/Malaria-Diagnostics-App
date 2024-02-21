//
//  ContentView.swift
//  Malaria Diagnostics App
//
//  Created by crystal on 2/11/24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        // Tabs
        TabView {
            // Home Page Tab
            HomePageView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            // Image Analysis Tab
            ImageAnalysisView()
                .tabItem {
                    Image(systemName: "camera")
                    Text("Image Analysis")
                }
            
            // Diagnostics Tab
            DiagnosticsView()
                .tabItem {
                    Image(systemName: "heart.text.square")
                    Text("Diagnostics")
                }
            
            // Other tabs
            Text("Other Features")
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("More")
                }
        }
    }
}

