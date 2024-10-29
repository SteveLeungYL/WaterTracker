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
    
    func requestAuthorization() {
        // this is the type of data we will be reading from Health (e.g stepCount)
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!])
        
        // this is to make sure User's Heath Data is Avaialble
        guard HKHealthStore.isHealthDataAvailable() == true else {
            print("health data not available!")
            return
        }
        
        // asking User's permission for their Health Data
        // note: toShare is set to nil since I'm not updating any data
        healthStore.requestAuthorization(toShare: toReads, read: toReads) {
            success, error in
            if success {
//                self.fetchAllDatas()
            } else {
                print("\(String(describing: error))")
            }
        }
    }
    
    init() {
        requestAuthorization()
    }
}
