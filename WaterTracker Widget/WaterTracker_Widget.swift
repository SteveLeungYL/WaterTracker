//
//  WaterTracker_Widget.swift
//  WaterTracker Widget
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
        let todayTotalDrinkNum = 2400.0
        let dailyGoal = 3100.0
        return SimpleEntry(date: getStartOfDate(date: Date()), configuration: ConfigurationAppIntent(), todayTotalDrinkNum: todayTotalDrinkNum, dailyGoal: dailyGoal, dayData: mockDayData, weekData: mockWeekData, waterConfig: config)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        do {
            let container = try ModelContainer(for: WaterTrackerConfiguration.self)
            let context = ModelContext(container)
            config.receiveUpdatedWaterTrackerConfig(modelContext: context)
            let todayTotalDrinkNum = 2400.0
            let dailyGoal = 3100.0
            _ = await healthKitManager.updateDrinkWaterOneDay(waterUnitInput: config.waterUnit)
            return SimpleEntry(date: getStartOfDate(date: Date()), configuration: configuration, todayTotalDrinkNum: todayTotalDrinkNum, dailyGoal: dailyGoal, dayData: healthKitManager.drinkDayData, weekData: healthKitManager.drinkWeekData, waterConfig: config)
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
            config.receiveUpdatedWaterTrackerConfig(modelContext: context)
//            _ = healthKitManager.updateDrinkWaterToday(waterUnitInput: config.waterUnit)
            _ = await healthKitManager.updateDrinkWaterOneDay(waterUnitInput: config.waterUnit)
            _ = await healthKitManager.updateDrinkWaterWeek(waterUnitInput: config.waterUnit)
            let todayTotalDrinkNum = healthKitManager.drinkWeekData.last?.value ?? 0.0
            
            if configuration.chosenView == .hour {
                
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
            } else {
                // week view
                // Slightly longer cache time, 3 hours.
                for hourOffset in 0 ..< 3 {
                    let entryDate = NSCalendar.current.date(byAdding: .hour, value: hourOffset, to: Date())!
                    let entry = SimpleEntry(date: entryDate, configuration: configuration, todayTotalDrinkNum: todayTotalDrinkNum, dailyGoal: config.getDailyGoal(), dayData: healthKitManager.drinkDayData, weekData: healthKitManager.drinkWeekData, waterConfig: config)
                    entries.append(entry)
                }
            }
            
            return Timeline(entries: entries, policy: .atEnd)
        } catch {
            fatalError("Cannot get model container for config. ")
        }
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

struct WaterTracker_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            if entry.configuration.chosenView == .week {
                WaterTracingBarChart(chartData: entry.weekData, dateComponents: .day, mainTitle: LocalizedStringKey("Week Water Tracker"), subTitle: LocalizedStringKey("Showing week data"), config: entry.waterConfigMgr)
            } else {
                WaterTracingBarChart(chartData: entry.dayData, dateComponents: .hour, mainTitle: LocalizedStringKey("Day Water Tracker"), subTitle: LocalizedStringKey("Showing 24 hours data"), config: entry.waterConfigMgr)
            }
        }
    }
}

struct WaterTracker_Widget: Widget {
    // FIXME:: TODO:: Present both 24 hour widget and week widget on the widget picker. 
    let kind: String = "WaterTracker_Widget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WaterTracker_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
    }
}

#Preview(as: .systemMedium) {
    WaterTracker_Widget()
} timeline: {
    let mockingData = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .hour, value: -24, to: getStartOfDate(date: Date()))!, endDate: getStartOfDate(date: Date()), gapUnit: .hour, isMock: true)
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent(), todayTotalDrinkNum: 2500.0, dailyGoal: 3100.0, dayData: mockingData, weekData: [], waterConfig: WaterTrackerConfigManager())
}
