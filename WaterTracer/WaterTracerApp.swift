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
    @StateObject var healthKitManager = HealthKitManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(sharedWaterTracerModelContainer)
    }
}
