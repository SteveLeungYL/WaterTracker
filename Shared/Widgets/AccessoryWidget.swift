//
//  Provider.swift
//  WaterTracker
//
//  Created by Yu Liang on 11/5/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct WaterTracker_Accessory_WidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    @ViewBuilder
    var body: some View {
        ZStack {
            switch widgetFamily {
            case .accessoryCircular:
                let progress = max(0.0, min(1.0, entry.todayTotalDrinkNum / entry.dailyGoal))
                ProgressView(value: progress) {
                    Image(systemName: "drop.fill")
                        .rotationEffect(.degrees(180))
                }
                .progressViewStyle(.circular)
                .rotationEffect(.degrees(180))
            case .accessoryCorner:
                // TODO: Change this to a rounded design around the clock.
                // Now it is the same as the accessoryCircular.
                let progress = max(0.0, min(1.0, entry.todayTotalDrinkNum / entry.dailyGoal))
                ProgressView(value: progress) {
                    Image(systemName: "drop.fill")
                        .rotationEffect(.degrees(180))
                }
                .progressViewStyle(.circular)
                .rotationEffect(.degrees(180))
            case .accessoryInline:
                HStack {
                    let waterUnitStr = entry.waterConfigMgr.waterUnit == .ml ? "ml" : "oz"
                    if entry.waterConfigMgr.waterUnit == .ml {
                        let drinkNumStr = String(format: "%d", Int(entry.todayTotalDrinkNum))
                        let leftNumStr = String(format: "%d", max(0, Int(entry.dailyGoal - entry.todayTotalDrinkNum)))
                        Text(LocalizedStringKey("Drink \(drinkNumStr)\(waterUnitStr), \(leftNumStr)\(waterUnitStr) to go"))
                    } else {
                        let drinkNumStr = String(format: "%.1f", entry.todayTotalDrinkNum)
                        let leftNumStr = String(format: "%.1f", max(0.0, entry.dailyGoal - entry.todayTotalDrinkNum))
                        Text(LocalizedStringKey("Drink \(drinkNumStr)\(waterUnitStr), \(leftNumStr)\(waterUnitStr) to go"))
                    }
                }
            case .accessoryRectangular:
                ZStack {
                    let waterUnitStr = entry.waterConfigMgr.waterUnit == .ml ? "ml" : "oz"
                    VStack(alignment: .leading) {
                      Text("Pocket Water Tracker")
                        .font(.headline)
                        .widgetAccentable()
                        
                        if entry.waterConfigMgr.waterUnit == .ml {
                            let drinkNumStr = String(format: "%d", Int(entry.todayTotalDrinkNum))
                            let leftNumStr = String(format: "%d", max(0, Int(entry.dailyGoal - entry.todayTotalDrinkNum)))
                            Text(LocalizedStringKey("Drink \(drinkNumStr)\(waterUnitStr)"))
                            Text(LocalizedStringKey("\(leftNumStr)\(waterUnitStr) to go"))
                        } else {
                            // .oz
                            let drinkNumStr = String(format: "%.1f", entry.todayTotalDrinkNum)
                            let leftNumStr = String(format: "%.1f", max(0.0, entry.dailyGoal - entry.todayTotalDrinkNum))
                            Text(LocalizedStringKey("Drink \(drinkNumStr)\(waterUnitStr)"))
                            Text(LocalizedStringKey("\(leftNumStr)\(waterUnitStr) to go"))
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            default:
                ZStack{
                    // Empty. Should not come here.
                }
            }
        }
    }
}

struct WaterTracker_Accessory_Widget: Widget {
    let kind: String = "WaterTracker_Accessory_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WaterTracker_Accessory_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        #if os(watchOS)
        // .accessoryInline has too limited space for watchOS. might add back later.
        .supportedFamilies([.accessoryCorner, .accessoryCircular, .accessoryRectangular])
        #elseif os(iOS)
        // .accessoryCorner not supported by iOS as of iOS 18.
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
        #endif
    }
}

let mockingData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .hour, value: -24, to: getStartOfDate(date: Date()))!, endDate: getStartOfDate(date: Date()), gapUnit: .day, isMock: true)

#Preview(as: .accessoryCircular) {
    WaterTracker_Accessory_Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent(), todayTotalDrinkNum: 1600.0, dailyGoal: 2400.0, dayData: mockingData, weekData: [], waterConfig: WaterTrackerConfigManager())
}

#Preview(as: .accessoryRectangular) {
    WaterTracker_Accessory_Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent(), todayTotalDrinkNum: 1600.0, dailyGoal: 2400.0, dayData: mockingData, weekData: [], waterConfig: WaterTrackerConfigManager())
}

#if os(iOS)

#Preview(as: .accessoryInline) {
    WaterTracker_Accessory_Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent(), todayTotalDrinkNum: 1600.0, dailyGoal: 2400.0, dayData: mockingData, weekData: [], waterConfig: WaterTrackerConfigManager())
}

#elseif os(watchOS)

#Preview(as: .accessoryCorner) {
    WaterTracker_Accessory_Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent(), todayTotalDrinkNum: 1600.0, dailyGoal: 3100.0, dayData: mockingData, weekData: [], waterConfig: WaterTrackerConfigManager())
}

#endif
