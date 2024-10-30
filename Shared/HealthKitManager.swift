//
//  HealthKitManager.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/28/24.
//


import HealthKit
import WidgetKit

class HealthKitManager: ObservableObject {
    
    static let shared = HealthKitManager()
    var healthStore = HKHealthStore()
    
    // This is the type of data we will be reading from Health (e.g dietaryWater)
    let toReadAndWrite = Set([
        HKObjectType.quantityType(forIdentifier: .dietaryWater)!])
    
    func checkHealthKitAvailability() -> HealthKitError? {
        guard HKHealthStore.isHealthDataAvailable() == true else {
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
    
    func saveDrinkWater(drink_num: Double) -> HealthKitError? {
        if let errMsg = checkHealthKitAvailability() {
            return errMsg
        }
        // Request permission again if the user change the permission outside the app.
        // OK if the permission is already granted. No repeated pop-up screen.
        if let errMsg = requestAuthorization() {
            return errMsg
        }
        
        // TODO:: Save to HealthKit.
        
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
    
    var errorDescription: String? {
        switch self {
        case .healthKitNotAvailable:
          return "Can't access HealthKit. "
        }
      }

      var recoverySuggestion: String? {
        switch self {
        case .healthKitNotAvailable:
          return "\(AppName) relies sorely on HealthKit from Apple to save data and synchronize between devices. Without HealthKit, the water reminder still works, but no water tracking would be saved. \nTo enable full \(AppName) features, please enable the HealthKit access in Settings. "
        }
      }
}
