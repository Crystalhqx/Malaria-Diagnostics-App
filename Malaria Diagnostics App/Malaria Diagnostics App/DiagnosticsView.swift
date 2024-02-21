//
//  DiagnosticsView.swift
//  Malaria Diagnostics App
//
//  Created by crystal on 2/20/24.
//

import Foundation
import SwiftUI

struct DiagnosticsView: View {
    var body: some View {
        VStack {
            Text("Your Healthcare Assistant")
                .fontWeight(.bold)
                .padding()

            Button(action: {
            }) {
                Text("Telehealth")
                    .fontWeight(.bold)
                    .frame(maxWidth: 250)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(7)
            }
            .padding(.horizontal)
            
        }
        .navigationTitle("Malaria Diagnostics")
    }
}
