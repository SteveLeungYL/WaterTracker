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
        let mockDayData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .hour, value: -24, to: getStartOfDate(date: Date()))!, endDate:getStartOfDate(date: Date()), gapUnit: .hour, isMock: false)
        let mockWeekData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .day, value: -7, to: getStartOfDate(date: Date()))!, endDate:getStartOfDate(date: Date()), gapUnit: .day, isMock: false)
        return SimpleEntry(date: getStartOfDate(date: Date()), configuration: ConfigurationAppIntent(), todayTotalDrinkNum: 3100.0, dailyGoal: 3100.0, dayData: mockDayData, weekData: mockWeekData, waterConfig: config)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        do {
            let container = try ModelContainer(for: WaterTracerConfiguration.self)
            let context = ModelContext(container)
            config.updateWaterTracerConfig(modelContext: context)
            _ = await healthKitManager.updateDrinkWaterDay(waterUnitInput: config.waterUnit)
            _ = await healthKitManager.updateDrinkWaterWeek(waterUnitInput: config.waterUnit)
            return SimpleEntry(date: getStartOfDate(date: Date()), configuration: configuration, todayTotalDrinkNum: 3100.0, dailyGoal: 3100.0, dayData: healthKitManager.drinkDayData, weekData: healthKitManager.drinkWeekData, waterConfig: config)
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
            _ = healthKitManager.updateDrinkWaterToday(waterUnitInput: config.waterUnit)
            _ = await healthKitManager.updateDrinkWaterDay(waterUnitInput: config.waterUnit)
            _ = await healthKitManager.updateDrinkWaterWeek(waterUnitInput: config.waterUnit)
            
            
            // hour view
            let lastMidnight = getStartOfDate(date: Date())
            let todayMidnight = NSCalendar.current.date(byAdding: .day, value: 1, to: lastMidnight)!
            let nextdayMidnight = NSCalendar.current.date(byAdding: .day, value: 1, to: todayMidnight)!
            
            for hourOffset in 0 ..< 3 {
                if NSCalendar.current.date(byAdding: .hour, value: hourOffset, to: Date())! >= todayMidnight {
                    let emptyData = fillEmptyData(drinkDataRaw: [], startDate: todayMidnight, endDate: nextdayMidnight, gapUnit: .hour)
                    let entry = SimpleEntry(date: Date(), configuration: configuration, todayTotalDrinkNum: healthKitManager.todayTotalDrinkNum, dailyGoal: config.getDailyGoal(), dayData: emptyData, weekData: [], waterConfig: config)
                    entries.append(entry)
                } else {
                    let entry = SimpleEntry(date: Date(), configuration: configuration, todayTotalDrinkNum: healthKitManager.todayTotalDrinkNum, dailyGoal: config.getDailyGoal(), dayData: healthKitManager.drinkDayData, weekData: [], waterConfig: config)
                    entries.append(entry)
                }
            }
            
            return Timeline(entries: entries, policy: .atEnd)
        } catch {
            fatalError("Cannot get model container for config. ")
        }
    }
    
    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Water Tracer Widget")]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    
    let todayTotalDrinkNum: Double
    let dailyGoal: Double
    let dayData: [HealthMetric]
    let weekData: [HealthMetric]
    
    let waterConfigMgr: WaterTracerConfigManager
    
    init(date: Date, configuration: ConfigurationAppIntent, todayTotalDrinkNum: Double, dailyGoal: Double, dayData: [HealthMetric], weekData: [HealthMetric], waterConfig: WaterTracerConfigManager) {
        self.date = date
        self.configuration = configuration
        self.todayTotalDrinkNum = todayTotalDrinkNum
        self.dailyGoal = dailyGoal
        self.dayData = dayData
        self.weekData = weekData
        self.waterConfigMgr = waterConfig
    }
}

struct WaterTracer_Watch_WidgetEntryView : View {
    var entry: Provider.Entry
    let isDayView: Bool
    
    var body: some View {
        ZStack {
            if isDayView == false {
                WaterTracingBarChart(chartData: entry.weekData, dateComponents: .day, mainTitle: "Week Tracer", subTitle: "Showing week data", config: entry.waterConfigMgr)
            } else {
                WaterTracingBarChart(chartData: entry.dayData, dateComponents: .hour, mainTitle: "Day Tracer", subTitle: "Showing 24 hours data", config: entry.waterConfigMgr)
            }
        }
    }
}

struct WaterTracer_Watch_Widget: Widget {
    
    var kind: String = "WaterTracer_Watch_Widget"
    var isDayView: Bool = true
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WaterTracer_Watch_WidgetEntryView(entry: entry, isDayView: isDayView)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.accessoryRectangular])
    }
    
    init(isDayView: Bool, kind: String = "WaterTracer_Watch_Widget") {
        self.kind = kind
        self.isDayView = isDayView
    }
    
    init() {
    }
}

#Preview(as: .accessoryRectangular) {
    WaterTracer_Watch_Widget(isDayView: true)
} timeline: {
    let mockingData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .hour, value: -24, to: getStartOfDate(date: Date()))!, endDate: getStartOfDate(date: Date()), gapUnit: .day, isMock: true)
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent(), todayTotalDrinkNum: 3100.0, dailyGoal: 3100.0, dayData: mockingData, weekData: [], waterConfig: WaterTracerConfigManager())
}
