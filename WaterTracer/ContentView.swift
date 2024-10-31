//
//  ContentView.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/26/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.cyan, .mint]), startPoint: .top, endPoint: .bottom)
                .clipped()
                .ignoresSafeArea(.all) // As background.
            CupView()
        }
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    ContentView()
        .environment(healthKitManager)
}
