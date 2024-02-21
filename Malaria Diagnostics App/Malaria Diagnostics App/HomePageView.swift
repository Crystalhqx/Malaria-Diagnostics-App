//
//  HomePageView.swift
//  Malaria Diagnostics App
//
//  Created by crystal on 2/20/24.
//

import Foundation
import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("All About Malaria Care In One App")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Image("homepage")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 50)

                NavigationLink(destination: ImageAnalysisView()) {
                    Text("Get Started")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: 250)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
    }
}

