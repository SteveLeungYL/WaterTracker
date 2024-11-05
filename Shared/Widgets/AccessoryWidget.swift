//
//  Provider.swift
//  WaterTracer
//
//  Created by Yu Liang on 11/5/24.
//


//
//  WaterTracer_Widget.swift
//  WaterTracer Widget
//
//  Created by Yu Liang on 11/4/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct WaterTracer_Accessory_WidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    @ViewBuilder
    var body: some View {
        ZStack {
            switch widgetFamily {
            case .accessoryCircular:
                let progress = max(0, min(1.0, entry.todayTotalDrinkNum / entry.dailyGoal))
                ProgressView(value: progress) {
                    Image(systemName: "drop.fill")
                        .rotationEffect(.degrees(180))
                }
                .progressViewStyle(.circular)
                .rotationEffect(.degrees(180))
            default:
                ZStack {
                    let waterUnitStr = entry.waterConfigMgr.waterUnit == .ml ? "ml" : "oz"
                    VStack(alignment: .leading) {
                      Text("Water Tracer")
                        .font(.headline)
                        .widgetAccentable()
                        
                        if entry.waterConfigMgr.waterUnit == .ml {
                            Text(String(format:"Drink %d \(waterUnitStr)", Int(entry.todayTotalDrinkNum)))
                                 
                            Text(String(format:"%d \(waterUnitStr) to go", Int(entry.dailyGoal - entry.todayTotalDrinkNum)))
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct WaterTracer_Accessory_Widget: Widget {
    let kind: String = "WaterTracer_Accessory_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WaterTracer_Accessory_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
    }
}

#Preview(as: .accessoryCircular) {
    WaterTracer_Accessory_Widget()
} timeline: {
    let mockingData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .hour, value: -24, to: getStartOfDate(date: Date()))!, endDate: getStartOfDate(date: Date()), gapUnit: .day, isMock: true)
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent(), todayTotalDrinkNum: 3100.0, dailyGoal: 3100.0, dayData: mockingData, weekData: [], waterConfig: WaterTracerConfigManager())
}
