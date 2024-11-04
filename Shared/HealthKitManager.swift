//
//  HealthKitManager.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/28/24.
//


import HealthKit
import WidgetKit

// Copy from
struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

// Move to global scope, so it can be easily called by Previews to mock data. 
func fillEmptyData(drinkDataRaw: [HealthMetric], startDate: Date, endDate: Date, gapUnit: Calendar.Component, isMock: Bool = false) -> [HealthMetric] {
    
    let calendar = NSCalendar.current
    
    // Fill in the empty data with zeros, or random data if using mock == true
    var drinkWeekDataMap: Dictionary<Date, HealthMetric> = [:]
    for curStatistic in drinkDataRaw {
        drinkWeekDataMap[curStatistic.date] = curStatistic
    }
    
    var startDate = startDate
    var drinkWeekDataResult: [HealthMetric] = []
    while (startDate < endDate) {
        if let curStatistic = drinkWeekDataMap[startDate] {
            drinkWeekDataResult.append(curStatistic)
        } else {
            if !isMock {
                drinkWeekDataResult.append(.init(date: startDate, value: 0.0))
            } else {
                drinkWeekDataResult.append(.init(date: startDate, value: Double.random(in: 10.0 ..< 250.0)))
            }
        }
        guard let newStartDate = calendar.date(byAdding: gapUnit, value: 1, to: startDate) else {
            fatalError("*** Unable to iterate date ***")
        }
        startDate = newStartDate
    }
    
    return drinkWeekDataResult
}

@Observable
class HealthKitManager {
    
    var drinkNum: Double = 250.0
    var todayTotalDrinkNum: Double = 0.0 // arbitrary small number
    
    var drinkWeekData: [HealthMetric] = []
    var drinkDayData: [HealthMetric] = []

    static let shared = HealthKitManager()
    var healthStore = HKHealthStore()
    
    // This is the type of data we will be reading from Health (e.g dietaryWater)
    let toReadAndWrite = Set([
        HKObjectType.quantityType(forIdentifier: .dietaryWater)!])
    
    func checkHealthKitAvailability() -> HealthKitError? {
        if HKHealthStore.isHealthDataAvailable() == false {
            return .healthKitNotAvailable
        }
        return nil
    }
    
    func requestAuthorization() -> HealthKitError? {
        
        // This is to make sure device's Heath Data is Avaialble
        if let err = checkHealthKitAvailability() {
            return err
        }
        
        var err: HealthKitError? = nil
        
        // Asking User's permission for their Health Data
        healthStore.requestAuthorization(toShare: toReadAndWrite, read: toReadAndWrite) {
            success, error in
            if !success {
                err = .healthKitNotAvailable
            }
        }
        
        // Check authroization after granted permission.
        if healthStore.authorizationStatus(for: toReadAndWrite.first!) != .sharingAuthorized {
            err = .healthKitNotAuthorized
        }
        
        return err
    }
    
    func saveDrinkWater(drink_num: Double, waterUnitInput: WaterUnits) async -> HealthKitError? {
        if let errMsg = checkHealthKitAvailability() {
            return errMsg
        }
        // Request permission again if the user change the permission outside the app.
        // OK if the permission is already granted. No repeated pop-up screen.
        if let errMsg = requestAuthorization() {
            return errMsg
        }
        
        
        let waterNumType = HKSampleType.quantityType(forIdentifier: .dietaryWater)!
        
        var waterUnit = HKUnit.fluidOunceUS()
        var saving_drink_num_with_correct_unit = drink_num
        if waterUnitInput == .ml {
            waterUnit = HKUnit.liter()
            saving_drink_num_with_correct_unit /= 1000.0
        }
        let waterQuantity = HKQuantity(unit: waterUnit, doubleValue: saving_drink_num_with_correct_unit)
        
        let waterSample = HKQuantitySample(type: waterNumType, quantity: waterQuantity, start: Date(), end: Date())
        
        var ret_err: HealthKitError? = nil
        
        do {
            try await healthStore.save(waterSample)
        } catch {
            ret_err = .healthKitNotAuthorized
        }
        return ret_err
    }
    
