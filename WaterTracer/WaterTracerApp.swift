//
//  WaterTracerApp.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/26/24.
//

import SwiftUI
import SwiftData

@main
struct WaterTracerApp: App {
    
    @State private var healthKitManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedWaterTracerModelContainer)
        .environment(healthKitManager)
    }
}
