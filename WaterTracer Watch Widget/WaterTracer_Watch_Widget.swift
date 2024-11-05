//
//  WaterTracer_Watch_Widget.swift
//  WaterTracer Watch Widget
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
        let mockDayData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .hour, value: -24, to: Date())!, endDate:Date(), gapUnit: .hour, isMock: true)
        let mockWeekData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .day, value: -7, to: Date())!, endDate:Date(), gapUnit: .day, isMock: true)
        return SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), dayData: mockDayData, weekData: mockWeekData, waterConfig: config)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
            do {
                let container = try ModelContainer(for: WaterTracerConfiguration.self)
                let context = ModelContext(container)
                config.updateWaterTracerConfig(modelContext: context)
                _ = await healthKitManager.updateDrinkWaterDay(waterUnitInput: config.waterUnit)
                return SimpleEntry(date: Date(), configuration: configuration, dayData: healthKitManager.drinkDayData, weekData: healthKitManager.drinkWeekData, waterConfig: config)
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
            
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let dataStartDate = healthKitManager.drinkDayData.last?.date ?? currentDate
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: dataStartDate)!
                let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: entryDate)!
                let adjustedData = fillEmptyData(drinkDataRaw: healthKitManager.drinkDayData, startDate: startDate, endDate: entryDate, gapUnit: .hour)
                let entry = SimpleEntry(date: Date(), configuration: configuration, dayData: adjustedData, weekData: [], waterConfig: config)
                entries.append(entry)
            }
            
            return Timeline(entries: entries, policy: .atEnd)
        } catch {
            fatalError("Cannot get model container for config. ")
        }
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Example Widget")]
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

struct WaterTracer_Watch_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            WaterTracingBarChart(chartData: entry.dayData, dateComponents: .hour, mainTitle: "Day Tracer", subTitle: "Showing 24 hours data", config: entry.waterConfigMgr)
        }
    }
}

@main
struct WaterTracer_Watch_Widget: Widget {
    let kind: String = "WaterTracer_Watch_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WaterTracer_Watch_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.accessoryRectangular, .accessoryCorner, .accessoryInline, .accessoryCircular])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .accessoryRectangular) {
    WaterTracer_Watch_Widget()
} timeline: {
    let mockingData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .hour, value: -24, to: Date())!, endDate: Date(), gapUnit: .day, isMock: true)
    SimpleEntry(date: .now, configuration: .smiley, dayData: mockingData, weekData: [], waterConfig: WaterTracerConfigManager())
}