    func updateDrinkWaterToday(waterUnitInput: WaterUnits) -> HealthKitError? {
        if let errMsg = checkHealthKitAvailability() {
            return errMsg
        }
        // Request permission again if the user change the permission outside the app.
        // OK if the permission is already granted. No repeated pop-up screen.
        if let errMsg = requestAuthorization() {
            return errMsg
        }
        
        let waterNumType = HKSampleType.quantityType(forIdentifier: .dietaryWater)!
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        guard let lastMidnightDate = calendar.date(from: components) else {
            fatalError("*** Unable to create the start date ***")
        }
         
        guard let todayMidnightDate = calendar.date(byAdding: .day, value: 1, to: lastMidnightDate) else {
            fatalError("*** Unable to create the end date ***")
        }
        
        //1. Use HKQuery to load the most recent samples.
        let todayPredicate = HKQuery.predicateForSamples(withStart: lastMidnightDate,
                                                              end: todayMidnightDate,
                                                              options: [])
        
        let todayDrinkWaterQuery = HKStatisticsQuery(quantityType: waterNumType, quantitySamplePredicate: todayPredicate, options: .cumulativeSum) { (query, statisticsOrNil, errorOrNil) in
            
            guard let statistics = statisticsOrNil else {
                print("Failure to get statistics? Didn't authroize HealthKit?")
                return
            }
            
            let sum = statistics.sumQuantity()
            var waterUnit = HKUnit.fluidOunceUS()
            if waterUnitInput == .ml {
                waterUnit = HKUnit.liter()
            }
            let totalDrinkWaterTodayLiter = sum?.doubleValue(for: waterUnit)
            var totalDrinkWaterTodayML = totalDrinkWaterTodayLiter!
            
            if waterUnitInput == .ml {
                totalDrinkWaterTodayML *= 1000
            }
            
            self.todayTotalDrinkNum = totalDrinkWaterTodayML
        }
        
        // Async read.
        healthStore.execute(todayDrinkWaterQuery)
        
        return nil
    }
    
