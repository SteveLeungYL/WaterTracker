//
//  ContentView.swift
//  WaterTracker
//
//  Created by Yu Liang on 10/26/24.
//

import SwiftUI
import WidgetKit
import UserNotifications

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
#if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad
            
            NavigationSplitView(columnVisibility: .constant(.all)) {
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
            } detail: {
                SummaryView()
            }
            .navigationSplitViewStyle(.balanced)
            
        } else {
            // iPhone
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
#elseif os(visionOS)
        // visionOS
        // Do not support his platform at the moment, because no actual device for testing.
        RingView()
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .inactive {
                    WidgetCenter.shared.reloadAllTimelines()
                } else if newPhase == .background {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
#endif
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @State var configManager = WaterTrackerConfigManager()
    
    ContentView()
        .modelContainer(sharedWaterTrackerModelContainer)
        .environment(healthKitManager)
        .environment(configManager)
}
