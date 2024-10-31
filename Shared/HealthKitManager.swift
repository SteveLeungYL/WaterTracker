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
        
        return err
    }
    
    func saveDrinkWater(drink_num: Double, config: WaterTracerConfiguration) async -> HealthKitError? {
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
        if config.waterUnit == .ml {
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
