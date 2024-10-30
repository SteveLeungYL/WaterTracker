//
//  WaterTracerApp.swift
//  WaterTracer Watch App
//
//  Created by Yu Liang on 10/26/24.
//

import SwiftUI
import SwiftData

@main
struct WaterTracer_Watch_AppApp: App {
    @StateObject var healthKitManager = HealthKitManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(sharedWaterTracerModelContainer)
    }
}
