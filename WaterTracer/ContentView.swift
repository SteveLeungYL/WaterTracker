//
//  ContentView.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/26/24.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        CupView()
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .inactive {
                    WidgetCenter.shared.reloadAllTimelines()
                } else if newPhase == .background {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @State var configManager = WaterTracerConfigManager()
    
    ContentView()
        .modelContainer(sharedWaterTracerModelContainer)
        .environment(healthKitManager)
        .environment(configManager)
}