    func updateDrinkWaterDay(waterUnitInput: WaterUnits) async  -> HealthKitError? {
        // TODO: Merge with updateDrinkWaterWeek
        
        if let errMsg = checkHealthKitAvailability() {
            return errMsg
        }
        // Request permission again if the user change the permission outside the app.
        // OK if the permission is already granted. No repeated pop-up screen.
        if let errMsg = requestAuthorization() {
            return errMsg
        }
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        
        var waterUnit = HKUnit.fluidOunceUS()
        if waterUnitInput == .ml {
            waterUnit = HKUnit.liter()
        }
        
        // Get today.
        guard let hourNow = calendar.date(from: components) else {
            fatalError("*** Unable to create the yesterday ***")
        }
        guard let hourOneDayBefore = calendar.date(byAdding: .hour, value: -24, to: hourNow) else {
            fatalError("*** Unable to create the today date ***")
        }
        
        //1. Use HKQuery to load the most recent samples.
        let oneWeekPredicate = HKQuery.predicateForSamples(withStart: hourOneDayBefore,
                                                         end: hourNow,
                                                           options: [.strictStartDate])
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.dietaryWater), predicate: oneWeekPredicate)
        
        let todayDrinkWaterQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                                         options: .cumulativeSum,
                                                                         anchorDate: hourOneDayBefore,
                                                                         intervalComponents: .init(hour: 1))
        
        do {
            let drinkDayData = try await todayDrinkWaterQuery.result(for: healthStore)
            
            var unitMultiplyer:Double = 1.0
            if waterUnitInput == .ml {
                unitMultiplyer = 1000.0
            }
            
            let drinkDayDataRaw: [HealthMetric] = drinkDayData.statistics().map {
                .init(date: $0.startDate, value: ($0.sumQuantity()?.doubleValue(for: waterUnit) ?? 0.0) * unitMultiplyer)
            }
            
            self.drinkDayData = fillEmptyData(drinkDataRaw: drinkDayDataRaw, startDate: hourOneDayBefore, endDate: hourNow, gapUnit: .hour)
            
        } catch {
            return .healthKitNotAuthorized
        }
        
        return nil
    }
    
    func updateDrinkWaterWeek(waterUnitInput: WaterUnits) async  -> HealthKitError? {
        // TODO: Merge with updateDrinkWaterDay
        
        if let errMsg = checkHealthKitAvailability() {
            return errMsg
        }
        // Request permission again if the user change the permission outside the app.
        // OK if the permission is already granted. No repeated pop-up screen.
        if let errMsg = requestAuthorization() {
            return errMsg
        }
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        var waterUnit = HKUnit.fluidOunceUS()
        if waterUnitInput == .ml {
            waterUnit = HKUnit.liter()
        }
        
        // Get today.
        guard let lastMidnightDate = calendar.date(from: components) else {
            fatalError("*** Unable to create the yesterday ***")
        }
        guard let todayMidnightDate = calendar.date(byAdding: .day, value: 1, to: lastMidnightDate) else {
            fatalError("*** Unable to create the today date ***")
        }
        
        guard let oneWeekBeforeDate = calendar.date(byAdding: .day, value: -7, to: todayMidnightDate) else {
            fatalError("*** Unable to create the begin date ***")
        }
        
        //1. Use HKQuery to load the most recent samples.
        let oneWeekPredicate = HKQuery.predicateForSamples(withStart: oneWeekBeforeDate,
                                                         end: todayMidnightDate,
                                                           options: [.strictStartDate])
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.dietaryWater), predicate: oneWeekPredicate)
        
        let todayDrinkWaterQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                                         options: .cumulativeSum,
                                                                         anchorDate: oneWeekBeforeDate,
                                                                         intervalComponents: .init(day: 1))
        
        do {
            let drinkWeekData = try await todayDrinkWaterQuery.result(for: healthStore)
            
            var unitMultiplyer:Double = 1.0
            if waterUnitInput == .ml {
                unitMultiplyer = 1000.0
            }
            
            let drinkWeekDataRaw: [HealthMetric] = drinkWeekData.statistics().map {
                .init(date: $0.startDate, value: ($0.sumQuantity()?.doubleValue(for: waterUnit) ?? 0.0) * unitMultiplyer)
            }
            
            
            self.drinkWeekData = fillEmptyData(drinkDataRaw: drinkWeekDataRaw, startDate: oneWeekBeforeDate, endDate: todayMidnightDate, gapUnit: .day)
            
        } catch {
            return .healthKitNotAuthorized
        }
        
        return nil
    }

    init() {
        // TODO:: This should not be here.
        // The check should be in the introduction tab view process.
        // FIXME:: Fix later.
        _ = requestAuthorization()
    }
}

enum HealthKitError: LocalizedError {
    case healthKitNotAvailable
    case healthKitNotAuthorized
    
    var errorDescription: String? {
        switch self {
        case .healthKitNotAvailable:
            return "Can't access HealthKit. "
        case .healthKitNotAuthorized:
            return "HealthKit not authrorized. "
        }
    }
        
    var recoverySuggestion: String? {
        switch self {
        case .healthKitNotAvailable:
            return "This app relies sorely on HealthKit from Apple to save data and synchronize between devices. Without HealthKit, the water reminder still works, but no water tracking would be saved. \nTo enable full application features, please use a device that support HealthKit. "
        case .healthKitNotAuthorized:
            return "This app relies sorely on HealthKit from Apple to save data and synchronize between devices. Without HealthKit, the water reminder still works, but no water tracking would be saved. \nTo enable full application features, please enable the HealthKit access in Settings. "
        }
    }
}
