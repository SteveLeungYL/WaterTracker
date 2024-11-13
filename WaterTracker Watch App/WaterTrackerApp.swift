//
//  WaterTrackerApp.swift
//  WaterTracker Watch App
//
//  Created by Yu Liang on 10/26/24.
//

import SwiftUI
import SwiftData

@main
struct WaterTracker_Watch_AppApp: App {
    
    @State private var healthKitManager = HealthKitManager()
    @State private var configManager = WaterTrackerConfigManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedWaterTrackerModelContainer)
        .environment(healthKitManager)
        .environment(configManager)
    }
}
