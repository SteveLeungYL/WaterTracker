//
//  ContentView.swift
//  WaterTracker Watch App
//
//  Created by Yu Liang on 10/26/24.
//

import SwiftUI
import WidgetKit
import UserNotifications

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        CupView()
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .inactive {
                    WidgetCenter.shared.reloadAllTimelines()
                } else if newPhase == .background {
                    WidgetCenter.shared.reloadAllTimelines()
                } else if newPhase == .active {
                    let center = UNUserNotificationCenter.current()
                    center.removeAllDeliveredNotifications()
                }
            }
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @State var configManager = WaterTrackerConfigManager()
    ContentView()
        .environment(healthKitManager)
        .environment(configManager)
}
