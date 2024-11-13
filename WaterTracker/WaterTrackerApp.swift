//
//  WaterTrackerApp.swift
//  WaterTracker
//
//  Created by Yu Liang on 10/26/24.
//

import SwiftUI
import SwiftData

@main
struct WaterTrackerApp: App {
    
    @State var healthKitManager = HealthKitManager()
    @State var configManager = WaterTrackerConfigManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedWaterTrackerModelContainer)
        .environment(healthKitManager)
        .environment(configManager)
    }
}
