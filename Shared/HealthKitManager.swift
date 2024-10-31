//
//  HealthKitManager.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/28/24.
//


import HealthKit
import WidgetKit

@Observable
class HealthKitManager {
    
    var drinkNum: Double = 250.0
    var todayTotalDrinkNum: Double = 0.0 // arbitrary small number
    
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
    
    func updateDrinkWaterToday() -> HealthKitError? {
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
            let totalDrinkWaterToday = sum?.doubleValue(for: HKUnit.largeCalorie())
            
            self.todayTotalDrinkNum = totalDrinkWaterToday!
        }
        
        // Async read.
        healthStore.execute(todayDrinkWaterQuery)
        
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
            return "\(AppName) relies sorely on HealthKit from Apple to save data and synchronize between devices. Without HealthKit, the water reminder still works, but no water tracking would be saved. \nTo enable full \(AppName) features, please use a device that support HealthKit. "
        case .healthKitNotAuthorized:
            return "\(AppName) relies sorely on HealthKit from Apple to save data and synchronize between devices. Without HealthKit, the water reminder still works, but no water tracking would be saved. \nTo enable full \(AppName) features, please enable the HealthKit access in Settings. "
        }
    }
}
