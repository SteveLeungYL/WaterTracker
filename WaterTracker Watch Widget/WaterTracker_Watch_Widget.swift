//
//  WaterTracker_Watch_Widget.swift
//  WaterTracker Watch Widget
//
//  Created by Yu Liang on 11/4/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    
    @State var healthKitManager = HealthKitManager()
    @State var config = WaterTrackerConfigManager()
    @State var dataToShown: [HealthMetric] = []
    
    func placeholder(in context: Context) -> SimpleEntry {
        let mockDayData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .hour, value: -24, to: getStartOfDate(date: Date()))!, endDate:getStartOfDate(date: Date()), gapUnit: .hour, isMock: false)
        let mockWeekData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .day, value: -7, to: getStartOfDate(date: Date()))!, endDate:getStartOfDate(date: Date()), gapUnit: .day, isMock: false)
        return SimpleEntry(date: getStartOfDate(date: Date()), configuration: ConfigurationAppIntent(), todayTotalDrinkNum: 2400.0, dailyGoal: 3100.0, dayData: mockDayData, weekData: mockWeekData, waterConfig: config)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        do {
            let container = try ModelContainer(for: WaterTrackerConfiguration.self)
            let context = ModelContext(container)
            config.updateWaterTrackerConfig(modelContext: context)
            _ = await healthKitManager.updateDrinkWaterOneDay(waterUnitInput: config.waterUnit)
            _ = await healthKitManager.updateDrinkWaterWeek(waterUnitInput: config.waterUnit)
            return SimpleEntry(date: getStartOfDate(date: Date()), configuration: configuration, todayTotalDrinkNum: 2400.0, dailyGoal: 3100.0, dayData: healthKitManager.drinkDayData, weekData: healthKitManager.drinkWeekData, waterConfig: config)
        } catch {
            fatalError("Cannot get model container for config. ")
        }
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        do {
            let container = try ModelContainer(for: WaterTrackerConfiguration.self)
            let context = ModelContext(container)
            config.updateWaterTrackerConfig(modelContext: context)
//            _ = healthKitManager.updateDrinkWaterToday(waterUnitInput: config.waterUnit)
            _ = await healthKitManager.updateDrinkWaterOneDay(waterUnitInput: config.waterUnit)
            _ = await healthKitManager.updateDrinkWaterWeek(waterUnitInput: config.waterUnit)
            let todayTotalDrinkNum = healthKitManager.drinkWeekData.last?.value ?? 0.0
            
            
            // hour view
            let lastMidnight = getStartOfDate(date: Date())
            let todayMidnight = NSCalendar.current.date(byAdding: .day, value: 1, to: lastMidnight)!
            let nextdayMidnight = NSCalendar.current.date(byAdding: .day, value: 1, to: todayMidnight)!
            
            // Only valid for 2 hours.
            for hourOffset in 0 ..< 2 {
                let entryDate = NSCalendar.current.date(byAdding: .hour, value: hourOffset, to: Date())!
                if entryDate >= todayMidnight {
                    let emptyData = fillEmptyData(drinkDataRaw: [], startDate: todayMidnight, endDate: nextdayMidnight, gapUnit: .hour)
                    let entry = SimpleEntry(date: entryDate, configuration: configuration, todayTotalDrinkNum: todayTotalDrinkNum, dailyGoal: config.getDailyGoal(), dayData: emptyData, weekData: healthKitManager.drinkWeekData, waterConfig: config)
                    entries.append(entry)
                } else {
                    let entry = SimpleEntry(date: entryDate, configuration: configuration, todayTotalDrinkNum: todayTotalDrinkNum, dailyGoal: config.getDailyGoal(), dayData: healthKitManager.drinkDayData, weekData: healthKitManager.drinkWeekData, waterConfig: config)
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
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Water Tracker Widget")]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    
    let todayTotalDrinkNum: Double
    let dailyGoal: Double
    let dayData: [HealthMetric]
    let weekData: [HealthMetric]
    
    let waterConfigMgr: WaterTrackerConfigManager
    
    init(date: Date, configuration: ConfigurationAppIntent, todayTotalDrinkNum: Double, dailyGoal: Double, dayData: [HealthMetric], weekData: [HealthMetric], waterConfig: WaterTrackerConfigManager) {
        self.date = date
        self.configuration = configuration
        self.todayTotalDrinkNum = todayTotalDrinkNum
        self.dailyGoal = dailyGoal
        self.dayData = dayData
        self.weekData = weekData
        self.waterConfigMgr = waterConfig
    }
}

struct WaterTracker_Watch_WidgetEntryView : View {
    var entry: Provider.Entry
    let isDayView: Bool
    
    var body: some View {
        ZStack {
            if isDayView == false {
                WaterTracingBarChart(chartData: entry.weekData, dateComponents: .day, mainTitle: LocalizedStringKey("Week Water Tracker"), subTitle: LocalizedStringKey("Showing week water tracker data"), config: entry.waterConfigMgr)
            } else {
                WaterTracingBarChart(chartData: entry.dayData, dateComponents: .hour, mainTitle: LocalizedStringKey("Day Water Tracker"), subTitle: LocalizedStringKey("Showing 24 hours water tracker data"), config: entry.waterConfigMgr)
            }
        }
    }
}

struct WaterTracker_Watch_Widget: Widget {
    
    var kind: String = "WaterTracker_Watch_Widget"
    var isDayView: Bool = true
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WaterTracker_Watch_WidgetEntryView(entry: entry, isDayView: isDayView)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.accessoryRectangular])
    }
    
    init(isDayView: Bool, kind: String = "WaterTracker_Watch_Widget") {
        self.kind = kind
        self.isDayView = isDayView
    }
    
    init() {
    }
}

#Preview(as: .accessoryRectangular) {
    WaterTracker_Watch_Widget(isDayView: true)
} timeline: {
    let mockingData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .hour, value: -24, to: getStartOfDate(date: Date()))!, endDate: getStartOfDate(date: Date()), gapUnit: .hour, isMock: true)
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent(), todayTotalDrinkNum: 3100.0, dailyGoal: 3100.0, dayData: mockingData, weekData: [], waterConfig: WaterTrackerConfigManager())
}
