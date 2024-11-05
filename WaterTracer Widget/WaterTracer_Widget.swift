//
//  WaterTracer_Widget.swift
//  WaterTracer Widget
//
//  Created by Yu Liang on 11/4/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    
    @State var healthKitManager = HealthKitManager()
    @State var config = WaterTracerConfigManager()
    @State var dataToShown: [HealthMetric] = []
    
    func placeholder(in context: Context) -> SimpleEntry {
        let mockDayData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .hour, value: -24, to: getStartOfDate(date: Date()))!, endDate:getStartOfDate(date: Date()), gapUnit: .hour, isMock: false)
        let mockWeekData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .day, value: -7, to: getStartOfDate(date: Date()))!, endDate:getStartOfDate(date: Date()), gapUnit: .day, isMock: false)
        return SimpleEntry(date: getStartOfDate(date: Date()), configuration: ConfigurationAppIntent(), dayData: mockDayData, weekData: mockWeekData, waterConfig: config)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        do {
            let container = try ModelContainer(for: WaterTracerConfiguration.self)
            let context = ModelContext(container)
            config.updateWaterTracerConfig(modelContext: context)
            _ = await healthKitManager.updateDrinkWaterDay(waterUnitInput: config.waterUnit)
            return SimpleEntry(date: getStartOfDate(date: Date()), configuration: configuration, dayData: healthKitManager.drinkDayData, weekData: healthKitManager.drinkWeekData, waterConfig: config)
        } catch {
            fatalError("Cannot get model container for config. ")
        }
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        do {
            let container = try ModelContainer(for: WaterTracerConfiguration.self)
            let context = ModelContext(container)
            config.updateWaterTracerConfig(modelContext: context)
            _ = await healthKitManager.updateDrinkWaterDay(waterUnitInput: config.waterUnit)
            _ = await healthKitManager.updateDrinkWaterWeek(waterUnitInput: config.waterUnit)
                
            if configuration.chosenView == .hour {
                
                // hour view
                let lastMidnight = getStartOfDate(date: Date())
                let todayMidnight = NSCalendar.current.date(byAdding: .day, value: 1, to: lastMidnight)!
                let nextdayMidnight = NSCalendar.current.date(byAdding: .day, value: 1, to: todayMidnight)!
                
                for hourOffset in 0 ..< 5 {
                    if NSCalendar.current.date(byAdding: .hour, value: hourOffset, to: Date())! >= todayMidnight {
                        let emptyData = fillEmptyData(drinkDataRaw: [], startDate: todayMidnight, endDate: nextdayMidnight, gapUnit: .hour)
                        let entry = SimpleEntry(date: Date(), configuration: configuration, dayData: emptyData, weekData: [], waterConfig: config)
                        entries.append(entry)
                    } else {
                        let entry = SimpleEntry(date: Date(), configuration: configuration, dayData: healthKitManager.drinkDayData, weekData: [], waterConfig: config)
                        entries.append(entry)
                    }
                }
            } else {
                // week view
                for _ in 0 ..< 3 {
                    let entry = SimpleEntry(date: Date(), configuration: configuration, dayData: [], weekData: healthKitManager.drinkWeekData, waterConfig: config)
                    entries.append(entry)
                }
            }
            
            return Timeline(entries: entries, policy: .atEnd)
        } catch {
            fatalError("Cannot get model container for config. ")
        }
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    
    let dayData: [HealthMetric]
    let weekData: [HealthMetric]
    
    let waterConfigMgr: WaterTracerConfigManager
    
    init(date: Date, configuration: ConfigurationAppIntent, dayData: [HealthMetric], weekData: [HealthMetric], waterConfig: WaterTracerConfigManager) {
        self.date = date
        self.configuration = configuration
        self.dayData = dayData
        self.weekData = weekData
        self.waterConfigMgr = waterConfig
    }
}

struct WaterTracer_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            if entry.configuration.chosenView == .week {
                WaterTracingBarChart(chartData: entry.weekData, dateComponents: .day, mainTitle: "Week Tracer", subTitle: "Showing week data", config: entry.waterConfigMgr)
            } else {
                WaterTracingBarChart(chartData: entry.dayData, dateComponents: .hour, mainTitle: "Day Tracer", subTitle: "Showing 24 hours data", config: entry.waterConfigMgr)
            }
        }
    }
}

struct WaterTracer_Widget: Widget {
    let kind: String = "WaterTracer_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WaterTracer_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
    }
}

#Preview(as: .systemMedium) {
    WaterTracer_Widget()
} timeline: {
    let mockingData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .hour, value: -24, to: getStartOfDate(date: Date()))!, endDate: getStartOfDate(date: Date()), gapUnit: .day, isMock: true)
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent(), dayData: mockingData, weekData: [], waterConfig: WaterTracerConfigManager())
}
