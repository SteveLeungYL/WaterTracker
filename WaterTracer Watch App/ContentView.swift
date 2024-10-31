//
//  ContentView.swift
//  WaterTracer Watch App
//
//  Created by Yu Liang on 10/26/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CupView()
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @State var configManager = WaterTracerConfigManager()
    ContentView()
        .environment(healthKitManager)
        .environment(configManager)
}
