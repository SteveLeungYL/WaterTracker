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
    
    func checkHealthKitAvailability() {
        guard HKHealthStore.isHealthDataAvailable() == true else {
            print("Error: HealthKit is not available on the current device.")
            return
        }
    }
    
    func requestAuthorization() {
        
        // This is to make sure device's Heath Data is Avaialble
        checkHealthKitAvailability()
        
        // Asking User's permission for their Health Data
        healthStore.requestAuthorization(toShare: toReadAndWrite, read: toReadAndWrite) {
            success, error in
            if !success {
                print("Cannot access HealthKit. \(AppName) relies sorely on HealthKit from Apple to save data and syncronize between devices. Please enable the HealthKit access in Settings. ")
            }
        }
    }
    
    func saveDrinkWater(drink_num: Double) {
        checkHealthKitAvailability()
        // Request permission again if the user change the permission outside the app.
        // OK if the permission is already granted. No repeated pop-up screen.
        requestAuthorization()
        
        // TODO:: Save to HealthKit.
        
        return
    }
    
    init() {
        requestAuthorization()
    }
}
